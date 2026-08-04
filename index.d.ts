export interface EyeDualStats {
  [key: string]: number;
}

export interface EyeDualRunOptions {
  /** A host-supplied goal, expressed as Prolog text or a parsed term. */
  goal?: string | EyeDualTerm;
  /** Host-supplied goals, executed in order. */
  goals?: Array<string | EyeDualTerm>;
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

export interface EyeDualRunResult {
  stdout: string;
  stats: EyeDualStats;
  haltCode: number | null;
}

export class StreamManager {
  constructor(options?: { input?: string; write?: (text: string) => void });
  streams: Map<number, unknown>;
  aliases: Map<string, number>;
  currentInput: number;
  currentOutput: number;
}

export interface EyeDualSourcePart {
  text?: string;
  source?: string;
  filename?: string;
  baseDir?: string;
}

export interface EyeDualClause {
  head: EyeDualTerm;
  body: EyeDualTerm[];
  index?: number;
  filename?: string;
  clauseNumber?: number;
}

export interface EyeDualPredicateGroup {
  name: string;
  arity: number;
  clauses: EyeDualClause[];
  argIndexes: unknown[];
  demandIndexes: Map<string, unknown>;
  rejectedDemandIndexes: Set<string>;
  tabled: boolean;
  recursive: boolean;
  tableInputPositions: number[];
  negationStratum: number | null;
}

export type EyeDualTerm = Term | { type: string; name: string; args?: EyeDualTerm[]; arity?: number };

export class Term {
  constructor(type: string, name?: unknown, args?: EyeDualTerm[]);
  type: string;
  name: string;
  args: EyeDualTerm[];
  get arity(): number;
}

export class Env {
  constructor(bindings?: Iterable<readonly [string, EyeDualTerm]> | null);
  bindings: Map<string, EyeDualTerm>;
  clone(): Env;
  has(name: string): boolean;
  get(name: string): EyeDualTerm | undefined;
  bind(name: string, term: EyeDualTerm): void;
}

export class Program {
  constructor(clauses?: EyeDualClause[], options?: EyeDualRunOptions);
  clauses: EyeDualClause[];
  groups: Map<string, EyeDualPredicateGroup>;
  negationDependencies: Array<{ from: string; to: string; negative: boolean }>;
  negationStratificationErrors: Array<{ from: string; to: string }>;
  stratifiedNegation: boolean;
  static parse(source: string, options?: EyeDualRunOptions): Program;
  static parseSources(sources?: Array<string | EyeDualSourcePart>, options?: EyeDualRunOptions): Program;
  makeGroup(name: string, arity: number): EyeDualPredicateGroup;
  indexClause(clause: EyeDualClause): void;
  findGroup(name: string, arity: number): EyeDualPredicateGroup | null;
  markRecursivePredicates(): void;
  analyzeNegationStratification(): Array<{ from: string; to: string }>;
  assertStratifiedNegation(): true;
  isStratifiedNegation(): boolean;
  groupHasRule(group: EyeDualPredicateGroup): boolean;
  sourceFactLines(predicateKeys?: Set<string> | null): Set<string>;
}

export interface BuiltinDefinition {
  name: string;
  arity: number;
  handler: BuiltinHandler;
  deterministic: boolean;
  ready: ((goal: EyeDualTerm, env: Env) => boolean) | null;
  fallbackWhenNotReady: boolean;
  shouldUse: ((context: { solver: Solver; goal: EyeDualTerm; env: Env }) => boolean) | null;
  eyeDualLibrary: boolean;
}

export type BuiltinHandler = (context: { solver: Solver; goal: EyeDualTerm; env: Env }) => Iterable<Env>;

export class BuiltinRegistry {
  constructor();
  defs: Map<string, BuiltinDefinition>;
  eyeDualLibrary?: boolean;
  add(name: string, arity: number, handler: BuiltinHandler, options?: Partial<BuiltinDefinition>): this;
  get(name: string, arity: number): BuiltinDefinition | null;
}

export class Solver {
  constructor(program: Program, options?: EyeDualRunOptions);
  program: Program;
  registry: BuiltinRegistry;
  maxDepth: number;
  solutionLimit: number;
  solutionsSeen: number;
  active: unknown[];
  memo: Map<string, unknown>;
  stats: EyeDualStats;
  cloneForInnerGoal(solutionLimit?: number): Solver;
  solve(goals: EyeDualTerm | EyeDualTerm[], env?: Env, depth?: number): Iterable<Env>;
  activeVariant(goal: EyeDualTerm, env: Env): boolean;
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
export function compound(name: string, args?: EyeDualTerm[]): Term;
export function emptyList(): Term;
export function cons(head: EyeDualTerm, tail: EyeDualTerm): Term;
export function deref(term: EyeDualTerm, env: Env): EyeDualTerm;
export function isScalar(term: EyeDualTerm | null | undefined): boolean;
export function isEmptyList(term: EyeDualTerm | null | undefined): boolean;
export function isCons(term: EyeDualTerm | null | undefined): boolean;
export function isConjunction(term: EyeDualTerm | null | undefined): boolean;
export function unify(left: EyeDualTerm, right: EyeDualTerm, env: Env): boolean;
export function cloneTerm(term: EyeDualTerm): Term;
export function freshTerm(term: EyeDualTerm, suffix: string | number): Term;
export function copyResolved(term: EyeDualTerm, env: Env): Term;
export function termIsGround(term: EyeDualTerm, env?: Env): boolean;
export function termToString(term: EyeDualTerm, env?: Env, quoteStrings?: boolean): string;
export function lexicalValue(term: EyeDualTerm, env: Env): string | null;
export function properListItems(list: EyeDualTerm, env: Env): EyeDualTerm[] | null;
export function listFromItems(items: EyeDualTerm[], start?: number, end?: number, tail?: EyeDualTerm): Term;
export function flattenConjunction(goal: EyeDualTerm): EyeDualTerm[];
export function termSignature(term: EyeDualTerm | null | undefined): string | null;
export function variantTerms(left: EyeDualTerm, leftEnv: Env, right: EyeDualTerm, rightEnv: Env, pairs?: Map<string, string>, reverse?: Map<string, string>): boolean;
export function compareTerms(left: EyeDualTerm, right: EyeDualTerm): number;
export function isDecimalInteger(text: string | null | undefined): boolean;
export function compareIntegerText(left: string, right: string): number;
export function parseFiniteNumber(text: string | null | undefined): number | null;
export function numberTextFromDouble(value: number): string | null;
export function compareNumberText(left: string, right: string): number;

export function makeProgram(source: string, options?: EyeDualRunOptions): Program;
export function parseClauses(source: string, options?: EyeDualRunOptions): EyeDualClause[];
export function parseProgramText(source: string, options?: EyeDualRunOptions): EyeDualClause[];
export function parseGoalText(source: string): EyeDualTerm;
export function createDefaultRegistry(): BuiltinRegistry;
export function createEyeDualRegistry(): BuiltinRegistry;
export function getDefaultRegistry(): BuiltinRegistry;
export function getEyeDualRegistry(): BuiltinRegistry;
export class PrologError extends Error {
  formal: string;
  culprit: EyeDualTerm | null;
}

export class HaltSignal extends Error {
  name: 'HaltSignal';
  code: number;
  constructor(code?: number);
}
export function run(source: string | Program, options?: EyeDualRunOptions): EyeDualRunResult;
export function whyProof(program: Program, goal: EyeDualTerm, options?: EyeDualRunOptions): { ok: boolean; text: string };
export function whyNoProof(goal: EyeDualTerm): string;
export function explainProof(program: Program, goal: EyeDualTerm, options?: EyeDualRunOptions): { ok: boolean; text: string };

declare const eyedual: {
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
  createEyeDualRegistry: typeof createEyeDualRegistry;
  getDefaultRegistry: typeof getDefaultRegistry;
  getEyeDualRegistry: typeof getEyeDualRegistry;
  run: typeof run;
  whyProof: typeof whyProof;
  whyNoProof: typeof whyNoProof;
  explainProof: typeof explainProof;
};

export default eyedual;
