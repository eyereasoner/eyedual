import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

import { getDefaultRegistry } from '../src/iso.js';
import { Program } from '../src/program.js';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const bookPath = path.join(root, 'the-art-of-eyepl.md');
const book = fs.readFileSync(bookPath, 'utf8');
const failures = [];

let blockCount = 0;
let fragmentCount = 0;
const eyeplBlocks = /```eyepl\n([\s\S]*?)```/g;
for (const match of book.matchAll(eyeplBlocks)) {
  blockCount += 1;
  const source = match[1].trim();
  const line = book.slice(0, match.index).split('\n').length;

  // A few displays intentionally show a single goal rather than a program.
  if (!source.endsWith('.')) {
    fragmentCount += 1;
    continue;
  }

  try {
    Program.parse(source);
  } catch (error) {
    failures.push(`Eyepl block at line ${line}: ${error.message}`);
  }
}

const localReferences = new Set();
for (const match of book.matchAll(/<img\s+[^>]*src="([^"]+)"/g)) {
  if (!/^[a-z]+:/i.test(match[1])) localReferences.add(match[1]);
}
for (const match of book.matchAll(/`(examples\/[^`\s]+\.pl)`/g)) {
  localReferences.add(match[1]);
}
for (const match of book.matchAll(/\[[^\]]+\]\(([^)]+)\)/g)) {
  const target = match[1].split('#', 1)[0];
  if (target && !target.startsWith('#') && !/^[a-z]+:/i.test(target)) {
    localReferences.add(decodeURIComponent(target));
  }
}
for (const reference of localReferences) {
  if (!fs.existsSync(path.join(root, reference))) {
    failures.push(`Missing referenced file: ${reference}`);
  }
}

const builtinsStart = book.indexOf('| Family | Registered predicate indicators |');
const builtinsEnd = book.indexOf('\n\n', builtinsStart);
if (builtinsStart < 0 || builtinsEnd < 0) {
  failures.push('Could not find the built-in index in Chapter 39');
} else {
  const documented = new Set(
    [...book.slice(builtinsStart, builtinsEnd).matchAll(/`([^`\s]+)\/(\d+)`/g)]
      .map((match) => `${match[1]}/${match[2]}`),
  );
  const registered = new Set(getDefaultRegistry().defs.keys());
  for (const indicator of registered) {
    if (!documented.has(indicator)) failures.push(`Undocumented built-in: ${indicator}`);
  }
  for (const indicator of documented) {
    if (!registered.has(indicator)) failures.push(`Documented but unregistered built-in: ${indicator}`);
  }
}

if (failures.length > 0) {
  process.stderr.write(`${failures.join('\n')}\n`);
  process.exitCode = 1;
} else {
  process.stdout.write(
    `Book check passed: ${blockCount - fragmentCount} programs parsed, ` +
    `${fragmentCount} goal fragment skipped, ${localReferences.size} local references resolved.\n`,
  );
}
