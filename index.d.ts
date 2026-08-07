export interface EyePrologStats {
  [key: string]: number;
}

export interface EyePrologRunOptions {
  /** A host-supplied goal, expressed as Prolog text or a parsed term. */
  goal?: string | EyePrologTerm;
  /** Host-supplied goals, executed in order. */
  goals?: Array<string | EyePrologTerm>;
  proof?: boolean;
  why?: boolean;
  explain?: boolean;
  maxDepth?: number;
  solutionLimit?: number;
  registry?: BuiltinRegistry;
  sourceMetadata?: boolean;
  strictNegation?: boolean;
  analyzeNegation?: boolean;
  /** Initial ISO interpretation of double-quoted list notation. Defaults to chars. */
  doubleQuotes?: 'chars' | 'codes' | 'atom';
  ioOptions?: {
    input?: string;
    write?: (text: string) => void;
  };
  [key: string]: unknown;
}

export interface EyePrologRunResult {
  stdout: string;
  stats: EyePrologStats;
  haltCode: number | null;
}

export class StreamManager {
  constructor(options?: { input?: string; write?: (text: string) => void });
  streams: Map<number, unknown>;
  aliases: Map<string, number>;
  currentInput: number;
  currentOutput: number;
}

export interface EyePrologSourcePart {
  text?: string;
  source?: string;
  filename?: string;
  baseDir?: string;
}

export interface EyePrologClause {
  head: EyePrologTerm;
  body: EyePrologTerm[];
  index?: number;
  filename?: string;
  clauseNumber?: number;
}

export interface EyePrologPredicateGroup {
  name: string;
  arity: number;
  clauses: EyePrologClause[];
  argIndexes: unknown[];
  demandIndexes: Map<string, unknown>;
  rejectedDemandIndexes: Set<string>;
  tabled: boolean;
  recursive: boolean;
  tableInputPositions: number[];
  negationStratum: number | null;
}

export type EyePrologTerm = Term | { type: string; name: string; args?: EyePrologTerm[]; arity?: number };

export class Term {
  constructor(type: string, name?: unknown, args?: EyePrologTerm[]);
  type: string;
  name: string;
  args: EyePrologTerm[];
  get arity(): number;
}

export class Env {
  constructor(bindings?: Iterable<readonly [string, EyePrologTerm]> | null);
  bindings: Map<string, EyePrologTerm>;
  clone(): Env;
  has(name: string): boolean;
  get(name: string): EyePrologTerm | undefined;
  bind(name: string, term: EyePrologTerm): void;
}

export class Program {
  constructor(clauses?: EyePrologClause[], options?: EyePrologRunOptions);
  clauses: EyePrologClause[];
  groups: Map<string, EyePrologPredicateGroup>;
  doubleQuotes: 'chars' | 'codes' | 'atom';
  negationDependencies: Array<{ from: string; to: string; negative: boolean }>;
  negationStratificationErrors: Array<{ from: string; to: string }>;
  stratifiedNegation: boolean;
  static parse(source: string, options?: EyePrologRunOptions): Program;
  static parseSources(sources?: Array<string | EyePrologSourcePart>, options?: EyePrologRunOptions): Program;
  makeGroup(name: string, arity: number): EyePrologPredicateGroup;
  indexClause(clause: EyePrologClause): void;
  findGroup(name: string, arity: number): EyePrologPredicateGroup | null;
  markRecursivePredicates(): void;
  analyzeNegationStratification(): Array<{ from: string; to: string }>;
  assertStratifiedNegation(): true;
  isStratifiedNegation(): boolean;
  groupHasRule(group: EyePrologPredicateGroup): boolean;
  sourceFactLines(predicateKeys?: Set<string> | null, options?: { doubleQuotes?: 'chars' | 'codes' | 'atom' }): Set<string>;
}

export interface BuiltinDefinition {
  name: string;
  arity: number;
  handler: BuiltinHandler;
  deterministic: boolean;
  ready: ((goal: EyePrologTerm, env: Env) => boolean) | null;
  fallbackWhenNotReady: boolean;
  shouldUse: ((context: { solver: Solver; goal: EyePrologTerm; env: Env }) => boolean) | null;
  eyePrologLibrary: boolean;
}

export type BuiltinHandler = (context: { solver: Solver; goal: EyePrologTerm; env: Env }) => Iterable<Env>;

export class BuiltinRegistry {
  constructor();
  defs: Map<string, BuiltinDefinition>;
  eyePrologLibrary?: boolean;
  add(name: string, arity: number, handler: BuiltinHandler, options?: Partial<BuiltinDefinition>): this;
  get(name: string, arity: number): BuiltinDefinition | null;
}

export class Solver {
  constructor(program: Program, options?: EyePrologRunOptions);
  program: Program;
  registry: BuiltinRegistry;
  maxDepth: number;
  solutionLimit: number;
  solutionsSeen: number;
  active: unknown[];
  memo: Map<string, unknown>;
  stats: EyePrologStats;
  cloneForInnerGoal(solutionLimit?: number): Solver;
  solve(goals: EyePrologTerm | EyePrologTerm[], env?: Env, depth?: number): Iterable<Env>;
  activeVariant(goal: EyePrologTerm, env: Env): boolean;
}

export const VAR: 'var';
export const ATOM: 'atom';
export const STRING: 'string';
export const NUMBER: 'number';
export const COMPOUND: 'compound';

export function variable(name: string): Term;
export function atom(name: string): Term;
export function stringTerm(value: string): Term;
export function numberTerm(value: string | number): Term;
/** Construct a compound term; an empty argument list is canonicalized to atom(name). */
export function compound(name: string, args?: EyePrologTerm[]): Term;
export function emptyList(): Term;
export function cons(head: EyePrologTerm, tail: EyePrologTerm): Term;
export function deref(term: EyePrologTerm, env: Env): EyePrologTerm;
export function isScalar(term: EyePrologTerm | null | undefined): boolean;
export function isEmptyList(term: EyePrologTerm | null | undefined): boolean;
export function isCons(term: EyePrologTerm | null | undefined): boolean;
export function isConjunction(term: EyePrologTerm | null | undefined): boolean;
export function unify(left: EyePrologTerm, right: EyePrologTerm, env: Env): boolean;
export function cloneTerm(term: EyePrologTerm): Term;
export function freshTerm(term: EyePrologTerm, suffix: string | number): Term;
export function copyResolved(term: EyePrologTerm, env: Env): Term;
export function termIsGround(term: EyePrologTerm, env?: Env): boolean;
export function termToString(term: EyePrologTerm, env?: Env, quoteStrings?: boolean): string;
export function lexicalValue(term: EyePrologTerm, env: Env): string | null;
export function properListItems(list: EyePrologTerm, env: Env): EyePrologTerm[] | null;
export function listFromItems(items: EyePrologTerm[], start?: number, end?: number, tail?: EyePrologTerm): Term;
export function flattenConjunction(goal: EyePrologTerm): EyePrologTerm[];
export function termSignature(term: EyePrologTerm | null | undefined): string | null;
export function variantTerms(left: EyePrologTerm, leftEnv: Env, right: EyePrologTerm, rightEnv: Env, pairs?: Map<string, string>, reverse?: Map<string, string>): boolean;
export function compareTerms(left: EyePrologTerm, right: EyePrologTerm): number;
export function isDecimalInteger(text: string | null | undefined): boolean;
export function compareIntegerText(left: string, right: string): number;
export function parseFiniteNumber(text: string | null | undefined): number | null;
export function numberTextFromDouble(value: number): string | null;
export function compareNumberText(left: string, right: string): number;

export function makeProgram(source: string, options?: EyePrologRunOptions): Program;
export function parseClauses(source: string, options?: EyePrologRunOptions): EyePrologClause[];
export function parseProgramText(source: string, options?: EyePrologRunOptions): EyePrologClause[];
export function parseGoalText(source: string, options?: EyePrologRunOptions): EyePrologTerm;
export function createDefaultRegistry(): BuiltinRegistry;
export function createEyePrologRegistry(): BuiltinRegistry;
export function getDefaultRegistry(): BuiltinRegistry;
export function getEyePrologRegistry(): BuiltinRegistry;
export function ensureEyePrologLibrary(program: Program): Program;
export const eyePrologLibraryIndicators: readonly string[];
export const eyePrologNativeLibraryIndicators: readonly string[];
export const eyePrologPortableLibraryIndicators: readonly string[];
export class PrologError extends Error {
  formal: string;
  culprit: EyePrologTerm | null;
}

export class HaltSignal extends Error {
  name: 'HaltSignal';
  code: number;
  constructor(code?: number);
}
export function run(source: string | Program, options?: EyePrologRunOptions): EyePrologRunResult;
export function whyProof(program: Program, goal: EyePrologTerm, options?: EyePrologRunOptions): { ok: boolean; text: string };
export function whyNoProof(goal: EyePrologTerm): string;
export function explainProof(program: Program, goal: EyePrologTerm, options?: EyePrologRunOptions): { ok: boolean; text: string };

declare const eyeprolog: {
  VAR: typeof VAR;
  ATOM: typeof ATOM;
  STRING: typeof STRING;
  NUMBER: typeof NUMBER;
  COMPOUND: typeof COMPOUND;
  Term: typeof Term;
  Env: typeof Env;
  Program: typeof Program;
  Solver: typeof Solver;
  BuiltinRegistry: typeof BuiltinRegistry;
  PrologError: typeof PrologError;
  variable: typeof variable;
  atom: typeof atom;
  stringTerm: typeof stringTerm;
  numberTerm: typeof numberTerm;
  compound: typeof compound;
  emptyList: typeof emptyList;
  cons: typeof cons;
  deref: typeof deref;
  isScalar: typeof isScalar;
  isEmptyList: typeof isEmptyList;
  isCons: typeof isCons;
  isConjunction: typeof isConjunction;
  unify: typeof unify;
  cloneTerm: typeof cloneTerm;
  freshTerm: typeof freshTerm;
  copyResolved: typeof copyResolved;
  termIsGround: typeof termIsGround;
  termToString: typeof termToString;
  lexicalValue: typeof lexicalValue;
  properListItems: typeof properListItems;
  listFromItems: typeof listFromItems;
  flattenConjunction: typeof flattenConjunction;
  termSignature: typeof termSignature;
  variantTerms: typeof variantTerms;
  compareTerms: typeof compareTerms;
  isDecimalInteger: typeof isDecimalInteger;
  compareIntegerText: typeof compareIntegerText;
  parseFiniteNumber: typeof parseFiniteNumber;
  numberTextFromDouble: typeof numberTextFromDouble;
  compareNumberText: typeof compareNumberText;
  makeProgram: typeof makeProgram;
  parseClauses: typeof parseClauses;
  parseProgramText: typeof parseProgramText;
  createDefaultRegistry: typeof createDefaultRegistry;
  createEyePrologRegistry: typeof createEyePrologRegistry;
  getDefaultRegistry: typeof getDefaultRegistry;
  getEyePrologRegistry: typeof getEyePrologRegistry;
  ensureEyePrologLibrary: typeof ensureEyePrologLibrary;
  eyePrologLibraryIndicators: typeof eyePrologLibraryIndicators;
  eyePrologNativeLibraryIndicators: typeof eyePrologNativeLibraryIndicators;
  eyePrologPortableLibraryIndicators: typeof eyePrologPortableLibraryIndicators;
  run: typeof run;
  whyProof: typeof whyProof;
  whyNoProof: typeof whyNoProof;
  explainProof: typeof explainProof;
};

export default eyeprolog;
