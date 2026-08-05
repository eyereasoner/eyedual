export interface EyeLangStats {
  [key: string]: number;
}

export interface EyeLangRunOptions {
  /** A host-supplied goal, expressed as Prolog text or a parsed term. */
  goal?: string | EyeLangTerm;
  /** Host-supplied goals, executed in order. */
  goals?: Array<string | EyeLangTerm>;
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

export interface EyeLangRunResult {
  stdout: string;
  stats: EyeLangStats;
  haltCode: number | null;
}

export class StreamManager {
  constructor(options?: { input?: string; write?: (text: string) => void });
  streams: Map<number, unknown>;
  aliases: Map<string, number>;
  currentInput: number;
  currentOutput: number;
}

export interface EyeLangSourcePart {
  text?: string;
  source?: string;
  filename?: string;
  baseDir?: string;
}

export interface EyeLangClause {
  head: EyeLangTerm;
  body: EyeLangTerm[];
  index?: number;
  filename?: string;
  clauseNumber?: number;
}

export interface EyeLangPredicateGroup {
  name: string;
  arity: number;
  clauses: EyeLangClause[];
  argIndexes: unknown[];
  demandIndexes: Map<string, unknown>;
  rejectedDemandIndexes: Set<string>;
  tabled: boolean;
  recursive: boolean;
  tableInputPositions: number[];
  negationStratum: number | null;
}

export type EyeLangTerm = Term | { type: string; name: string; args?: EyeLangTerm[]; arity?: number };

export class Term {
  constructor(type: string, name?: unknown, args?: EyeLangTerm[]);
  type: string;
  name: string;
  args: EyeLangTerm[];
  get arity(): number;
}

export class Env {
  constructor(bindings?: Iterable<readonly [string, EyeLangTerm]> | null);
  bindings: Map<string, EyeLangTerm>;
  clone(): Env;
  has(name: string): boolean;
  get(name: string): EyeLangTerm | undefined;
  bind(name: string, term: EyeLangTerm): void;
}

export class Program {
  constructor(clauses?: EyeLangClause[], options?: EyeLangRunOptions);
  clauses: EyeLangClause[];
  groups: Map<string, EyeLangPredicateGroup>;
  negationDependencies: Array<{ from: string; to: string; negative: boolean }>;
  negationStratificationErrors: Array<{ from: string; to: string }>;
  stratifiedNegation: boolean;
  static parse(source: string, options?: EyeLangRunOptions): Program;
  static parseSources(sources?: Array<string | EyeLangSourcePart>, options?: EyeLangRunOptions): Program;
  makeGroup(name: string, arity: number): EyeLangPredicateGroup;
  indexClause(clause: EyeLangClause): void;
  findGroup(name: string, arity: number): EyeLangPredicateGroup | null;
  markRecursivePredicates(): void;
  analyzeNegationStratification(): Array<{ from: string; to: string }>;
  assertStratifiedNegation(): true;
  isStratifiedNegation(): boolean;
  groupHasRule(group: EyeLangPredicateGroup): boolean;
  sourceFactLines(predicateKeys?: Set<string> | null): Set<string>;
}

export interface BuiltinDefinition {
  name: string;
  arity: number;
  handler: BuiltinHandler;
  deterministic: boolean;
  ready: ((goal: EyeLangTerm, env: Env) => boolean) | null;
  fallbackWhenNotReady: boolean;
  shouldUse: ((context: { solver: Solver; goal: EyeLangTerm; env: Env }) => boolean) | null;
  eyeLangLibrary: boolean;
}

export type BuiltinHandler = (context: { solver: Solver; goal: EyeLangTerm; env: Env }) => Iterable<Env>;

export class BuiltinRegistry {
  constructor();
  defs: Map<string, BuiltinDefinition>;
  eyeLangLibrary?: boolean;
  add(name: string, arity: number, handler: BuiltinHandler, options?: Partial<BuiltinDefinition>): this;
  get(name: string, arity: number): BuiltinDefinition | null;
}

export class Solver {
  constructor(program: Program, options?: EyeLangRunOptions);
  program: Program;
  registry: BuiltinRegistry;
  maxDepth: number;
  solutionLimit: number;
  solutionsSeen: number;
  active: unknown[];
  memo: Map<string, unknown>;
  stats: EyeLangStats;
  cloneForInnerGoal(solutionLimit?: number): Solver;
  solve(goals: EyeLangTerm | EyeLangTerm[], env?: Env, depth?: number): Iterable<Env>;
  activeVariant(goal: EyeLangTerm, env: Env): boolean;
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
export function compound(name: string, args?: EyeLangTerm[]): Term;
export function emptyList(): Term;
export function cons(head: EyeLangTerm, tail: EyeLangTerm): Term;
export function deref(term: EyeLangTerm, env: Env): EyeLangTerm;
export function isScalar(term: EyeLangTerm | null | undefined): boolean;
export function isEmptyList(term: EyeLangTerm | null | undefined): boolean;
export function isCons(term: EyeLangTerm | null | undefined): boolean;
export function isConjunction(term: EyeLangTerm | null | undefined): boolean;
export function unify(left: EyeLangTerm, right: EyeLangTerm, env: Env): boolean;
export function cloneTerm(term: EyeLangTerm): Term;
export function freshTerm(term: EyeLangTerm, suffix: string | number): Term;
export function copyResolved(term: EyeLangTerm, env: Env): Term;
export function termIsGround(term: EyeLangTerm, env?: Env): boolean;
export function termToString(term: EyeLangTerm, env?: Env, quoteStrings?: boolean): string;
export function lexicalValue(term: EyeLangTerm, env: Env): string | null;
export function properListItems(list: EyeLangTerm, env: Env): EyeLangTerm[] | null;
export function listFromItems(items: EyeLangTerm[], start?: number, end?: number, tail?: EyeLangTerm): Term;
export function flattenConjunction(goal: EyeLangTerm): EyeLangTerm[];
export function termSignature(term: EyeLangTerm | null | undefined): string | null;
export function variantTerms(left: EyeLangTerm, leftEnv: Env, right: EyeLangTerm, rightEnv: Env, pairs?: Map<string, string>, reverse?: Map<string, string>): boolean;
export function compareTerms(left: EyeLangTerm, right: EyeLangTerm): number;
export function isDecimalInteger(text: string | null | undefined): boolean;
export function compareIntegerText(left: string, right: string): number;
export function parseFiniteNumber(text: string | null | undefined): number | null;
export function numberTextFromDouble(value: number): string | null;
export function compareNumberText(left: string, right: string): number;

export function makeProgram(source: string, options?: EyeLangRunOptions): Program;
export function parseClauses(source: string, options?: EyeLangRunOptions): EyeLangClause[];
export function parseProgramText(source: string, options?: EyeLangRunOptions): EyeLangClause[];
export function parseGoalText(source: string): EyeLangTerm;
export function createDefaultRegistry(): BuiltinRegistry;
export function createEyeLangRegistry(): BuiltinRegistry;
export function getDefaultRegistry(): BuiltinRegistry;
export function getEyeLangRegistry(): BuiltinRegistry;
export class PrologError extends Error {
  formal: string;
  culprit: EyeLangTerm | null;
}

export class HaltSignal extends Error {
  name: 'HaltSignal';
  code: number;
  constructor(code?: number);
}
export function run(source: string | Program, options?: EyeLangRunOptions): EyeLangRunResult;
export function whyProof(program: Program, goal: EyeLangTerm, options?: EyeLangRunOptions): { ok: boolean; text: string };
export function whyNoProof(goal: EyeLangTerm): string;
export function explainProof(program: Program, goal: EyeLangTerm, options?: EyeLangRunOptions): { ok: boolean; text: string };

declare const eyelang: {
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
  createEyeLangRegistry: typeof createEyeLangRegistry;
  getDefaultRegistry: typeof getDefaultRegistry;
  getEyeLangRegistry: typeof getEyeLangRegistry;
  run: typeof run;
  whyProof: typeof whyProof;
  whyNoProof: typeof whyNoProof;
  explainProof: typeof explainProof;
};

export default eyelang;
