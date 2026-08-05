#!/usr/bin/env node
import fs from 'node:fs/promises';
import process from 'node:process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { Program } from '../src/program.js';
import { eyeDualQuadToNQuad } from './rdf-codec.mjs';

export function extractEyeDualRdf(source) {
  const program = Program.parse(String(source), { sourceMetadata: false });
  const lines = []; const seen = new Set();
  for (const c of program.clauses) {
    if (c.body.length || c.head?.name !== 'rdf' || c.head?.arity !== 4) continue;
    const line = eyeDualQuadToNQuad(c.head);
    if (!seen.has(line)) { seen.add(line); lines.push(line); }
  }
  return lines.length ? `${lines.join('\n')}\n` : '';
}
async function main(argv) {
  let input = '-'; let output = '-';
  for (let i = 0; i < argv.length; i++) { const a = argv[i]; if (a === '-h' || a === '--help') return usage(); if (a === '-o' || a === '--output') output = required(argv, ++i, a); else if (a.startsWith('-') && a !== '-') throw new Error(`unknown option: ${a}`); else if (input === '-') input = a; else throw new Error(`unexpected argument: ${a}`); }
  const source = input === '-' ? await stdin() : await fs.readFile(input, 'utf8');
  const result = extractEyeDualRdf(source);
  if (output === '-') process.stdout.write(result); else await fs.writeFile(output, result);
}
function usage() { process.stdout.write('Usage: node tools/pl-to-rdf.mjs [options] [input.pl|-]\n\n  -o, --output FILE  Write N-Quads to FILE\n'); }
function required(a, i, o) { if (a[i] == null) throw new Error(`${o} requires a value`); return a[i]; }
function stdin() { return new Promise((resolve, reject) => { let s = ''; process.stdin.setEncoding('utf8'); process.stdin.on('data', (c) => { s += c; }); process.stdin.on('end', () => resolve(s)); process.stdin.on('error', reject); }); }
if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) main(process.argv.slice(2)).catch((e) => { process.stderr.write(`pl-to-rdf: ${e.message}\n`); process.exitCode = 1; });
