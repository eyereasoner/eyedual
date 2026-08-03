export interface WebEntailStats {
  [key: string]: number;
}

export interface WebEntailRunOptions {
  /** A host-supplied goal, expressed as Prolog text or a parsed term. */
  goal?: string | WebEntailTerm;
  /** Host-supplied goals, executed in order. */
  goals?: Array<string | WebEntailTerm>;
  proof?: boolean;
  why?: boolean;
  explain?: boolean;
  maxDepth?: number;
  solutionLimit?: number;
  registry?: BuiltinRegistry;
  sourceMetadata?: boolean;
  strictNegation?: boolean;
  analyzeNegation?: boolean;
  ioOptions?: {
    input?: string;
    write?: (text: string) => void;
  };
  [key: string]: unknown;
}

export interface WebEntailRunResult {
  stdout: string;
  stats: WebEntailStats;
  haltCode: number | null;
}

export class StreamManager {
  constructor(options?: { input?: string; write?: (text: string) => void });
  streams: Map<number, unknown>;
  aliases: Map<string, number>;
  currentInput: number;
  currentOutput: number;
}

export interface WebEntailSourcePart {
  text?: string;
  source?: string;
  filename?: string;
  baseDir?: string;
}

export interface WebEntailClause {
  head: WebEntailTerm;
  body: WebEntailTerm[];
  index?: number;
  filename?: string;
  clauseNumber?: number;
}

export interface WebEntailPredicateGroup {
  name: string;
  arity: number;
  clauses: WebEntailClause[];
  argIndexes: unknown[];
  demandIndexes: Map<string, unknown>;
  rejectedDemandIndexes: Set<string>;
  tabled: boolean;
  recursive: boolean;
  tableInputPositions: number[];
  negationStratum: number | null;
}

export type WebEntailTerm = Term | { type: string; name: string; args?: WebEntailTerm[]; arity?: number };

export class Term {
  constructor(type: string, name?: unknown, args?: WebEntailTerm[]);
  type: string;
  name: string;
  args: WebEntailTerm[];
  get arity(): number;
}

export class Env {
  constructor(bindings?: Iterable<readonly [string, WebEntailTerm]> | null);
  bindings: Map<string, WebEntailTerm>;
  clone(): Env;
  has(name: string): boolean;
  get(name: string): WebEntailTerm | undefined;
  bind(name: string, term: WebEntailTerm): void;
}

export class Program {
  constructor(clauses?: WebEntailClause[], options?: WebEntailRunOptions);
  clauses: WebEntailClause[];
  groups: Map<string, WebEntailPredicateGroup>;
  negationDependencies: Array<{ from: string; to: string; negative: boolean }>;
  negationStratificationErrors: Array<{ from: string; to: string }>;
  stratifiedNegation: boolean;
  static parse(source: string, options?: WebEntailRunOptions): Program;
  static parseSources(sources?: Array<string | WebEntailSourcePart>, options?: WebEntailRunOptions): Program;
  makeGroup(name: string, arity: number): WebEntailPredicateGroup;
  indexClause(clause: WebEntailClause): void;
  findGroup(name: string, arity: number): WebEntailPredicateGroup | null;
  markRecursivePredicates(): void;
  analyzeNegationStratification(): Array<{ from: string; to: string }>;
  assertStratifiedNegation(): true;
  isStratifiedNegation(): boolean;
  groupHasRule(group: WebEntailPredicateGroup): boolean;
  sourceFactLines(predicateKeys?: Set<string> | null): Set<string>;
}

export interface BuiltinDefinition {
  name: string;
  arity: number;
  handler: BuiltinHandler;
  deterministic: boolean;
  ready: ((goal: WebEntailTerm, env: Env) => boolean) | null;
  fallbackWhenNotReady: boolean;
  shouldUse: ((context: { solver: Solver; goal: WebEntailTerm; env: Env }) => boolean) | null;
  webEntailLibrary: boolean;
}

export type BuiltinHandler = (context: { solver: Solver; goal: WebEntailTerm; env: Env }) => Iterable<Env>;

export class BuiltinRegistry {
  constructor();
  defs: Map<string, BuiltinDefinition>;
  webEntailLibrary?: boolean;
  add(name: string, arity: number, handler: BuiltinHandler, options?: Partial<BuiltinDefinition>): this;
  get(name: string, arity: number): BuiltinDefinition | null;
}

export class Solver {
  constructor(program: Program, options?: WebEntailRunOptions);
  program: Program;
  registry: BuiltinRegistry;
  maxDepth: number;
  solutionLimit: number;
  solutionsSeen: number;
  active: unknown[];
  memo: Map<string, unknown>;
  stats: WebEntailStats;
  cloneForInnerGoal(solutionLimit?: number): Solver;
  solve(goals: WebEntailTerm | WebEntailTerm[], env?: Env, depth?: number): Iterable<Env>;
  activeVariant(goal: WebEntailTerm, env: Env): boolean;
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
export function compound(name: string, args?: WebEntailTerm[]): Term;
export function emptyList(): Term;
export function cons(head: WebEntailTerm, tail: WebEntailTerm): Term;
export function deref(term: WebEntailTerm, env: Env): WebEntailTerm;
export function isScalar(term: WebEntailTerm | null | undefined): boolean;
export function isEmptyList(term: WebEntailTerm | null | undefined): boolean;
export function isCons(term: WebEntailTerm | null | undefined): boolean;
export function isConjunction(term: WebEntailTerm | null | undefined): boolean;
export function unify(left: WebEntailTerm, right: WebEntailTerm, env: Env): boolean;
export function cloneTerm(term: WebEntailTerm): Term;
export function freshTerm(term: WebEntailTerm, suffix: string | number): Term;
export function copyResolved(term: WebEntailTerm, env: Env): Term;
export function termIsGround(term: WebEntailTerm, env?: Env): boolean;
export function termToString(term: WebEntailTerm, env?: Env, quoteStrings?: boolean): string;
export function lexicalValue(term: WebEntailTerm, env: Env): string | null;
export function properListItems(list: WebEntailTerm, env: Env): WebEntailTerm[] | null;
export function listFromItems(items: WebEntailTerm[], start?: number, end?: number, tail?: WebEntailTerm): Term;
export function flattenConjunction(goal: WebEntailTerm): WebEntailTerm[];
export function termSignature(term: WebEntailTerm | null | undefined): string | null;
export function variantTerms(left: WebEntailTerm, leftEnv: Env, right: WebEntailTerm, rightEnv: Env, pairs?: Map<string, string>, reverse?: Map<string, string>): boolean;
export function compareTerms(left: WebEntailTerm, right: WebEntailTerm): number;
export function isDecimalInteger(text: string | null | undefined): boolean;
export function compareIntegerText(left: string, right: string): number;
export function parseFiniteNumber(text: string | null | undefined): number | null;
export function numberTextFromDouble(value: number): string | null;
export function compareNumberText(left: string, right: string): number;

export function makeProgram(source: string, options?: WebEntailRunOptions): Program;
export function parseClauses(source: string, options?: WebEntailRunOptions): WebEntailClause[];
export function parseProgramText(source: string, options?: WebEntailRunOptions): WebEntailClause[];
export function parseGoalText(source: string): WebEntailTerm;
export function createDefaultRegistry(): BuiltinRegistry;
export function createWebEntailRegistry(): BuiltinRegistry;
export function getDefaultRegistry(): BuiltinRegistry;
export function getWebEntailRegistry(): BuiltinRegistry;
export class PrologError extends Error {
  formal: string;
  culprit: WebEntailTerm | null;
}

export class HaltSignal extends Error {
  name: 'HaltSignal';
  code: number;
  constructor(code?: number);
}
export function run(source: string | Program, options?: WebEntailRunOptions): WebEntailRunResult;
export function whyProof(program: Program, goal: WebEntailTerm, options?: WebEntailRunOptions): { ok: boolean; text: string };
export function whyNoProof(goal: WebEntailTerm): string;
export function explainProof(program: Program, goal: WebEntailTerm, options?: WebEntailRunOptions): { ok: boolean; text: string };

declare const webentail: {
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
  createWebEntailRegistry: typeof createWebEntailRegistry;
  getDefaultRegistry: typeof getDefaultRegistry;
  getWebEntailRegistry: typeof getWebEntailRegistry;
  run: typeof run;
  whyProof: typeof whyProof;
  whyNoProof: typeof whyNoProof;
  explainProof: typeof explainProof;
};

export default webentail;
