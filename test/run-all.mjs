#!/usr/bin/env node
// Unified test runner used by `npm test`.
// Running all suites in one process keeps the numbering continuous and avoids
// npm's intermediate script banners between conformance, regression, and examples.
import { TestReporter } from './test-style.mjs';
import { runConformance } from './run-conformance.mjs';
import { runRegression } from './run-regression.mjs';
import { runPlayground } from './run-playground.mjs';
import { runExamples } from './run-examples.mjs';
import { runBookExamples } from './run-book-examples.mjs';
import { runRdfTools } from './run-rdf-tools.mjs';

const reporter = new TestReporter();

try {
  runConformance(reporter);
  runRegression(reporter);
  await runPlayground(reporter);
  await runRdfTools(reporter);
  runExamples(reporter);
  runBookExamples(reporter);
  reporter.totalLine();
  process.exit(0);
} catch (_) {
  process.exit(1);
}
