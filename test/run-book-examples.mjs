#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { Program, run } from '../src/index.js';
import { TestReporter, isMainModule } from './test-style.mjs';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const examplesRoot = path.join(root, 'examples', 'book');

export function runBookExamples(reporter = new TestReporter()) {
  const files = listPrograms(examplesRoot);

  reporter.section('Book examples');
  for (const filename of files) {
    const relative = path.relative(examplesRoot, filename);
    reporter.test(relative, () => validateBookExample(filename));
  }
  reporter.sectionTotal('book example');
}

function validateBookExample(filename) {
  const source = fs.readFileSync(filename, 'utf8');
  const program = Program.parse(source);
  if (/^query\s*\(/m.test(source)) run(program);
}

function listPrograms(directory) {
  return fs.readdirSync(directory, { withFileTypes: true })
    .flatMap((entry) => {
      const target = path.join(directory, entry.name);
      if (entry.isDirectory()) return listPrograms(target);
      return entry.name.endsWith('.pl') ? [target] : [];
    })
    .sort();
}

if (isMainModule(import.meta.url)) {
  const reporter = new TestReporter();
  try {
    runBookExamples(reporter);
    reporter.totalLine();
  } catch (_) {
    process.exit(1);
  }
}
