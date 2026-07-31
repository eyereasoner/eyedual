// Browser worker entry used by playground.html.
// Keep this module free of Node-only imports: it is fetched directly by the
// browser and is also exercised by test/run-playground.mjs.
import { run } from './index.js?playground=20260731c';
import { createLibraryRegistry } from './library.js?playground=20260731c';
import { portableLibrarySource } from './portable-library.js?playground=20260731c';

const registry = createLibraryRegistry();
// Install the portable clauses explicitly so a playground run never depends on
// a caller remembering a CLI/API option or on an implicit registry choice.
registry.portableSource = portableLibrarySource;

export function executePlaygroundRequest(data, now = defaultNow) {
  const started = now();
  try {
    const result = run(data?.source ?? '', {
      ...(data?.options ?? {}),
      registry,
    });
    return {
      ok: true,
      stdout: result.stdout,
      stats: result.stats,
      haltCode: result.haltCode,
      elapsedMs: Math.max(0, now() - started),
    };
  } catch (error) {
    return {
      ok: false,
      code: error?.code,
      stdout: error?.stdout,
      error: error?.stack || error?.message || String(error),
    };
  }
}

export function installPlaygroundWorker(scope) {
  scope.onmessage = (event) => {
    scope.postMessage(executePlaygroundRequest(event.data));
  };
}

function defaultNow() {
  return globalThis.performance?.now?.() ?? Date.now();
}

if (typeof self !== 'undefined' && typeof self.postMessage === 'function') {
  installPlaygroundWorker(self);
}
