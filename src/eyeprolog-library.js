// Load and autoload the pure-Prolog EyeProlog library in Node and the browser.
import { createDefaultRegistry } from './iso.js';
import { parseClauses } from './parser.js';
import { fs, isNode } from './platform.js';

export const eyePrologNativeLibraryIndicators = Object.freeze([]);

export const eyePrologPortableLibraryIndicators = Object.freeze([
  'uuid/3',
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
  'random/3',
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

const autoloadedPrograms = new WeakSet();
const libraryUrl = new URL('./eyeprolog-library.pl', import.meta.url);
const librarySource = await loadLibrarySource(libraryUrl);
const portableClauseTemplates = parseClauses(librarySource, {
  filename: 'src/eyeprolog-library.pl',
  sourceMetadata: true,
});

async function loadLibrarySource(url) {
  if (isNode) return fs.readFileSync(url, 'utf8');
  const response = await fetch(url);
  if (!response.ok) throw new Error(`could not load EyeProlog library: ${response.status}`);
  return response.text();
}

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
  const registry = createDefaultRegistry();
  registry.eyePrologLibrary = true;
  return registry;
}

let eyePrologRegistry = null;

export function getEyePrologRegistry() {
  if (eyePrologRegistry == null) eyePrologRegistry = createEyePrologRegistry();
  return eyePrologRegistry;
}
