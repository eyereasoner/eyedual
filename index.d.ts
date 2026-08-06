export interface EyelangStats {
  [key: string]: number;
}

export interface EyelangRunOptions {
  /** A host-supplied goal, expressed as Prolog text or a parsed term. */
  goal?: string | EyelangTerm;
  /** Host-supplied goals, executed in order. */
  goals?: Array<string | EyelangTerm>;
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

export interface EyelangRunResult {
  stdout: string;
  stats: EyelangStats;
  haltCode: number | null;
}

export class StreamManager {
  constructor(options?: { input?: string; write?: (text: string) => void });
  streams: Map<number, unknown>;
  aliases: Map<string, number>;
  currentInput: number;
  currentOutput: number;
}

export interface EyelangSourcePart {
  text?: string;
  source?: string;
  filename?: string;
  baseDir?: string;
}

export interface EyelangClause {
  head: EyelangTerm;
  body: EyelangTerm[];
  index?: number;
  filename?: string;
  clauseNumber?: number;
}

export interface EyelangPredicateGroup {
  name: string;
  arity: number;
  clauses: EyelangClause[];
  argIndexes: unknown[];
  demandIndexes: Map<string, unknown>;
  rejectedDemandIndexes: Set<string>;
  tabled: boolean;
  recursive: boolean;
  tableInputPositions: number[];
  negationStratum: number | null;
}

export type EyelangTerm = Term | { type: string; name: string; args?: EyelangTerm[]; arity?: number };

export class Term {
  constructor(type: string, name?: unknown, args?: EyelangTerm[]);
  type: string;
  name: string;
  args: EyelangTerm[];
  get arity(): number;
}

export class Env {
  constructor(bindings?: Iterable<readonly [string, EyelangTerm]> | null);
  bindings: Map<string, EyelangTerm>;
  clone(): Env;
  has(name: string): boolean;
  get(name: string): EyelangTerm | undefined;
  bind(name: string, term: EyelangTerm): void;
}

export class Program {
  constructor(clauses?: EyelangClause[], options?: EyelangRunOptions);
  clauses: EyelangClause[];
  groups: Map<string, EyelangPredicateGroup>;
  negationDependencies: Array<{ from: string; to: string; negative: boolean }>;
  negationStratificationErrors: Array<{ from: string; to: string }>;
  stratifiedNegation: boolean;
  static parse(source: string, options?: EyelangRunOptions): Program;
  static parseSources(sources?: Array<string | EyelangSourcePart>, options?: EyelangRunOptions): Program;
  makeGroup(name: string, arity: number): EyelangPredicateGroup;
  indexClause(clause: EyelangClause): void;
  findGroup(name: string, arity: number): EyelangPredicateGroup | null;
  markRecursivePredicates(): void;
  analyzeNegationStratification(): Array<{ from: string; to: string }>;
  assertStratifiedNegation(): true;
  isStratifiedNegation(): boolean;
  groupHasRule(group: EyelangPredicateGroup): boolean;
  sourceFactLines(predicateKeys?: Set<string> | null): Set<string>;
}

export interface BuiltinDefinition {
  name: string;
  arity: number;
  handler: BuiltinHandler;
  deterministic: boolean;
  ready: ((goal: EyelangTerm, env: Env) => boolean) | null;
  fallbackWhenNotReady: boolean;
  shouldUse: ((context: { solver: Solver; goal: EyelangTerm; env: Env }) => boolean) | null;
  eyeLangLibrary: boolean;
}

export type BuiltinHandler = (context: { solver: Solver; goal: EyelangTerm; env: Env }) => Iterable<Env>;

export class BuiltinRegistry {
  constructor();
  defs: Map<string, BuiltinDefinition>;
  eyeLangLibrary?: boolean;
  add(name: string, arity: number, handler: BuiltinHandler, options?: Partial<BuiltinDefinition>): this;
  get(name: string, arity: number): BuiltinDefinition | null;
}

export class Solver {
  constructor(program: Program, options?: EyelangRunOptions);
  program: Program;
  registry: BuiltinRegistry;
  maxDepth: number;
  solutionLimit: number;
  solutionsSeen: number;
  active: unknown[];
  memo: Map<string, unknown>;
  stats: EyelangStats;
  cloneForInnerGoal(solutionLimit?: number): Solver;
  solve(goals: EyelangTerm | EyelangTerm[], env?: Env, depth?: number): Iterable<Env>;
  activeVariant(goal: EyelangTerm, env: Env): boolean;
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
export function compound(name: string, args?: EyelangTerm[]): Term;
export function emptyList(): Term;
export function cons(head: EyelangTerm, tail: EyelangTerm): Term;
export function deref(term: EyelangTerm, env: Env): EyelangTerm;
export function isScalar(term: EyelangTerm | null | undefined): boolean;
export function isEmptyList(term: EyelangTerm | null | undefined): boolean;
export function isCons(term: EyelangTerm | null | undefined): boolean;
export function isConjunction(term: EyelangTerm | null | undefined): boolean;
export function unify(left: EyelangTerm, right: EyelangTerm, env: Env): boolean;
export function cloneTerm(term: EyelangTerm): Term;
export function freshTerm(term: EyelangTerm, suffix: string | number): Term;
export function copyResolved(term: EyelangTerm, env: Env): Term;
export function termIsGround(term: EyelangTerm, env?: Env): boolean;
export function termToString(term: EyelangTerm, env?: Env, quoteStrings?: boolean): string;
export function lexicalValue(term: EyelangTerm, env: Env): string | null;
export function properListItems(list: EyelangTerm, env: Env): EyelangTerm[] | null;
export function listFromItems(items: EyelangTerm[], start?: number, end?: number, tail?: EyelangTerm): Term;
export function flattenConjunction(goal: EyelangTerm): EyelangTerm[];
export function termSignature(term: EyelangTerm | null | undefined): string | null;
export function variantTerms(left: EyelangTerm, leftEnv: Env, right: EyelangTerm, rightEnv: Env, pairs?: Map<string, string>, reverse?: Map<string, string>): boolean;
export function compareTerms(left: EyelangTerm, right: EyelangTerm): number;
export function isDecimalInteger(text: string | null | undefined): boolean;
export function compareIntegerText(left: string, right: string): number;
export function parseFiniteNumber(text: string | null | undefined): number | null;
export function numberTextFromDouble(value: number): string | null;
export function compareNumberText(left: string, right: string): number;

export function makeProgram(source: string, options?: EyelangRunOptions): Program;
export function parseClauses(source: string, options?: EyelangRunOptions): EyelangClause[];
export function parseProgramText(source: string, options?: EyelangRunOptions): EyelangClause[];
export function parseGoalText(source: string): EyelangTerm;
export function createDefaultRegistry(): BuiltinRegistry;
export function createEyelangRegistry(): BuiltinRegistry;
export function getDefaultRegistry(): BuiltinRegistry;
export function getEyelangRegistry(): BuiltinRegistry;
export class PrologError extends Error {
  formal: string;
  culprit: EyelangTerm | null;
}

export class HaltSignal extends Error {
  name: 'HaltSignal';
  code: number;
  constructor(code?: number);
}
export function run(source: string | Program, options?: EyelangRunOptions): EyelangRunResult;
export function whyProof(program: Program, goal: EyelangTerm, options?: EyelangRunOptions): { ok: boolean; text: string };
export function whyNoProof(goal: EyelangTerm): string;
export function explainProof(program: Program, goal: EyelangTerm, options?: EyelangRunOptions): { ok: boolean; text: string };

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
  createEyelangRegistry: typeof createEyelangRegistry;
  getDefaultRegistry: typeof getDefaultRegistry;
  getEyelangRegistry: typeof getEyelangRegistry;
  run: typeof run;
  whyProof: typeof whyProof;
  whyNoProof: typeof whyNoProof;
  explainProof: typeof explainProof;
};

export default eyelang;
