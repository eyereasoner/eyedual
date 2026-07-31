// Runtime-specific capabilities shared by the Node CLI and browser build.
// Keep Node built-ins behind a guarded dynamic import so browser module workers
// can load the reasoner without trying to resolve `node:*` specifiers.
const isNode = typeof process !== 'undefined' && Boolean(process.versions?.node);

let fs = null;
let path = null;
let BufferCtor = null;

if (isNode) {
  ({ default: fs } = await import('node:fs'));
  ({ default: path } = await import('node:path'));
  BufferCtor = globalThis.Buffer ?? null;
}

export { fs, path, BufferCtor, isNode };

export function currentWorkingDirectory() {
  return isNode && typeof process.cwd === 'function' ? process.cwd() : '/';
}
