// EyeProlog library integration.
//
// 48 of the 50 public library predicates are implemented in plain Prolog in
// eyeprolog-library.pl and autoloaded into every Solver that uses the EyeProlog
// registry.  Only uuid/1 and local_time/1 remain native because ISO Prolog has
// no standard entropy or wall-clock primitive.
import {
  atom,
  unify,
} from './term.js';
import {
  BuiltinRegistry,
  isoBuiltins,
} from './iso.js';
import { parseClauses } from './parser.js';
import { eyePrologPortableLibrarySource } from './library-source.js';

export const eyePrologNativeLibraryIndicators = Object.freeze([
  'uuid/1',
  'local_time/1',
]);

export const eyePrologPortableLibraryIndicators = Object.freeze([
  'difference/3',
  'call/3',
  'maplist/3',
  'tan/2',
  'asin/2',
  'acos/2',
  'atan2/3',
  'lt/2',
  'gt/2',
  'le/2',
  'ge/2',
  'between/3',
  'smallest_divisor_from/3',
  'matches/3',
  'split/3',
  'replace/4',
  'lowercase/2',
  'uppercase/2',
  'trim/2',
  'number_string/2',
  'atom_string/2',
  'term_string/2',
  'append/3',
  'string_concat/3',
  'contains/2',
  'matches/2',
  'join/3',
  'substring/4',
  'member/2',
  'select/3',
  'last/2',
  'nth0/3',
  'nth1/3',
  'set_nth0/4',
  'take/3',
  'drop/3',
  'slice/4',
  'reverse/2',
  'length/2',
  'sum_list/2',
  'min_list/2',
  'max_list/2',
  'list_to_set/2',
  'sort/2',
  'countall/2',
  'sumall/3',
  'aggregate_min/5',
  'aggregate_max/5',
]);

export const eyePrologLibraryIndicators = Object.freeze([
  ...eyePrologNativeLibraryIndicators,
  ...eyePrologPortableLibraryIndicators,
]);

const portableIndicatorSet = new Set(eyePrologPortableLibraryIndicators);
const autoloadedPrograms = new WeakSet();
const portableClauseTemplates = parseClauses(eyePrologPortableLibrarySource, {
  filename: 'src/eyeprolog-library.pl',
  sourceMetadata: true,
});


export function ensureEyePrologLibrary(program) {
  if (autoloadedPrograms.has(program)) return program;

  // User clauses already present in the Program stay first in clause order;
  // the autoloaded library clauses are appended as defaults. This preserves
  // useful source specializations such as length(numbers,N) while still making
  // the relational length(List,N) library clauses available inside them.
  let added = 0;
  for (const template of portableClauseTemplates) {
    // Clause terms are immutable; clone only the mutable indexing shell so the
    // cached parse can be safely shared across independent Program instances.
    const clause = {
      ...template,
      body: template.body.slice(),
      index: program.clauses.length,
      eyePrologLibraryPortable: true,
    };
    program.clauses.push(clause);
    program.indexClause(clause);
    added++;
  }
  if (added > 0) program.markRecursivePredicates();
  autoloadedPrograms.add(program);
  return program;
}

export function createEyePrologRegistry() {
  const registry = new BuiltinRegistry();
  registry.eyePrologLibrary = true;

  registry.add('uuid', 1, uuidBuiltin, {
    deterministic: true,
    eyePrologLibrary: true,
  });
  registry.add('local_time', 1, localTimeBuiltin, {
    deterministic: true,
    eyePrologLibrary: true,
  });
  // ISO definitions take precedence where names overlap and remain identifiable
  // as ISO rather than EyeProlog-library predicates.
  isoBuiltins.register(registry);
  return registry;
}

let eyePrologRegistry = null;

export function getEyePrologRegistry() {
  if (eyePrologRegistry == null) eyePrologRegistry = createEyePrologRegistry();
  return eyePrologRegistry;
}

function* uuidBuiltin({ goal, env }) {
  const next = env.clone();
  if (unify(goal.args[0], atom(randomUuidV4()), next)) yield next;
}

function* localTimeBuiltin({ goal, env }) {
  const next = env.clone();
  if (unify(goal.args[0], atom(localDateText()), next)) yield next;
}

function randomUuidV4() {
  const cryptoApi = globalThis.crypto;
  if (typeof cryptoApi?.randomUUID === 'function') return cryptoApi.randomUUID();
  const bytes = new Uint8Array(16);
  if (typeof cryptoApi?.getRandomValues === 'function') {
    cryptoApi.getRandomValues(bytes);
  } else {
    for (let index = 0; index < bytes.length; index++) bytes[index] = Math.floor(Math.random() * 256);
  }
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  const hex = Array.from(bytes, (byte) => byte.toString(16).padStart(2, '0'));
  return `${hex.slice(0, 4).join('')}-${hex.slice(4, 6).join('')}-${hex.slice(6, 8).join('')}-${hex.slice(8, 10).join('')}-${hex.slice(10).join('')}`;
}

function localDateText() {
  const fixed = typeof process !== 'undefined' ? process.env?.EYEPROLOG_LOCAL_TIME : null;
  if (fixed) return fixed;
  const now = new Date();
  const yyyy = now.getFullYear();
  const mm = String(now.getMonth() + 1).padStart(2, '0');
  const dd = String(now.getDate()).padStart(2, '0');
  return `${yyyy}-${mm}-${dd}`;
}
