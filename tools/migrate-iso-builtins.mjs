#!/usr/bin/env node
// One-way, layout-preserving source migration from legacy Eyepl calls to ISO
// Prolog goals. Only .pl files are accepted; comments and quoted text are left
// byte-for-byte intact.
import fs from 'node:fs';
import path from 'node:path';

const binaryArithmetic = new Map([
  ['add', '+'], ['sub', '-'], ['mul', '*'], ['div', '/'],
  ['mod', 'mod'], ['min', 'min'], ['max', 'max'], ['pow', '**'],
]);
const unaryArithmetic = new Map([
  ['neg', '-'], ['abs', 'abs'], ['sin', 'sin'], ['cos', 'cos'],
  ['sqrt', 'sqrt'],
  ['floor', 'floor'], ['ceiling', 'ceiling'], ['trunc', 'truncate'],
  ['rounded', 'round'], ['exp', 'exp'], ['log', 'log'],
]);
const comparisons = new Map([
  ['lt', '<'], ['le', '=<'], ['gt', '>'], ['ge', '>='],
]);
const migratedNames = new Set([
  'eq', 'neq', 'not', 'compound_name_arguments',
  ...binaryArithmetic.keys(), ...unaryArithmetic.keys(), ...comparisons.keys(),
]);

function matchingParen(source, open) {
  let depth = 0;
  let quote = null;
  for (let i = open; i < source.length; i++) {
    const ch = source[i];
    if (quote) {
      if (ch === '\\') i++;
      else if (ch === quote) {
        if (source[i + 1] === quote) i++;
        else quote = null;
      }
      continue;
    }
    if (ch === "'" || ch === '"') { quote = ch; continue; }
    if (ch === '%') {
      while (i + 1 < source.length && source[i + 1] !== '\n') i++;
      continue;
    }
    if (ch === '(' || ch === '[') depth++;
    else if (ch === ')' || ch === ']') {
      depth--;
      if (depth === 0) return i;
    }
  }
  return -1;
}

function argumentsOf(text) {
  const parts = [];
  let start = 0;
  let depth = 0;
  let quote = null;
  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    if (quote) {
      if (ch === '\\') i++;
      else if (ch === quote) {
        if (text[i + 1] === quote) i++;
        else quote = null;
      }
    } else if (ch === "'" || ch === '"') quote = ch;
    else if (ch === '(' || ch === '[') depth++;
    else if (ch === ')' || ch === ']') depth--;
    else if (ch === ',' && depth === 0) {
      parts.push(text.slice(start, i).trim());
      start = i + 1;
    }
  }
  parts.push(text.slice(start).trim());
  return parts;
}

function replacement(name, args) {
  if (name === 'eq' && args.length === 2) return `(${args[0]} = ${args[1]})`;
  if (name === 'neq' && args.length === 2) return `(${args[0]} \\= ${args[1]})`;
  if (name === 'not' && args.length === 1) return `\\+ ${args[0]}`;
  if (comparisons.has(name) && args.length === 2) return `(${args[0]} ${comparisons.get(name)} ${args[1]})`;
  if (binaryArithmetic.has(name) && args.length === 3) {
    const op = binaryArithmetic.get(name);
    const expression = ['min', 'max', 'atan2'].includes(op)
      ? `${op}(${args[0]}, ${args[1]})`
      : `${args[0]} ${op} ${args[1]}`;
    return `(${args[2]} is ${expression})`;
  }
  if (unaryArithmetic.has(name) && args.length === 2) {
    return `(${args[1]} is ${unaryArithmetic.get(name)}(${args[0]}))`;
  }
  if (name === 'compound_name_arguments' && args.length === 3) {
    return `(${args[0]} =.. [${args[1]} | ${args[2]}])`;
  }
  return `${name}(${args.join(', ')})`;
}

function migrateText(source) {
  let out = '';
  for (let i = 0; i < source.length;) {
    const ch = source[i];
    if (ch === '%' || ch === "'" || ch === '"') {
      const quote = ch === '%' ? '\n' : ch;
      let end = i + 1;
      while (end < source.length) {
        if (quote !== '\n' && source[end] === '\\') { end += 2; continue; }
        if (source[end] === quote) {
          if (quote !== '\n' && source[end + 1] === quote) { end += 2; continue; }
          end++;
          break;
        }
        end++;
      }
      out += source.slice(i, end);
      i = end;
      continue;
    }
    const match = /^[a-z][A-Za-z0-9_]*/.exec(source.slice(i));
    if (!match) { out += ch; i++; continue; }
    const name = match[0];
    const afterName = i + name.length;
    let open = afterName;
    while (source[open] === ' ' || source[open] === '\t') open++;
    if (!migratedNames.has(name) || source[open] !== '(') {
      out += source.slice(i, afterName);
      i = afterName;
      continue;
    }
    const close = matchingParen(source, open);
    if (close < 0) throw new Error(`unclosed ${name}/? call`);
    const args = argumentsOf(source.slice(open + 1, close)).map(migrateText);
    out += replacement(name, args);
    i = close + 1;
  }
  return out;
}

function filesUnder(entry) {
  const stat = fs.statSync(entry);
  if (stat.isFile()) return entry.endsWith('.pl') || entry.endsWith('.md') ? [entry] : [];
  return fs.readdirSync(entry).flatMap((name) => filesUnder(path.join(entry, name)));
}

const targets = process.argv.slice(2);
if (targets.length === 0) {
  console.error('usage: node tools/migrate-iso-builtins.mjs FILE_OR_DIRECTORY...');
  process.exit(64);
}
for (const target of targets) {
  for (const filename of filesUnder(target)) {
    const source = fs.readFileSync(filename, 'utf8');
    const migrated = filename.endsWith('.md')
      ? source.replace(/```eyepl\n([\s\S]*?)```/g, (_, code) => `\`\`\`eyepl\n${migrateText(code)}\`\`\``)
      : migrateText(source);
    if (migrated !== source) fs.writeFileSync(filename, migrated);
  }
}
