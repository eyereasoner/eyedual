// ISO term-output formatting kept separate from the stable source renderer.
import {
  ATOM, COMPOUND, NUMBER, STRING, VAR,
  Env, deref, isCons, isEmptyList,
} from './term.js';

const graphicAtomCharacters = new Set('!#$&*+-/<=>@^~\\'.split(''));

function atomNeedsQuotes(name) {
  if (!name) return true;
  if (name === '[]' || name === '{}') return false;
  if (name === '\\+' || name === '+' || name === '-' || name === '\\') return true;
  if (/^[a-z][A-Za-z0-9_]*$/.test(name)) return false;
  for (const ch of name) if (!graphicAtomCharacters.has(ch)) return true;
  return false;
}

function quoteAtom(name) {
  let out = "'";
  for (const ch of name) {
    if (ch === "'") out += "''";
    else if (ch === '\\') out += '\\\\';
    else if (ch === '\n') out += '\\n';
    else if (ch === '\t') out += '\\t';
    else out += ch;
  }
  return out + "'";
}

function writeAtom(name) {
  return atomNeedsQuotes(name) ? quoteAtom(name) : name;
}

function legacyVariableToIso(name) {
  if (name === '?') return '_';
  const tail = name.slice(1);
  if (!tail) return '_';
  if (tail[0] === '_') return tail;
  return tail[0].toUpperCase() + tail.slice(1);
}

function writeVariable(name) {
  name = String(name ?? '');
  if (/^\?(?:[A-Za-z_][A-Za-z0-9_]*)?$/.test(name)) return legacyVariableToIso(name);
  if (/^(?:_|[A-Z_][A-Za-z0-9_]*)$/.test(name)) return name;
  const sanitized = name.replace(/[^A-Za-z0-9_]/g, '_');
  if (!sanitized) return '_';
  return /^[A-Z_]/.test(sanitized) ? sanitized : `_${sanitized}`;
}

function writeString(value) {
  let out = '"';
  for (const ch of value) {
    if (ch === '"' || ch === '\\') out += `\\${ch}`;
    else if (ch === '\x07') out += '\\a';
    else if (ch === '\b') out += '\\b';
    else if (ch === '\r') out += '\\r';
    else if (ch === '\f') out += '\\f';
    else if (ch === '\t') out += '\\t';
    else if (ch === '\n') out += '\\n';
    else if (ch === '\v') out += '\\v';
    else out += ch;
  }
  return out + '"';
}

function writeNumberedVariable(index) {
  if (!Number.isSafeInteger(index) || index < 0) return null;
  const letter = String.fromCharCode(65 + (index % 26));
  const suffix = Math.floor(index / 26);
  return suffix === 0 ? letter : `${letter}${suffix}`;
}

function operatorName(name) {
  if (/^[a-z][A-Za-z0-9_]*$/.test(name)) return name;
  if (/^[!#$&*+\-./<=>@^~\\;:]+$/.test(name)) return name;
  return quoteAtom(name);
}

function operatorTable(definitions) {
  const table = new Map();
  for (const definition of definitions ?? []) {
    if (!definition || definition.priority === 0) continue;
    const entries = table.get(definition.name) ?? [];
    entries.push(definition);
    table.set(definition.name, entries);
  }
  return table;
}

function chooseOperator(term, table) {
  const definitions = table.get(term.name) ?? [];
  if (term.arity === 1) {
    return definitions.find((definition) => definition.specifier === 'fx' || definition.specifier === 'fy') ??
      definitions.find((definition) => definition.specifier === 'xf' || definition.specifier === 'yf') ?? null;
  }
  if (term.arity === 2) {
    return definitions.find((definition) => ['xfx', 'xfy', 'yfx'].includes(definition.specifier)) ?? null;
  }
  return null;
}

function format(term, env, options, table, maxPriority = 1200) {
  const resolved = deref(term, env);
  if (resolved.type === VAR) return options.variableNames.get(resolved.name) ?? writeVariable(resolved.name);
  if (resolved.type === STRING) return writeString(resolved.name);
  if (resolved.type === ATOM) return options.quoted ? writeAtom(resolved.name) : resolved.name;
  if (resolved.type === NUMBER) return resolved.name;

  if (options.numbervars && resolved.type === COMPOUND && resolved.name === '$VAR' && resolved.arity === 1) {
    const index = deref(resolved.args[0], env);
    if (index.type === NUMBER && /^\d+$/.test(index.name)) {
      const name = writeNumberedVariable(Number(index.name));
      if (name != null) return name;
    }
  }

  if (!options.ignoreOps && isCons(resolved)) {
    const parts = [];
    let cursor = resolved;
    while (true) {
      cursor = deref(cursor, env);
      if (isEmptyList(cursor)) return `[${parts.join(', ')}]`;
      if (!isCons(cursor)) return `[${parts.join(', ')} | ${format(cursor, env, options, table, 999)}]`;
      parts.push(format(cursor.args[0], env, options, table, 999));
      cursor = cursor.args[1];
    }
  }

  if (!options.ignoreOps && resolved.name === '{}' && resolved.arity === 1) {
    return `{${format(resolved.args[0], env, options, table, 1200)}}`;
  }

  if (!options.ignoreOps) {
    const definition = chooseOperator(resolved, table);
    if (definition) {
      const { priority, specifier } = definition;
      const token = operatorName(resolved.name);
      let text;
      if (specifier === 'fx' || specifier === 'fy') {
        const argumentPriority = specifier === 'fx' ? priority - 1 : priority;
        text = `${token} ${format(resolved.args[0], env, options, table, argumentPriority)}`;
      } else if (specifier === 'xf' || specifier === 'yf') {
        const argumentPriority = specifier === 'xf' ? priority - 1 : priority;
        text = `${format(resolved.args[0], env, options, table, argumentPriority)} ${token}`;
      } else {
        const leftPriority = specifier === 'yfx' ? priority : priority - 1;
        const rightPriority = specifier === 'xfy' ? priority : priority - 1;
        const left = format(resolved.args[0], env, options, table, leftPriority);
        const right = format(resolved.args[1], env, options, table, rightPriority);
        text = resolved.name === ',' ? `${left}, ${right}` : `${left} ${token} ${right}`;
      }
      return priority > maxPriority ? `(${text})` : text;
    }
  }

  const name = options.quoted ? writeAtom(resolved.name) : resolved.name;
  const args = resolved.args.map((arg) => format(arg, env, options, table, 999));
  return `${name}(${args.join(', ')})`;
}

export function formatTermForWrite(term, env = new Env(), options = {}) {
  const normalized = {
    quoted: options.quoted === true,
    ignoreOps: options.ignoreOps === true,
    numbervars: options.numbervars !== false,
    variableNames: options.variableNames instanceof Map ? options.variableNames : new Map(),
  };
  return format(term, env, normalized, operatorTable(options.operators), 1200);
}
