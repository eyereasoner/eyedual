export interface EyeplStats {
  [key: string]: number;
}

export interface EyeplRunOptions {
  proof?: boolean;
  why?: boolean;
  explain?: boolean;
  maxDepth?: number;
  solutionLimit?: number;
  registry?: BuiltinRegistry;
  sourceMetadata?: boolean;
  markRecursive?: boolean;
  strictNegation?: boolean;
  analyzeNegation?: boolean;
  ioOptions?: {
    input?: string;
    write?: (text: string) => void;
  };
  [key: string]: unknown;
}

export interface EyeplRunResult {
  stdout: string;
  stats: EyeplStats;
  haltCode: number | null;
}

export class StreamManager {
  constructor(options?: { input?: string; write?: (text: string) => void });
  streams: Map<number, unknown>;
  aliases: Map<string, number>;
  currentInput: number;
  currentOutput: number;
}

export interface EyeplSourcePart {
  text?: string;
  source?: string;
  filename?: string;
  baseDir?: string;
}

export interface EyeplClause {
  head: EyeplTerm;
  body: EyeplTerm[];
  index?: number;
  filename?: string;
  clauseNumber?: number;
}

export interface EyeplPredicateGroup {
  name: string;
  arity: number;
  clauses: EyeplClause[];
  argIndexes: unknown[];
  demandIndexes: Map<string, unknown>;
  rejectedDemandIndexes: Set<string>;
  tabled: boolean;
  mode: string[] | null;
  determinism: 'det' | 'semidet' | null;
  recursive: boolean;
  tableInputPositions: number[];
  negationStratum: number | null;
}

export type EyeplTerm = Term | { type: string; name: string; args?: EyeplTerm[]; arity?: number };

export class Term {
  constructor(type: string, name?: unknown, args?: EyeplTerm[]);
  type: string;
  name: string;
  args: EyeplTerm[];
  get arity(): number;
}

export class Env {
  constructor(bindings?: Iterable<readonly [string, EyeplTerm]> | null);
  bindings: Map<string, EyeplTerm>;
  clone(): Env;
  has(name: string): boolean;
  get(name: string): EyeplTerm | undefined;
  bind(name: string, term: EyeplTerm): void;
}

export class Program {
  constructor(clauses?: EyeplClause[], options?: EyeplRunOptions);
  clauses: EyeplClause[];
  groups: Map<string, EyeplPredicateGroup>;
  queries: EyeplTerm[];
  fuses: EyeplClause[];
  negationDependencies: Array<{ from: string; to: string; negative: boolean }>;
  negationStratificationErrors: Array<{ from: string; to: string }>;
  stratifiedNegation: boolean;
  static parse(source: string, options?: EyeplRunOptions): Program;
  static parseSources(sources?: Array<string | EyeplSourcePart>, options?: EyeplRunOptions): Program;
  makeGroup(name: string, arity: number): EyeplPredicateGroup;
  indexClause(clause: EyeplClause): void;
  findGroup(name: string, arity: number): EyeplPredicateGroup | null;
  applyDeclarations(options?: EyeplRunOptions): void;
  markRecursivePredicates(): void;
  analyzeNegationStratification(): Array<{ from: string; to: string }>;
  assertStratifiedNegation(): true;
  isStratifiedNegation(): boolean;
  groupHasRule(group: EyeplPredicateGroup): boolean;
  sourceFactLines(predicateKeys?: Set<string> | null): Set<string>;
  queryGoals(): EyeplTerm[];
}

export const INFERENCE_FUSE_EXIT_CODE: 65;

export class InferenceFuseError extends Error {
  code: 65;
  clause: EyeplClause;
  stdout: string;
}

export function checkInferenceFuses(program: Program, solver: Solver): void;
export function formatInferenceFuse(clause: EyeplClause, env?: Env): string;

export interface BuiltinDefinition {
  name: string;
  arity: number;
  handler: BuiltinHandler;
  deterministic: boolean;
  ready: ((solver: Solver, goal: EyeplTerm, env: Env) => boolean) | null;
  fallbackWhenNotReady: boolean;
  shouldUse: ((solver: Solver, goal: EyeplTerm, env: Env) => boolean) | null;
}

export type BuiltinHandler = (context: { solver: Solver; goal: EyeplTerm; env: Env }) => Iterable<Env>;

export class BuiltinRegistry {
  constructor();
  defs: Map<string, BuiltinDefinition>;
  add(name: string, arity: number, handler: BuiltinHandler, options?: Partial<BuiltinDefinition>): this;
  get(name: string, arity: number): BuiltinDefinition | null;
}

export class Solver {
  constructor(program: Program, options?: EyeplRunOptions);
  program: Program;
  registry: BuiltinRegistry;
  maxDepth: number;
  solutionLimit: number;
  solutionsSeen: number;
  active: unknown[];
  memo: Map<string, unknown>;
  stats: EyeplStats;
  cloneForInnerGoal(solutionLimit?: number): Solver;
  solve(goals: EyeplTerm | EyeplTerm[], env?: Env, depth?: number): Iterable<Env>;
  activeVariant(goal: EyeplTerm, env: Env): boolean;
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
export function compound(name: string, args?: EyeplTerm[]): Term;
export function emptyList(): Term;
export function cons(head: EyeplTerm, tail: EyeplTerm): Term;
export function deref(term: EyeplTerm, env: Env): EyeplTerm;
export function isScalar(term: EyeplTerm | null | undefined): boolean;
export function isEmptyList(term: EyeplTerm | null | undefined): boolean;
export function isCons(term: EyeplTerm | null | undefined): boolean;
export function isConjunction(term: EyeplTerm | null | undefined): boolean;
export function unify(left: EyeplTerm, right: EyeplTerm, env: Env): boolean;
export function cloneTerm(term: EyeplTerm): Term;
export function freshTerm(term: EyeplTerm, suffix: string | number): Term;
export function copyResolved(term: EyeplTerm, env: Env): Term;
export function termIsGround(term: EyeplTerm, env?: Env): boolean;
export function termToString(term: EyeplTerm, env?: Env, quoteStrings?: boolean): string;
export function lexicalValue(term: EyeplTerm, env: Env): string | null;
export function properListItems(list: EyeplTerm, env: Env): EyeplTerm[] | null;
export function listFromItems(items: EyeplTerm[], start?: number, end?: number, tail?: EyeplTerm): Term;
export function flattenConjunction(goal: EyeplTerm): EyeplTerm[];
export function termSignature(term: EyeplTerm | null | undefined): string | null;
export function variantTerms(left: EyeplTerm, leftEnv: Env, right: EyeplTerm, rightEnv: Env, pairs?: Map<string, string>, reverse?: Map<string, string>): boolean;
export function compareTerms(left: EyeplTerm, right: EyeplTerm): number;
export function isDecimalInteger(text: string | null | undefined): boolean;
export function compareIntegerText(left: string, right: string): number;
export function parseFiniteNumber(text: string | null | undefined): number | null;
export function numberTextFromDouble(value: number): string | null;
export function compareNumberText(left: string, right: string): number;

export function makeProgram(source: string, options?: EyeplRunOptions): Program;
export function parseClauses(source: string, options?: EyeplRunOptions): EyeplClause[];
export function parseProgramText(source: string, options?: EyeplRunOptions): EyeplClause[];
export function createDefaultRegistry(): BuiltinRegistry;
export function createLibraryRegistry(): BuiltinRegistry;
export function getDefaultRegistry(): BuiltinRegistry;
export function getLibraryRegistry(): BuiltinRegistry;
export class PrologError extends Error {
  formal: string;
  culprit: EyeplTerm | null;
}

export class HaltSignal extends Error {
  name: 'HaltSignal';
  code: number;
  constructor(code?: number);
}
export function run(source: string | Program, options?: EyeplRunOptions): EyeplRunResult;
export function whyProof(program: Program, goal: EyeplTerm, options?: EyeplRunOptions): { ok: boolean; text: string };
export function whyNoProof(goal: EyeplTerm): string;
export function explainProof(program: Program, goal: EyeplTerm, options?: EyeplRunOptions): { ok: boolean; text: string };

declare const eyepl: {
  VAR: typeof VAR;
  ATOM: typeof ATOM;
  STRING: typeof STRING;
  NUMBER: typeof NUMBER;
  COMPOUND: typeof COMPOUND;
  Term: typeof Term;
  Env: typeof Env;
  Program: typeof Program;
  Solver: typeof Solver;
  INFERENCE_FUSE_EXIT_CODE: typeof INFERENCE_FUSE_EXIT_CODE;
  InferenceFuseError: typeof InferenceFuseError;
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
  createLibraryRegistry: typeof createLibraryRegistry;
  getDefaultRegistry: typeof getDefaultRegistry;
  getLibraryRegistry: typeof getLibraryRegistry;
  run: typeof run;
  checkInferenceFuses: typeof checkInferenceFuses;
  formatInferenceFuse: typeof formatInferenceFuse;
  whyProof: typeof whyProof;
  whyNoProof: typeof whyNoProof;
  explainProof: typeof explainProof;
};

export default eyepl;
