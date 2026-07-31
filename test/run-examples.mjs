#!/usr/bin/env node
// Example-output test runner.
// It compares examples byte-for-byte against golden output so answer and proof changes cannot silently alter results.
import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { Program, run } from '../src/index.js';
import { fileURLToPath } from 'node:url';
import { TestReporter, isMainModule } from './test-style.mjs';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)));
const packageRoot = path.resolve(root, '..');
const examplesDir = path.join(packageRoot, 'examples');
const expectedDir = path.join(examplesDir, 'output');
const expectedProofDir = path.join(examplesDir, 'proof');
const fixedExampleDate = '2026-05-30';

const proofExamples = [
  'access-control-policy.pl',
  'age.pl',
  'aliases-and-namespaces.pl',
  'ancestor.pl',
  'animal.pl',
  'annotation.pl',
  'backward.pl',
  'bayes-diagnosis.pl',
  'cat-koko.pl',
  'context-association.pl',
  'data-negotiation.pl',
  'deontic-logic.pl',
  'derived-backward-rule.pl',
  'derived-rule.pl',
  'dog.pl',
  'electrical-rc-filter.pl',
  'existential-rule.pl',
  'floating-point.pl',
  'good-cobbler.pl',
  'graph-reachability.pl',
  'greatest-lower-bound-uniqueness.pl',
  'group-inverse-uniqueness.pl',
  'herbrand-semantics.pl',
  'list-collection.pl',
  'proof-contrapositive.pl',
  'reusable-builtins.pl',
  'socket-age.pl',
  'socket-family.pl',
  'socrates.pl',
  'spacecraft-battery-diagnosis.pl',
  'term-tools.pl',
  'witch.pl',
  'beam-deflection.pl',
  'cache-performance.pl',
  'canary-release.pl',
  'chart-parser.pl',
  'clinical-trial-screening.pl',
  'composition-of-injective-functions-is-injective.pl',
  'diamond-property.pl',
  'dpv-odrl-purpose-mapping.pl',
  'epidemic-policy.pl',
  'equivalence-classes-overlap-implies-same-class.pl',
  'expression-eval.pl',
  'gdpr-compliance.pl',
  'hanoi.pl',
  'heat-loss.pl',
  'ideal-gas-law.pl',
  'intuitionistic-logic-kripke.pl',
  'linear-logic-resources.pl',
  'modal-logic-kripke.pl',
  'nixon-diamond.pl',
  'security-incident-correlation.pl',
];

export function runExamples(reporter = new TestReporter()) {
  const files = fs.readdirSync(examplesDir)
    .filter((name) => exampleIsRunnable(name))
    .sort();

  reporter.section('Examples');
  for (const name of files) reporter.test(name, () => runExample(name));
  reporter.sectionTotal('examples');

  reporter.section('Proof examples');
  for (const name of proofExamples) reporter.test(name, () => runProofExample(name));
  reporter.sectionTotal('proof examples');
}


function exampleIsRunnable(name) {
  return name.endsWith('.pl');
}

function runExample(name) {
  const programFile = path.join(examplesDir, name);
  const expected = path.join(expectedDir, name);
  const actual = runProgramExample(programFile, name, { proof: false });
  compareOutput(name, expected, actual, 'output');
}

function runProofExample(name) {
  const programFile = path.join(examplesDir, name);
  const expected = path.join(expectedProofDir, name);
  const actual = runProgramExample(programFile, name, { proof: true });
  compareOutput(name, expected, actual, 'proof output');
}

function runProgramExample(programFile, filename, options) {
  const oldLocalTime = process.env.EYEPL_LOCAL_TIME;
  process.env.EYEPL_LOCAL_TIME = fixedExampleDate;
  try {
    const text = fs.readFileSync(programFile, 'utf8');
    const expectedExit = text.match(/^%\s*expect-exit:\s*(\d+)\s*$/m);
    const program = Program.parseSources([{ text, filename }], {
      sourceMetadata: options.proof,
      markRecursive: options.proof,
    });
    try {
      const result = run(program, options);
      if (expectedExit) throw new Error(`${filename} expected exit ${expectedExit[1]}, but reasoning succeeded`);
      return result.stdout;
    } catch (error) {
      if (expectedExit && error?.code === Number(expectedExit[1])) return error.stdout ?? '';
      throw error;
    }
  } finally {
    if (oldLocalTime == null) delete process.env.EYEPL_LOCAL_TIME;
    else process.env.EYEPL_LOCAL_TIME = oldLocalTime;
  }
}

function compareOutput(name, expected, actual, label) {
  if (!fs.existsSync(expected)) {
    throw new Error(`missing expected ${label} file: ${path.relative(root, expected)}`);
  }

  const expectedText = fs.readFileSync(expected, 'utf8');
  if (expectedText !== actual) {
    throw new Error(`${label} mismatch for ${name}\n${diffText(expected, actual)}`.trimEnd());
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
    runExamples(reporter);
    reporter.totalLine();
  } catch (_) {
    process.exit(1);
  }
}
