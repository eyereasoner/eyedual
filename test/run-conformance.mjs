#!/usr/bin/env node
// Conformance test runner.
// It executes normal cases in-process so the conformance corpus measures engine behavior instead of Node process startup.
import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { Program, createDefaultRegistry, run } from '../src/index.js';
import { fileURLToPath } from 'node:url';
import { TestReporter, isMainModule } from './test-style.mjs';
import { goalsFromSource } from './goal-metadata.mjs';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)));
const filterArg = process.argv[2] ?? null;

export function runConformance(reporter = new TestReporter(), requestedFilter = null) {
  const filter = requestedFilter ?? filterArg;
  const label = filter == null ? 'eyelang' : `eyelang ${filter}`;
  reporter.section(`Conformance ${label}`);
  for (const file of listCaseFiles('cases', filter)) runCaseFile(reporter, file);
  for (const file of listCaseFiles('errors', filter)) runErrorFile(reporter, file);
  for (const file of listCaseFiles('warnings', filter)) runWarningFile(reporter, file);
  for (const file of listCaseFiles('proofs', filter)) runProofFile(reporter, file);
  reporter.sectionTotal(`conformance ${label}`);
}

function listCaseFiles(kind, filter = null) {
  const base = path.join(root, 'conformance', kind);
  if (!fs.existsSync(base)) return [];
  return listEyeLangFiles(base)
    .filter((name) => matchesFilter(kind, name, filter))
    .sort();
}

function matchesFilter(kind, name, filter) {
  if (filter == null) return true;
  const stem = name.slice(0, -3);
  const label = kind === 'errors' ? 'error' : kind === 'warnings' ? 'warning' : kind;
  return name.includes(filter)
    || stem === filter
    || stem.includes(filter)
    || `${kind}/${stem}`.includes(filter)
    || `${label}/${stem}`.includes(filter);
}

function listEyeLangFiles(base, dir = base) {
  const files = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...listEyeLangFiles(base, full));
    } else if (entry.isFile() && entry.name.endsWith('.pl')) {
      files.push(path.relative(base, full).split(path.sep).join('/'));
    }
  }
  return files;
}

function runCaseFile(reporter, file) {
  const name = file.slice(0, -3);
  reporter.test(name, () => runCase(name, file));
}

function runErrorFile(reporter, file) {
  const name = file.slice(0, -3);
  reporter.test(`error/${name}`, () => runErrorCase(name, file));
}

function runWarningFile(reporter, file) {
  const name = file.slice(0, -3);
  reporter.test(`warning/${name}`, () => runWarningCase(name, file));
}

function runProofFile(reporter, file) {
  const name = file.slice(0, -3);
  reporter.test(`proof/${name}`, () => runProofCase(name, file));
}

function runCase(name, file) {
  const casesDir = path.join(root, 'conformance', 'cases');
  const expectedDir = path.join(root, 'conformance', 'expected');
  const programFile = path.join(casesDir, file);
  const expected = path.join(expectedDir, `${name}.pl`);
  const text = fs.readFileSync(programFile, 'utf8');
  const program = Program.parseSources([{ text, filename: file }], { sourceMetadata: false });
  const actual = run(program, { goals: goalsFromSource(text), registry: file.startsWith('iso/') ? createDefaultRegistry() : undefined }).stdout;

  compareExpectedFile(expected, actual, name, 'output');
}

function runErrorCase(name, file) {
  const casesDir = path.join(root, 'conformance', 'errors');
  const expectedDir = path.join(root, 'conformance', 'expected-errors');
  const programFile = path.join(casesDir, file);
  const expected = path.join(expectedDir, `${name}.txt`);
  const text = fs.readFileSync(programFile, 'utf8');
  let actual = null;

  try {
    const program = Program.parseSources([{ text, filename: file }], { sourceMetadata: false });
    run(program, { goals: goalsFromSource(text), registry: file.startsWith('iso/') ? createDefaultRegistry() : undefined });
  } catch (error) {
    actual = `${error?.message ?? String(error)}\n`;
  }

  if (actual == null) throw new Error(`expected error for ${name}, but program succeeded`);
  compareExpectedFile(expected, actual, name, 'error');
}

function runWarningCase(name, file) {
  const warningsDir = path.join(root, 'conformance', 'warnings');
  const expectedDir = path.join(root, 'conformance', 'expected-warnings');
  const programFile = path.join(warningsDir, file);
  const expectedStdout = path.join(expectedDir, `${name}.pl`);
  const expectedStderr = path.join(expectedDir, `${name}.txt`);
  const text = fs.readFileSync(programFile, 'utf8');
  // These cases used to start a fresh Node process for each CLI invocation.
  // Exercise the same parser and runner in-process; CLI argument handling is
  // covered by regression tests, while this corpus verifies engine warnings.
  const program = Program.parseSources([{ text, filename: '<stdin>' }], {
    sourceMetadata: false,
  });
  const stderr = formatWarnings(program);
  const stdout = run(program, { goals: goalsFromSource(text) }).stdout;

  compareExpectedFile(expectedStdout, stdout, name, 'warning stdout');
  compareExpectedFile(expectedStderr, stderr, name, 'warning stderr');
}

function runProofCase(name, file) {
  const proofsDir = path.join(root, 'conformance', 'proofs');
  const expectedDir = path.join(root, 'conformance', 'expected-proofs');
  const programFile = path.join(proofsDir, file);
  const expected = path.join(expectedDir, `${name}.pl`);
  const text = fs.readFileSync(programFile, 'utf8');
  const program = Program.parseSources([{ text, filename: '<stdin>' }], {
    sourceMetadata: true,
  });
  const stdout = run(program, { goals: goalsFromSource(text), proof: true }).stdout;

  compareExpectedFile(expected, stdout, name, 'proof output');
  Program.parse(stdout);
}

function formatWarnings(program) {
  const errors = program.negationStratificationErrors;
  if (errors.length === 0) return '';

  let text = 'eyelang warning: unstratified negation\n';
  for (const edge of errors) text += `  ${edge.from} depends negatively on ${edge.to}\n`;
  return text;
}

function compareExpectedFile(expected, actual, name, kind) {
  if (!fs.existsSync(expected)) {
    throw new Error(`missing expected ${kind} file: ${path.relative(root, expected)}`);
  }

  const expectedText = fs.readFileSync(expected, 'utf8');
  if (expectedText !== actual) {
    throw new Error(`${kind} mismatch for ${name}\n${diffText(expected, actual)}`.trimEnd());
  }
}

function diffText(expected, actualText) {
  const diff = spawnSync('diff', ['-u', expected, '-'], { input: actualText, encoding: 'utf8' });
  if (diff.stdout) return diff.stdout;

  const expectedText = fs.readFileSync(expected, 'utf8').split('\n');
  const actualLines = actualText.split('\n');
  const limit = Math.max(expectedText.length, actualLines.length);
  for (let i = 0; i < limit; i++) {
    if (expectedText[i] !== actualLines[i]) {
      return `first difference at line ${i + 1}\nexpected: ${expectedText[i] ?? '<missing>'}\nactual:   ${actualLines[i] ?? '<missing>'}`;
    }
  }

  return 'outputs differ';
}

if (isMainModule(import.meta.url)) {
  const reporter = new TestReporter();
  try {
    runConformance(reporter);
    reporter.totalLine();
  } catch (_) {
    process.exit(1);
  }
}
