// Lossless RDF 1.2 <-> ordinary WebEntail term encoding.
export const XSD_STRING = 'http://www.w3.org/2001/XMLSchema#string';
export const RDF_LANG_STRING = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#langString';
export const RDF_DIR_LANG_STRING = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#dirLangString';

export function parseNQuads(source, { scope = 'input' } = {}) {
  return new NQuadsParser(stripVersionDirective(source), scope).parse();
}

function stripVersionDirective(source) {
  return String(source ?? '').replace(/^([ \t]*)VERSION[ \t]+"1\.2"[ \t]*(?:#.*)?$/m, '$1');
}

class NQuadsParser {
  constructor(source, scope) { this.source = source; this.scope = scope; this.offset = 0; }

  parse() {
    const quads = [];
    this.space();
    while (!this.done()) {
      const subject = this.resource('subject');
      this.requiredSpace();
      const predicate = this.iri();
      this.requiredSpace();
      const object = this.term('object');
      const hadSpace = this.space();
      const graph = this.peek() === '.' ? { kind: 'defaultGraph' } : this.resource('graph');
      if (graph.kind !== 'defaultGraph') this.space();
      if (this.take() !== '.') this.fail('expected a terminating period');
      if (!hadSpace && graph.kind !== 'defaultGraph') this.fail('expected whitespace before graph');
      quads.push({ subject, predicate, object, graph });
      this.space();
    }
    return quads;
  }

  term(position) {
    if (this.starts('<<(')) return this.triple();
    if (this.peek() === '<') return this.iri();
    if (this.starts('_:')) return this.blank();
    if (this.peek() === '"') return this.literal();
    this.fail(`expected RDF ${position}`);
  }

  resource(position) {
    const term = this.term(position);
    if (!['namedNode', 'blankNode'].includes(term.kind)) this.fail(`${position} must be an IRI or blank node`);
    return term;
  }

  triple() {
    this.offset += 3;
    this.space();
    const subject = this.resource('triple subject');
    this.requiredSpace();
    const predicate = this.iri();
    this.requiredSpace();
    const object = this.term('triple object');
    this.space();
    if (!this.starts(')>>')) this.fail('expected )>> after triple term');
    this.offset += 3;
    return { kind: 'triple', subject, predicate, object };
  }

  iri() {
    if (this.take() !== '<') this.fail('expected IRI');
    let value = '';
    while (!this.done() && this.peek() !== '>') {
      const c = this.take();
      if (c === '\\') value += this.unicodeEscape();
      else {
        if (/[\u0000-\u0020<>"{}|^`]/u.test(c)) this.fail('invalid character in IRI');
        value += c;
      }
    }
    if (this.take() !== '>') this.fail('unterminated IRI');
    return { kind: 'namedNode', value };
  }

  blank() {
    this.offset += 2;
    const start = this.offset;
    while (!this.done() && !/[\s<>"{}|^`\\()]/u.test(this.peek())) this.offset++;
    while (this.offset > start && this.source[this.offset - 1] === '.') this.offset--;
    const value = this.source.slice(start, this.offset);
    if (!/^[\p{L}\p{N}_](?:[\p{L}\p{N}\p{M}_\-\u00b7\u203f\u2040.]*[\p{L}\p{N}\p{M}_\-\u00b7\u203f\u2040])?$/u.test(value)) this.fail('invalid blank-node label');
    return { kind: 'blankNode', scope: this.scope, value };
  }

  literal() {
    this.offset++;
    let value = '';
    while (!this.done() && this.peek() !== '"') {
      const c = this.take();
      if (c === '\\') value += this.stringEscape();
      else {
        if (c.codePointAt(0) < 0x20) this.fail('control character in literal');
        value += c;
      }
    }
    if (this.take() !== '"') this.fail('unterminated literal');
    if (this.takeIf('@')) {
      const language = this.match(/[A-Za-z]+(?:-[A-Za-z0-9]+)*/y, 'language tag').toLowerCase();
      let direction = '';
      if (this.starts('--')) {
        this.offset += 2;
        direction = this.match(/(?:ltr|rtl)/iy, 'base direction').toLowerCase();
      }
      return { kind: 'literal', value, language, direction, datatype: direction ? RDF_DIR_LANG_STRING : RDF_LANG_STRING };
    }
    const datatype = this.starts('^^') ? (this.offset += 2, this.iri().value) : XSD_STRING;
    return { kind: 'literal', value, language: '', direction: '', datatype };
  }

  unicodeEscape() {
    const marker = this.take();
    const size = marker === 'u' ? 4 : marker === 'U' ? 8 : 0;
    if (!size) this.fail('IRI escapes must use \\u or \\U');
    const hexValue = this.source.slice(this.offset, this.offset + size);
    if (!new RegExp(`^[0-9A-Fa-f]{${size}}$`).test(hexValue)) this.fail('invalid Unicode escape');
    this.offset += size;
    const point = Number.parseInt(hexValue, 16);
    if (point > 0x10ffff || (point >= 0xd800 && point <= 0xdfff)) this.fail('invalid Unicode code point');
    return String.fromCodePoint(point);
  }

  stringEscape() {
    const c = this.take();
    const simple = { t: '\t', b: '\b', n: '\n', r: '\r', f: '\f', '"': '"', "'": "'", '\\': '\\' };
    if (Object.hasOwn(simple, c)) return simple[c];
    this.offset--;
    return this.unicodeEscape();
  }

  space() {
    const start = this.offset;
    for (;;) {
      while (/\s/u.test(this.peek() ?? '')) this.offset++;
      if (this.peek() !== '#') break;
      while (!this.done() && this.peek() !== '\n' && this.peek() !== '\r') this.offset++;
    }
    return this.offset > start;
  }

  requiredSpace() { if (!this.space()) this.fail('expected whitespace'); }
  match(pattern, label) { pattern.lastIndex = this.offset; const found = pattern.exec(this.source); if (!found) this.fail(`invalid ${label}`); this.offset = pattern.lastIndex; return found[0]; }
  starts(value) { return this.source.startsWith(value, this.offset); }
  takeIf(value) { if (!this.starts(value)) return false; this.offset += value.length; return true; }
  peek() { return this.source[this.offset]; }
  take() { return this.source[this.offset++]; }
  done() { return this.offset >= this.source.length; }
  fail(message) { const line = this.source.slice(0, this.offset).split(/\r\n?|\n/).length; throw new Error(`${message} on line ${line}`); }
}

export function fromRdfJsQuad(quad, scope = 'input') {
  return {
    subject: fromRdfJs(quad.subject, scope),
    predicate: fromRdfJs(quad.predicate, scope),
    object: fromRdfJs(quad.object, scope),
    graph: fromRdfJs(quad.graph, scope),
  };
}

export function fromRdfJs(term, scope = 'input') {
  if (term.termType === 'NamedNode') return { kind: 'namedNode', value: term.value };
  if (term.termType === 'BlankNode') return { kind: 'blankNode', scope, value: term.value };
  if (term.termType === 'DefaultGraph') return { kind: 'defaultGraph' };
  if (term.termType === 'Literal') return { kind: 'literal', value: term.value, language: term.language, direction: term.direction ?? '', datatype: term.datatype.value };
  if (term.termType === 'Quad') return { kind: 'triple', subject: fromRdfJs(term.subject, scope), predicate: fromRdfJs(term.predicate, scope), object: fromRdfJs(term.object, scope) };
  throw new Error(`unsupported RDF/JS term type: ${term.termType}`);
}

export function quadToWebEntail(q, predicate = 'rdf') {
  return `${predicate}(${toWebEntail(q.subject)}, ${toWebEntail(q.predicate)}, ${toWebEntail(q.object)}, ${toWebEntail(q.graph)}).`;
}

export function toWebEntail(t) {
  if (t.kind === 'namedNode') return `iri(${quote(t.value)})`;
  if (t.kind === 'blankNode') return `bnode(${quote(t.scope)}, ${quote(t.value)})`;
  if (t.kind === 'defaultGraph') return 'default_graph';
  if (t.kind === 'triple') return `triple(${toWebEntail(t.subject)}, ${toWebEntail(t.predicate)}, ${toWebEntail(t.object)})`;
  if (t.kind === 'literal') {
    const annotation = t.language
      ? (t.direction ? `lang(${quote(t.language)}, ${t.direction})` : `lang(${quote(t.language)})`)
      : `datatype(${quote(t.datatype ?? XSD_STRING)})`;
    return `literal(${quote(t.value)}, ${annotation})`;
  }
  throw new Error(`unsupported RDF term kind: ${t?.kind ?? typeof t}`);
}

export function webEntailQuadToNQuad(term) {
  if (term?.type !== 'compound' || term.name !== 'rdf' || term.args.length !== 4) throw new Error('expected rdf/4 fact');
  const [subject, predicate, object, graph] = term.args.map(fromWebEntail);
  assertTriple(subject, predicate, object);
  if (!['namedNode', 'blankNode', 'defaultGraph'].includes(graph.kind)) throw new Error('invalid RDF graph');
  return `${toNQ(subject)} ${toNQ(predicate)} ${toNQ(object)}${graph.kind === 'defaultGraph' ? '' : ` ${toNQ(graph)}`} .`;
}

export function fromWebEntail(t) {
  if (t?.type === 'atom' && t.name === 'default_graph') return { kind: 'defaultGraph' };
  if (compound(t, 'iri', 1)) return { kind: 'namedNode', value: scalar(t.args[0], 'IRI') };
  if (compound(t, 'bnode', 2)) return { kind: 'blankNode', scope: scalar(t.args[0], 'blank-node scope'), value: scalar(t.args[1], 'blank-node label') };
  if (compound(t, 'triple', 3)) {
    const [subject, predicate, object] = t.args.map(fromWebEntail);
    assertTriple(subject, predicate, object);
    return { kind: 'triple', subject, predicate, object };
  }
  if (compound(t, 'literal', 2)) {
    const value = scalar(t.args[0], 'literal');
    if (compound(t.args[1], 'lang', 1)) return { kind: 'literal', value, language: scalar(t.args[1].args[0], 'language').toLowerCase(), direction: '', datatype: RDF_LANG_STRING };
    if (compound(t.args[1], 'lang', 2)) {
      const direction = scalar(t.args[1].args[1], 'base direction').toLowerCase();
      if (direction !== 'ltr' && direction !== 'rtl') throw new Error('base direction must be ltr or rtl');
      return { kind: 'literal', value, language: scalar(t.args[1].args[0], 'language').toLowerCase(), direction, datatype: RDF_DIR_LANG_STRING };
    }
    if (compound(t.args[1], 'datatype', 1)) return { kind: 'literal', value, language: '', datatype: scalar(t.args[1].args[0], 'datatype') };
    throw new Error('literal annotation must be lang/1, lang/2, or datatype/1');
  }
  throw new Error(`term is not an RDF value: ${t?.name ?? typeof t}`);
}

function toNQ(t) {
  if (t.kind === 'namedNode') return `<${escapeIri(t.value)}>`;
  if (t.kind === 'blankNode') return `_:e${hex(t.scope)}_${hex(t.value)}`;
  if (t.kind === 'triple') return `<<( ${toNQ(t.subject)} ${toNQ(t.predicate)} ${toNQ(t.object)} )>>`;
  if (t.kind === 'literal') {
    const q = `"${String(t.value).replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\r/g, '\\r').replace(/\n/g, '\\n')}"`;
    if (t.language) return `${q}@${t.language}${t.direction ? `--${t.direction}` : ''}`;
    return (t.datatype ?? XSD_STRING) === XSD_STRING ? q : `${q}^^<${escapeIri(t.datatype)}>`;
  }
  throw new Error(`cannot serialize ${t.kind}`);
}
function quote(v) { return `"${String(v).replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\n/g, '\\n').replace(/\t/g, '\\t')}"`; }
function escapeIri(v) { return String(v).replace(/[<>"{}|^`\\\u0000-\u0020]/g, (c) => `\\u${c.charCodeAt(0).toString(16).padStart(4, '0')}`); }
function hex(v) { return Buffer.from(String(v), 'utf8').toString('hex'); }
function compound(t, name, arity) { return t?.type === 'compound' && t.name === name && t.args.length === arity; }
function scalar(t, label) { if (!t || !['atom', 'string', 'number'].includes(t.type)) throw new Error(`${label} must be a scalar`); return t.name; }
function assertTriple(subject, predicate, object) {
  if (!['namedNode', 'blankNode'].includes(subject.kind)) throw new Error('RDF subject must be an IRI or blank node');
  if (predicate.kind !== 'namedNode') throw new Error('RDF predicate must be an IRI');
  if (!['namedNode', 'blankNode', 'literal', 'triple'].includes(object.kind)) throw new Error('invalid RDF object');
}
