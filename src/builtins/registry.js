// Registry for builtins and their execution metadata.
// The solver uses the metadata to know when a builtin is deterministic, mode-ready, or should fall back to user clauses.
import { isoBuiltins } from './iso.js';
import { arithmeticBuiltins } from './arithmetic.js';
import { coreBuiltins } from './core.js';
import { stringBuiltins } from './strings.js';
import { listBuiltins } from './lists.js';
import { aggregationBuiltins } from './aggregation.js';
import { contextBuiltins } from './context.js';
import { controlBuiltins } from './control.js';
import { termBuiltins } from './terms.js';

export class BuiltinRegistry {
  constructor() {
    this.defs = new Map();
  }
  add(name, arity, handler, options = {}) {
    // ready() describes the argument mode in which the builtin is safe to run;
    // fallbackWhenNotReady keeps user-defined clauses visible outside that mode.
    this.defs.set(`${name}/${arity}`, {
      name,
      arity,
      handler,
      deterministic: options.deterministic ?? false,
      ready: options.ready ?? null,
      fallbackWhenNotReady: options.fallbackWhenNotReady ?? false,
      shouldUse: options.shouldUse ?? null,
    });
    return this;
  }
  get(name, arity) {
    return this.defs.get(`${name}/${arity}`) ?? null;
  }
}

export function createDefaultRegistry() {
  const registry = new BuiltinRegistry();
  isoBuiltins.register(registry);
  return registry;
}

export function createLibraryRegistry() {
  const registry = new BuiltinRegistry();
  for (const mod of [
    coreBuiltins,
    arithmeticBuiltins,
    stringBuiltins,
    listBuiltins,
    aggregationBuiltins,
    contextBuiltins,
    controlBuiltins,
    termBuiltins,
    isoBuiltins,
  ]) {
    mod.register(registry);
  }
  return registry;
}

let defaultRegistry = null;
let libraryRegistry = null;

export function getDefaultRegistry() {
  if (defaultRegistry == null) defaultRegistry = createDefaultRegistry();
  return defaultRegistry;
}

export function getLibraryRegistry() {
  if (libraryRegistry == null) libraryRegistry = createLibraryRegistry();
  return libraryRegistry;
}
