// Tokenizer and recursive-descent parser for the EyeDual source language.
// It preserves the compact Prolog-like syntax while producing Term objects for the solver.
import { atom, compound, cons, emptyList, numberTerm, stringTerm, variable } from './term.js';

const TOK = {
  EOF: 'eof', ATOM: 'atom', VAR: 'var', STRING: 'string', NUMBER: 'number',
  LPAREN: '(', RPAREN: ')', LBRACKET: '[', RBRACKET: ']', LBRACE: '{', RBRACE: '}',
  COMMA: ',', BAR: '|', DOT: '.', IF: ':-'
};

function isWhitespaceCode(code) {
  return code === 32 || code === 9 || code === 10 || code === 13 || code === 12 || code === 11;
}

function isDigitCode(code) {
  return code >= 48 && code <= 57;
}

function isAsciiLetterCode(code) {
  return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
}

function isNameContinueCode(code) {
  return code === 95 || isAsciiLetterCode(code) || isDigitCode(code);
}


function isVariableStartCode(code) {
  return code === 95 || (code >= 65 && code <= 90);
}

function isPlainAtomStartCode(code) {
  return code >= 97 && code <= 122;
}

const graphicAtomChars = '#$&*+-./<=>@^~\\;:';

// ISO operator syntax is lowered to the same ordinary compound terms used by
// canonical notation. Commas remain separators except inside parentheses.
const INFIX_OPERATORS = new Map([
  [':-', { precedence: 2, associativity: 'none' }],
  [';', { precedence: 5, associativity: 'right' }],
  ['->', { precedence: 7, associativity: 'right' }],
  [',', { precedence: 10, associativity: 'right' }],
  ['=', { precedence: 20, associativity: 'none' }],
  ['=..', { precedence: 20, associativity: 'none' }],
  ['\\=', { precedence: 20, associativity: 'none' }],
  ['==', { precedence: 20, associativity: 'none' }],
  ['\\==', { precedence: 20, associativity: 'none' }],
  ['@<', { precedence: 20, associativity: 'none' }],
  ['@=<', { precedence: 20, associativity: 'none' }],
  ['@>', { precedence: 20, associativity: 'none' }],
  ['@>=', { precedence: 20, associativity: 'none' }],
  ['is', { precedence: 20, associativity: 'none' }],
  ['=:=', { precedence: 20, associativity: 'none' }],
  ['=\\=', { precedence: 20, associativity: 'none' }],
  ['<', { precedence: 20, associativity: 'none' }],
  ['=<', { precedence: 20, associativity: 'none' }],
  ['>', { precedence: 20, associativity: 'none' }],
  ['>=', { precedence: 20, associativity: 'none' }],
  ['+', { precedence: 30, associativity: 'left' }],
  ['-', { precedence: 30, associativity: 'left' }],
  ['/\\', { precedence: 30, associativity: 'left' }],
  ['\\/', { precedence: 30, associativity: 'left' }],
  ['*', { precedence: 40, associativity: 'left' }],
  ['/', { precedence: 40, associativity: 'left' }],
  ['//', { precedence: 40, associativity: 'left' }],
  ['div', { precedence: 40, associativity: 'left' }],
  ['mod', { precedence: 40, associativity: 'left' }],
  ['rem', { precedence: 40, associativity: 'left' }],
  ['<<', { precedence: 40, associativity: 'left' }],
  ['>>', { precedence: 40, associativity: 'left' }],
  ['**', { precedence: 50, associativity: 'none' }],
  ['^', { precedence: 50, associativity: 'right' }],
]);
const PREFIX_OPERATORS = new Map([
  ['\\+', 15],
  ['+', 45],
  ['-', 45],
  ['\\', 45],
]);

export const ISO_OPERATOR_DEFINITIONS = [
  [1200, 'xfx', ':-'], [1200, 'fx', ':-'],
  [1100, 'xfy', ';'], [1050, 'xfy', '->'], [1000, 'xfy', ','],
  [900, 'fy', '\\+'],
  ...['=', '=..', '\\=', '==', '\\==', '@<', '@=<', '@>', '@>=', 'is',
    '=:=', '=\\=', '<', '=<', '>', '>='].map((name) => [700, 'xfx', name]),
  [600, 'xfy', ':'],
  ...['+', '-', '/\\', '\\/'].map((name) => [500, 'yfx', name]),
  ...['*', '/', '//', 'div', 'mod', 'rem', '<<', '>>'].map((name) => [400, 'yfx', name]),
  [200, 'xfx', '**'], [200, 'xfy', '^'],
  [200, 'fy', '+'], [200, 'fy', '-'], [200, 'fy', '\\'],
];

function operatorStrength(priority) {
  return 1201 - priority;
}

function isGraphicAtomCode(code) {
  return graphicAtomChars.includes(String.fromCharCode(code));
}

class Parser {
  constructor(source, options = {}) {
    this.source = String(source ?? '');
    this.filename = options.filename ?? '<input>';
    this.pos = 0;
    this.line = 1;
    this.anonymous = 0;
    this.sourceMetadata = options.sourceMetadata !== false;
    this.infixOperators = new Map(INFIX_OPERATORS);
    this.prefixOperators = new Map(
      [...PREFIX_OPERATORS].map(([name, precedence]) => [name, { precedence, strict: false }])
    );
    this.postfixOperators = new Map();
    this.previousToken = null;
    this.token = this.nextToken();
  }
  defineOperator(priority, specifier, name) {
    const strength = operatorStrength(priority);
    if (['xfx', 'xfy', 'yfx'].includes(specifier)) {
      if (priority === 0) this.infixOperators.delete(name);
      else this.infixOperators.set(name, {
        precedence: strength,
        associativity: specifier === 'xfy' ? 'right' : specifier === 'yfx' ? 'left' : 'none',
      });
    } else if (specifier === 'fx' || specifier === 'fy') {
      if (priority === 0) this.prefixOperators.delete(name);
      else this.prefixOperators.set(name, { precedence: strength, strict: specifier === 'fx' });
    } else if (specifier === 'xf' || specifier === 'yf') {
      if (priority === 0) this.postfixOperators.delete(name);
      else this.postfixOperators.set(name, { precedence: strength, strict: specifier === 'xf' });
    }
  }
  applyOperatorDirective(directive, line) {
    if (directive.type !== 'compound' || directive.name !== 'op' || directive.arity !== 3) return false;
    const [priorityTerm, specifierTerm, nameTerm] = directive.args;
    if (priorityTerm.type !== 'number' || !/^\d+$/.test(priorityTerm.name)) {
      throw new Error(`parse line ${line}: op priority must be an integer`);
    }
    const priority = Number(priorityTerm.name);
    if (priority < 0 || priority > 1200) throw new Error(`parse line ${line}: op priority out of range`);
    if (specifierTerm.type !== 'atom' || !['fx', 'fy', 'xf', 'yf', 'xfx', 'xfy', 'yfx'].includes(specifierTerm.name)) {
      throw new Error(`parse line ${line}: invalid operator specifier`);
    }
    const names = nameTerm.type === 'atom'
      ? [nameTerm.name]
      : listAtomNames(nameTerm);
    if (names == null) throw new Error(`parse line ${line}: operator name must be an atom or list of atoms`);
    for (const name of names) this.defineOperator(priority, specifierTerm.name, name);
    return true;
  }
  peek(offset = 0) {
    return this.source[this.pos + offset] ?? '';
  }
  take() {
    const ch = this.peek();
    if (ch) {
      this.pos++;
      if (ch === '\n') this.line++;
    }
    return ch;
  }
  skipWhitespaceAndComments() {
    const source = this.source;
    const len = source.length;
    while (true) {
      while (this.pos < len) {
        const code = source.charCodeAt(this.pos);
        if (!isWhitespaceCode(code)) break;
        if (code === 10) this.line++;
        this.pos++;
      }
      if (source.charCodeAt(this.pos) === 37) { // % line comment
        while (this.pos < len && source.charCodeAt(this.pos) !== 10) this.pos++;
        continue;
      }
      if (source[this.pos] === '/' && source[this.pos + 1] === '*') {
        const line = this.line;
        this.pos += 2;
        while (this.pos < len && !(source[this.pos] === '*' && source[this.pos + 1] === '/')) {
          if (source.charCodeAt(this.pos) === 10) this.line++;
          this.pos++;
        }
        if (this.pos >= len) throw new Error(`parse line ${line}: unterminated block comment`);
        this.pos += 2;
        continue;
      }
      break;
    }
  }
  readEscape(line) {
    const escaped = this.take();
    if (!escaped) throw new Error(`parse line ${line}: unterminated escape sequence`);
    if (escaped === '\n') return '';
    const controls = { a: '\x07', b: '\b', r: '\r', f: '\f', t: '\t', n: '\n', v: '\v' };
    if (controls[escaped] != null) return controls[escaped];
    if (escaped === 'x') {
      let digits = '';
      while (/^[0-9A-Fa-f]$/.test(this.peek())) digits += this.take();
      if (!digits || this.take() !== '\\') throw new Error(`parse line ${line}: bad hexadecimal escape`);
      return String.fromCodePoint(Number.parseInt(digits, 16));
    }
    if (/^[0-7]$/.test(escaped)) {
      let digits = escaped;
      while (/^[0-7]$/.test(this.peek())) digits += this.take();
      if (this.take() !== '\\') throw new Error(`parse line ${line}: bad octal escape`);
      return String.fromCodePoint(Number.parseInt(digits, 8));
    }
    return escaped;
  }
  nextToken() {
    // The tokenizer keeps just enough state for useful parse-line errors and
    // treats quoted atoms and quoted strings differently, as Prolog syntax does.
    this.skipWhitespaceAndComments();
    const line = this.line;
    const ch = this.peek();
    if (!ch) return { type: TOK.EOF, text: '', line };
    if (ch === '!') {
      this.take();
      return { type: TOK.ATOM, text: '!', line };
    }

    const punct = {
      '(': TOK.LPAREN, ')': TOK.RPAREN, '[': TOK.LBRACKET, ']': TOK.RBRACKET,
      '{': TOK.LBRACE, '}': TOK.RBRACE, ',': TOK.COMMA, '|': TOK.BAR, '.': TOK.DOT,
    };
    if (punct[ch]) {
      this.take();
      return { type: punct[ch], text: ch, line };
    }
    if (ch === ':' && this.peek(1) === '-') {
      this.pos += 2;
      return { type: TOK.IF, text: ':-', line };
    }
    if (ch === ':') throw new Error('colon names are not supported; use name or prefix_name');

    if (ch === '"' || ch === "'") {
      const quote = this.take();
      let text = '';
      while (true) {
        if (!this.peek()) throw new Error(`parse line ${line}: unterminated quoted term`);
        let value = this.take();
        if (value === quote) {
          if (this.peek() === quote) {
            this.take();
            value = quote;
          } else {
            break;
          }
        } else if (value === '\\' && this.peek()) {
          value = this.readEscape(line);
        }
        text += value;
      }
      return { type: quote === '"' ? TOK.STRING : TOK.ATOM, text, line, quoted: true };
    }

    // A signed numeric literal is only recognized where a term may start.
    // Otherwise the minus is the standard infix operator, so compact ISO
    // syntax such as `X-1` must not be read as `X` followed by `-1`.
    const previousEndsTerm = this.previousToken && (
      [TOK.VAR, TOK.NUMBER, TOK.STRING, TOK.RPAREN, TOK.RBRACKET, TOK.RBRACE].includes(this.previousToken.type) ||
      (this.previousToken.type === TOK.ATOM &&
       !this.infixOperators.has(this.previousToken.text) &&
       !this.prefixOperators.has(this.previousToken.text) &&
       !this.postfixOperators.has(this.previousToken.text))
    );
    if (isDigitCode(ch.charCodeAt(0)) ||
        (ch === '-' && isDigitCode(this.peek(1).charCodeAt(0)) && !previousEndsTerm)) {
      const start = this.pos;
      const negative = this.peek() === '-';
      if (negative) this.take();
      if (this.peek() === '0' && this.peek(1) === "'") {
        this.take();
        this.take();
        let value = this.take();
        if (!value || value === '\n') throw new Error(`parse line ${line}: bad character code constant`);
        if (value === '\\') value = this.readEscape(line);
        const code = value.codePointAt(0);
        return { type: TOK.NUMBER, text: String(negative ? -code : code), line };
      }
      if (this.peek() === '0' && ['b', 'o', 'x'].includes(this.peek(1))) {
        this.take();
        const kind = this.take();
        const radix = kind === 'b' ? 2 : kind === 'o' ? 8 : 16;
        const digitPattern = radix === 2 ? /^[01]$/ : radix === 8 ? /^[0-7]$/ : /^[0-9A-Fa-f]$/;
        let digits = '';
        while (digitPattern.test(this.peek())) digits += this.take();
        if (!digits) throw new Error(`parse line ${line}: bad radix integer`);
        let integer = 0n;
        for (const digit of digits) integer = integer * BigInt(radix) + BigInt(Number.parseInt(digit, radix));
        if (negative) integer = -integer;
        return { type: TOK.NUMBER, text: integer.toString(), line };
      }
      while (isDigitCode(this.peek().charCodeAt(0))) this.take();
      if (this.peek() === '.' && isDigitCode(this.peek(1).charCodeAt(0))) {
        this.take();
        while (isDigitCode(this.peek().charCodeAt(0))) this.take();
      }
      if ((this.peek() === 'e' || this.peek() === 'E')) {
        let idx = this.pos + 1;
        if (this.source[idx] === '+' || this.source[idx] === '-') idx++;
        if (isDigitCode((this.source[idx] ?? '').charCodeAt(0))) {
          this.take();
          if (this.peek() === '+' || this.peek() === '-') this.take();
          while (isDigitCode(this.peek().charCodeAt(0))) this.take();
        }
      }
      return { type: TOK.NUMBER, text: this.source.slice(start, this.pos), line };
    }

    if (isVariableStartCode(ch.charCodeAt(0))) {
      const start = this.pos;
      this.take();
      while (isNameContinueCode(this.peek().charCodeAt(0))) this.take();
      const text = this.source.slice(start, this.pos);
      return { type: TOK.VAR, text, line };
    }

    if (isPlainAtomStartCode(ch.charCodeAt(0))) {
      const start = this.pos;
      this.take();
      while (isNameContinueCode(this.peek().charCodeAt(0))) this.take();
      return { type: TOK.ATOM, text: this.source.slice(start, this.pos), line };
    }

    if (isGraphicAtomCode(ch.charCodeAt(0))) {
      const start = this.pos;
      this.take();
      while (isGraphicAtomCode(this.peek().charCodeAt(0))) this.take();
      return { type: TOK.ATOM, text: this.source.slice(start, this.pos), line };
    }

    throw new Error(`parse line ${line}: bad character ${JSON.stringify(ch)}`);
  }
  advance() {
    this.previousToken = this.token;
    this.token = this.nextToken();
  }
  expect(type, desc = type) {
    if (this.token.type !== type) throw new Error(`parse line ${this.token.line}: expected ${desc}, got ${this.token.text}`);
  }
  parseParenthesizedTerm() {
    this.expect(TOK.LPAREN, '(');
    this.advance();
    const term = this.parseTerm(0, true);
    this.expect(TOK.RPAREN, ')');
    this.advance();
    return term;
  }
  parseList() {
    // Lists are lowered to './2' cons cells and [] so list predicates can work
    // on a single canonical representation.
    this.expect(TOK.LBRACKET, '[');
    this.advance();
    if (this.token.type === TOK.RBRACKET) {
      this.advance();
      return emptyList();
    }
    const items = [];
    let tail = null;
    while (true) {
      items.push(this.parseTerm());
      if (this.token.type === TOK.COMMA) {
        this.advance();
        continue;
      }
      if (this.token.type === TOK.BAR) {
        this.advance();
        tail = this.parseTerm();
        this.expect(TOK.RBRACKET, ']');
        this.advance();
        break;
      }
      this.expect(TOK.RBRACKET, ']');
      this.advance();
      tail = emptyList();
      break;
    }
    for (let i = items.length - 1; i >= 0; i--) tail = cons(items[i], tail);
    return tail;
  }
  parseCurly() {
    this.expect(TOK.LBRACE, '{');
    this.advance();
    if (this.token.type === TOK.RBRACE) {
      this.advance();
      return atom('{}');
    }
    const term = this.parseTerm(0, true);
    this.expect(TOK.RBRACE, '}');
    this.advance();
    return compound('{}', [term]);
  }
  parseTerm(minPrecedence = 0, allowComma = false) {
    let left = this.parsePrefixTerm(minPrecedence);
    let strictPostfixPrecedence = null;
    while (true) {
      const op = this.token.type === TOK.COMMA && allowComma
        ? ','
        : this.token.type === TOK.IF ? ':-'
        : this.token.type === TOK.ATOM && !this.token.quoted ? this.token.text : null;
      const info = op == null ? null : this.infixOperators.get(op);
      if (!info || info.precedence < minPrecedence) {
        const postfix = this.token.type === TOK.ATOM && !this.token.quoted
          ? this.postfixOperators.get(this.token.text)
          : null;
        if (!postfix || postfix.precedence < minPrecedence ||
            (strictPostfixPrecedence === postfix.precedence)) break;
        const name = this.token.text;
        this.advance();
        left = compound(name, [left]);
        strictPostfixPrecedence = postfix.strict ? postfix.precedence : null;
        continue;
      }
      strictPostfixPrecedence = null;
      this.advance();
      const right = this.parseTerm(info.associativity === 'right' ? info.precedence : info.precedence + 1, allowComma);
      left = compound(op, [left, right]);
      if (info.associativity === 'none') {
        const nextOp = this.token.type === TOK.COMMA && allowComma
          ? ','
          : this.token.type === TOK.IF ? ':-'
          : this.token.type === TOK.ATOM && !this.token.quoted ? this.token.text : null;
        if (this.infixOperators.get(nextOp)?.precedence === info.precedence) {
          throw new Error(`parse line ${this.token.line}: non-associative operator ${op} requires parentheses`);
        }
      }
    }
    return left;
  }
  parsePrefixTerm(minPrecedence = 0) {
    if (this.token.type === TOK.ATOM && !this.token.quoted &&
        this.prefixOperators.get(this.token.text)?.precedence >= minPrecedence) {
      const op = this.token.text;
      const info = this.prefixOperators.get(op);
      this.advance();
      // Graphic operators can also be ordinary atom data in a term, as in
      // `op(+, Left, Right)`.  When the operator is immediately followed by
      // an argument delimiter there is no operand for prefix syntax, so keep
      // the operator as an atom instead of reporting a misleading bad-term
      // error.
      if ([TOK.COMMA, TOK.RPAREN, TOK.RBRACKET, TOK.BAR].includes(this.token.type)) {
        return atom(op);
      }
      if (this.token.type === TOK.LPAREN) {
        this.advance();
        const args = [];
        while (true) {
          args.push(this.parseTerm(0, false));
          if (this.token.type !== TOK.COMMA) break;
          this.advance();
        }
        this.expect(TOK.RPAREN, ')');
        this.advance();
        return compound(op, args);
      }
      return compound(op, [this.parseTerm(info.precedence + (info.strict ? 1 : 0), false)]);
    }
    if (this.token.type === TOK.LPAREN) return this.parseParenthesizedTerm();
    if (this.token.type === TOK.LBRACKET) return this.parseList();
    if (this.token.type === TOK.LBRACE) return this.parseCurly();
    if (this.token.type === TOK.VAR) {
      const name = this.token.text;
      this.advance();
      if (name === '_') return variable(`__anon${this.anonymous++}`);
      return variable(name);
    }
    if (this.token.type === TOK.STRING) {
      const value = this.token.text;
      this.advance();
      return stringTerm(value);
    }
    if (this.token.type === TOK.NUMBER) {
      const value = this.token.text;
      this.advance();
      return numberTerm(value);
    }
    if (this.token.type === TOK.ATOM) {
      const name = this.token.text;
      this.advance();
      if (this.token.type === TOK.LPAREN) {
        this.advance();
        const args = [];
        if (this.token.type === TOK.RPAREN) {
          throw new Error(`parse line ${this.token.line}: zero-arity compound syntax is not supported; use atom ${JSON.stringify(name)} for arity zero data`);
        }
        while (true) {
          args.push(this.parseTerm(0, false));
          if (this.token.type === TOK.COMMA) {
            this.advance();
            continue;
          }
          break;
        }
        this.expect(TOK.RPAREN, ')');
        this.advance();
        return compound(name, args);
      }
      return atom(name);
    }
    throw new Error(`parse line ${this.token.line}: bad term`);
  }
  parseProgram() {
    const clauses = [];
    while (this.token.type !== TOK.EOF) {
      const line = this.token.line;
      if (this.token.type === TOK.IF) {
        this.advance();
        const directive = this.parseTerm();
        const supportedDirective = directive.type === 'compound' && (
          (['dynamic', 'multifile', 'discontiguous', 'initialization', 'include', 'ensure_loaded'].includes(directive.name) && directive.arity === 1) ||
          (['char_conversion', 'set_prolog_flag'].includes(directive.name) && directive.arity === 2)
        );
        const operator = this.applyOperatorDirective(directive, line);
        if (!supportedDirective && !operator) {
          throw new Error(`parse line ${line}: bad term`);
        }
        this.expect(TOK.DOT, '.');
        this.advance();
        const clause = { head: compound(':-', [directive]), body: [] };
        if (this.sourceMetadata) clause.source = { filename: this.filename, line, clause: clauses.length + 1 };
        clauses.push(clause);
        continue;
      }
      const head = this.parseTerm(3);
      const body = [];
      if (this.token.type === TOK.IF) {
        this.advance();
        while (true) {
          body.push(this.parseTerm());
          if (this.token.type === TOK.COMMA) {
            this.advance();
            continue;
          }
          break;
        }
      }
      this.expect(TOK.DOT, '.');
      this.advance();
      const clause = { head, body };
      if (this.sourceMetadata) clause.source = { filename: this.filename, line, clause: clauses.length + 1 };
      clauses.push(clause);
    }
    return clauses;
  }
}

function listAtomNames(term) {
  const names = [];
  let cursor = term;
  while (cursor.type === 'compound' && cursor.name === '.' && cursor.arity === 2) {
    if (cursor.args[0].type !== 'atom') return null;
    names.push(cursor.args[0].name);
    cursor = cursor.args[1];
  }
  return cursor.type === 'atom' && cursor.name === '[]' ? names : null;
}


export function parseClauses(source, options = {}) {
  if (options.sourceMetadata === false) {
    const clauses = parseClausesFastNoSource(source);
    if (clauses) return clauses;
  }
  return new Parser(source, options).parseProgram();
}

function isSimpleName(text) {
  if (!text) return false;
  const first = text.charCodeAt(0);
  if (!(first >= 97 && first <= 122)) return false;
  for (let i = 1; i < text.length; i++) {
    const code = text.charCodeAt(i);
    if (!(code === 95 || (code >= 48 && code <= 57) || (code >= 65 && code <= 90) || (code >= 97 && code <= 122))) return false;
  }
  return true;
}

const SIMPLE_NUMBER = /^-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?$/;
const FAST_BINARY_FACT = /^([a-z][A-Za-z0-9_]*)\(\s*([^,\s()[\]|"']+)\s*,\s*([^,\s()[\]|"']+)\s*\)\.$/;
const FAST_BINARY_RULE = /^([a-z][A-Za-z0-9_]*)\(\s*([^,\s()[\]|"']+)\s*,\s*([^,\s()[\]|"']+)\s*\)\s*:-\s*([a-z][A-Za-z0-9_]*)\(\s*([^,\s()[\]|"']+)\s*,\s*([^,\s()[\]|"']+)\s*\)\.$/;
const SIMPLE_VARIABLE = /^(?:_|[A-Z_][A-Za-z0-9_]*)$/;
const SIMPLE_ATOM = /^[a-z][A-Za-z0-9_]*$/;
const GRAPHIC_ATOM = /^[#$&*+\-\/<=>@^~\\]+$/;

function parseClausesFastNoSource(source) {
  source = String(source ?? '');
  const numberCache = new Map();
  const stringCache = new Map();
  const variableCache = new Map();
  const clauses = [];
  let anonymous = 0;
  let chunk = '';

  const cached = (cache, key, create) => {
    const existing = cache.get(key);
    if (existing) return existing;
    const value = create(key);
    cache.set(key, value);
    return value;
  };

  const isFastScalarToken = (text) => SIMPLE_VARIABLE.test(text) || SIMPLE_ATOM.test(text) || GRAPHIC_ATOM.test(text) || SIMPLE_NUMBER.test(text);
  const scalarOrVariableFast = (text) => {
    if (!text || !isFastScalarToken(text)) throw new Error('bad simple term');
    const first = text.charCodeAt(0);
    if (text === '_') return variable(`__anon${anonymous++}`);
    if (SIMPLE_VARIABLE.test(text)) {
      const existing = variableCache.get(text);
      if (existing) return existing;
      const value = variable(text);
      variableCache.set(text, value);
      return value;
    }
    if ((first === 45 || isDigitCode(first)) && SIMPLE_NUMBER.test(text)) return cached(numberCache, text, numberTerm);
    return atom(text);
  };

  const trimRange = (text, start, end) => {
    while (start < end && isWhitespaceCode(text.charCodeAt(start))) start++;
    while (end > start && isWhitespaceCode(text.charCodeAt(end - 1))) end--;
    return [start, end];
  };

  const tokenKindInRange = (text, start, end) => {
    if (start >= end) return null;
    const first = text.charCodeAt(start);
    if (first === 95 || (first >= 65 && first <= 90)) {
      for (let i = start + 1; i < end; i++) if (!isNameContinueCode(text.charCodeAt(i))) return null;
      return 'var';
    }
    if (first >= 97 && first <= 122) {
      for (let i = start + 1; i < end; i++) if (!isNameContinueCode(text.charCodeAt(i))) return null;
      return 'atom';
    }
    let allGraphic = true;
    for (let i = start; i < end; i++) {
      if (!isGraphicAtomCode(text.charCodeAt(i))) { allGraphic = false; break; }
    }
    if (allGraphic) return 'atom';
    return null;
  };

  const simpleNumberInRange = (text, start, end) => {
    let i = start;
    if (text.charCodeAt(i) === 45) i++;
    if (i >= end || !isDigitCode(text.charCodeAt(i))) return false;
    while (i < end && isDigitCode(text.charCodeAt(i))) i++;
    if (i < end && text.charCodeAt(i) === 46) {
      i++;
      if (i >= end || !isDigitCode(text.charCodeAt(i))) return false;
      while (i < end && isDigitCode(text.charCodeAt(i))) i++;
    }
    if (i < end && (text.charCodeAt(i) === 101 || text.charCodeAt(i) === 69)) {
      i++;
      if (i < end && (text.charCodeAt(i) === 43 || text.charCodeAt(i) === 45)) i++;
      if (i >= end || !isDigitCode(text.charCodeAt(i))) return false;
      while (i < end && isDigitCode(text.charCodeAt(i))) i++;
    }
    return i === end;
  };

  const scalarOrVariableRange = (text, start, end) => {
    [start, end] = trimRange(text, start, end);
    const kind = tokenKindInRange(text, start, end);
    const value = text.slice(start, end);
    if (kind === 'var') {
      if (value === '_') return variable(`__anon${anonymous++}`);
      const existing = variableCache.get(value);
      if (existing) return existing;
      const term = variable(value);
      variableCache.set(value, term);
      return term;
    }
    if (kind === 'atom') return atom(value);
    if (simpleNumberInRange(text, start, end)) return cached(numberCache, value, numberTerm);
    return null;
  };

  const parseBinaryCompoundRange = (text, start = 0, end = text.length) => {
    [start, end] = trimRange(text, start, end);
    let i = start;
    const first = text.charCodeAt(i);
    if (!(first >= 97 && first <= 122)) return null;
    i++;
    while (i < end && isNameContinueCode(text.charCodeAt(i))) i++;
    const nameEnd = i;
    while (i < end && isWhitespaceCode(text.charCodeAt(i))) i++;
    if (text.charCodeAt(i) !== 40) return null;
    i++;
    const arg1Start = i;
    while (i < end && text.charCodeAt(i) !== 44 && text.charCodeAt(i) !== 40 && text.charCodeAt(i) !== 41 && text.charCodeAt(i) !== 91 && text.charCodeAt(i) !== 93 && text.charCodeAt(i) !== 124 && text.charCodeAt(i) !== 34 && text.charCodeAt(i) !== 39) i++;
    if (i >= end || text.charCodeAt(i) !== 44) return null;
    const arg1End = i;
    i++;
    const arg2Start = i;
    while (i < end && text.charCodeAt(i) !== 41 && text.charCodeAt(i) !== 40 && text.charCodeAt(i) !== 44 && text.charCodeAt(i) !== 91 && text.charCodeAt(i) !== 93 && text.charCodeAt(i) !== 124 && text.charCodeAt(i) !== 34 && text.charCodeAt(i) !== 39) i++;
    if (i >= end || text.charCodeAt(i) !== 41) return null;
    const arg2End = i;
    i++;
    while (i < end && isWhitespaceCode(text.charCodeAt(i))) i++;
    if (i !== end) return null;
    const left = scalarOrVariableRange(text, arg1Start, arg1End);
    if (!left) return null;
    const right = scalarOrVariableRange(text, arg2Start, arg2End);
    if (!right) return null;
    return compound(text.slice(start, nameEnd), [left, right]);
  };

  const parseFastLine = (text) => {
    if (!text.endsWith('.')) return null;
    const end = text.length - 1;
    const rule = text.indexOf(':-');
    if (rule < 0) {
      const head = parseBinaryCompoundRange(text, 0, end);
      return head ? { head, body: [] } : null;
    }
    if (text.indexOf(':-', rule + 2) >= 0) return null;
    const head = parseBinaryCompoundRange(text, 0, rule);
    if (!head) return null;
    const bodyGoal = parseBinaryCompoundRange(text, rule + 2, end);
    return bodyGoal ? { head, body: [bodyGoal] } : null;
  };

  const findRuleInRange = (text, start, end) => {
    // String#indexOf has no end bound. Using it here used to scan the rest of
    // the complete source for every fact line, making large fact files
    // quadratic when their rules appeared before the facts.
    for (let i = start; i + 1 < end; i++) {
      if (text.charCodeAt(i) === 58 && text.charCodeAt(i + 1) === 45) return i;
    }
    return -1;
  };

  const parseFastRange = (text, start, end) => {
    if (start >= end || text.charCodeAt(end - 1) !== 46) return null;
    const termEnd = end - 1;
    const rule = findRuleInRange(text, start, termEnd);
    if (rule < 0) {
      const head = parseBinaryCompoundRange(text, start, termEnd);
      return head ? { head, body: [] } : null;
    }
    if (findRuleInRange(text, rule + 2, termEnd) >= 0) return null;
    const head = parseBinaryCompoundRange(text, start, rule);
    if (!head) return null;
    const bodyGoal = parseBinaryCompoundRange(text, rule + 2, termEnd);
    return bodyGoal ? { head, body: [bodyGoal] } : null;
  };

  const scalarOrVariable = (text) => scalarOrVariableFast(text.trim());
  const parseBinaryCompound = (text) => {
    const parsed = parseBinaryCompoundRange(text, 0, text.length);
    if (parsed) return parsed;
    text = text.trim();
    const open = text.indexOf('(');
    if (open <= 0 || text[text.length - 1] !== ')') return null;
    const name = text.slice(0, open).trim();
    if (!isSimpleName(name)) return null;
    const inner = text.slice(open + 1, -1);
    if (inner.includes('(') || inner.includes(')') || inner.includes('[') || inner.includes(']') || inner.includes('|') || inner.includes('"') || inner.includes("'")) return null;
    const comma = inner.indexOf(',');
    if (comma < 0 || inner.indexOf(',', comma + 1) >= 0) return null;
    const left = inner.slice(0, comma).trim();
    const right = inner.slice(comma + 1).trim();
    if (!isFastScalarToken(left) || !isFastScalarToken(right)) return null;
    return compound(name, [scalarOrVariable(left), scalarOrVariable(right)]);
  };

  const parseSimple = (text) => {
    const fast = parseFastLine(text);
    if (fast) return fast;
    if (!text.endsWith('.') || text.includes('\n')) return null;
    text = text.slice(0, -1);
    const rule = text.indexOf(':-');
    if (rule < 0) {
      const head = parseBinaryCompound(text);
      return head ? { head, body: [] } : null;
    }
    const head = parseBinaryCompound(text.slice(0, rule));
    const bodyGoal = parseBinaryCompound(text.slice(rule + 2));
    return head && bodyGoal ? { head, body: [bodyGoal] } : null;
  };

  const flush = () => {
    const text = chunk.trim();
    chunk = '';
    if (!text) return true;
    const simple = parseSimple(text);
    if (simple) {
      clauses.push(simple);
      return true;
    }
    try {
      const parsed = new Parser(text, { sourceMetadata: false }).parseProgram();
      clauses.push(...parsed);
      return true;
    } catch (_) {
      return false;
    }
  };

  let lineStart = 0;
  while (lineStart <= source.length) {
    let lineEnd = source.indexOf('\n', lineStart);
    if (lineEnd < 0) lineEnd = source.length;
    let contentStart = lineStart;
    let contentEnd = lineEnd;
    if (contentEnd > contentStart && source.charCodeAt(contentEnd - 1) === 13) contentEnd--;
    [contentStart, contentEnd] = trimRange(source, contentStart, contentEnd);
    if (contentStart < contentEnd && source.charCodeAt(contentStart) !== 37) {
      if (!chunk && source.charCodeAt(contentEnd - 1) === 46) {
        const simple = parseFastRange(source, contentStart, contentEnd);
        if (simple) clauses.push(simple);
        else {
          chunk = source.slice(lineStart, lineEnd) + '\n';
          if (!flush()) return null;
        }
      } else {
        chunk += source.slice(lineStart, lineEnd) + '\n';
        if (source.charCodeAt(contentEnd - 1) === 46) {
          if (!flush()) return null;
        }
      }
    }
    if (lineEnd === source.length) break;
    lineStart = lineEnd + 1;
  }
  if (chunk.trim() && !flush()) return null;
  return clauses;
}

export function parseProgramText(source) {
  return parseClauses(source);
}

export function parseGoalText(text) {
  const clauses = parseClauses(`zz_goal(${text}).`);
  const head = clauses[0]?.head;
  if (!head || head.args.length < 1) throw new Error('bad goal');
  return head.args[0];
}
