// Shared test output helpers.
// The runners use this small reporter so individual suites and `npm test` share
// one compact Eyeling-style layout: colored OK/FAIL, sequence number, test description, and dimmed timing.
import process from 'node:process';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const useColor = process.env.NO_COLOR == null && (
  Boolean(process.stdout.isTTY) ||
  Boolean(process.env.FORCE_COLOR && process.env.FORCE_COLOR !== '0')
);

export const colors = {
  green: useColor ? '\x1b[32m' : '',
  red: useColor ? '\x1b[31m' : '',
  yellow: useColor ? '\x1b[33m' : '',
  dim: useColor ? '\x1b[2m' : '',
  reset: useColor ? '\x1b[0m' : '',
};

export class TestReporter {
  constructor({ stdout = process.stdout, stderr = process.stderr } = {}) {
    this.stdout = stdout;
    this.stderr = stderr;
    this.ok = 0;
    this.total = 0;
    this.startedAt = nowMs();
    this.sectionCount = 0;
    this.currentSection = null;
  }

  section(name) {
    const prefix = this.sectionCount === 0 ? '' : '\n';
    this.stdout.write(`${prefix}${colors.yellow}== ${name}${colors.reset}\n`);
    this.currentSection = {
      name,
      okAtStart: this.ok,
      totalAtStart: this.total,
      startedAt: nowMs(),
    };
    this.sectionCount++;
  }

  sectionTotal(label = null) {
    if (this.currentSection == null) return;

    const ok = this.ok - this.currentSection.okAtStart;
    const total = this.total - this.currentSection.totalAtStart;
    const ms = nowMs() - this.currentSection.startedAt;
    const suite = label ?? defaultSectionLabel(this.currentSection.name);
    this.stdout.write(`${colors.green}OK${colors.reset} ${ok}/${total} ${suite} tests passed ${colors.dim}(${ms} ms)${colors.reset}\n`);
  }

  test(name, run) {
    this.total++;
    const nr = String(this.total).padStart(3, '0');
    const startedAt = nowMs();

    try {
      run();
      const ms = nowMs() - startedAt;
      this.ok++;
      this.stdout.write(`${colors.green}OK${colors.reset} ${nr} ${name} ${colors.dim}(${ms} ms)${colors.reset}\n`);
    } catch (error) {
      const ms = nowMs() - startedAt;
      this.stderr.write(`${colors.red}FAIL${colors.reset} ${nr} ${name} ${colors.dim}(${ms} ms)${colors.reset}\n`);
      this.stderr.write(`${error?.stack ?? String(error)}\n`);
      throw error;
    }
  }

  async testAsync(name, run) {
    this.total++;
    const nr = String(this.total).padStart(3, '0');
    const startedAt = nowMs();

    try {
      await run();
      const ms = nowMs() - startedAt;
      this.ok++;
      this.stdout.write(`${colors.green}OK${colors.reset} ${nr} ${name} ${colors.dim}(${ms} ms)${colors.reset}\n`);
    } catch (error) {
      const ms = nowMs() - startedAt;
      this.stderr.write(`${colors.red}FAIL${colors.reset} ${nr} ${name} ${colors.dim}(${ms} ms)${colors.reset}\n`);
      this.stderr.write(`${error?.stack ?? String(error)}\n`);
      throw error;
    }
  }

  totalLine() {
    const ms = nowMs() - this.startedAt;
    this.stdout.write(`\n${colors.yellow}== Total${colors.reset}\n`);
    this.stdout.write(`${colors.green}OK${colors.reset} ${this.ok}/${this.total} tests passed ${colors.dim}(${ms} ms)${colors.reset}\n`);
  }
}

export function nowMs() {
  return Number(process.hrtime.bigint() / 1000000n);
}

export function isMainModule(metaUrl) {
  return process.argv[1] != null && path.resolve(process.argv[1]) === fileURLToPath(metaUrl);
}

function defaultSectionLabel(name) {
  return String(name)
    .replace(/^Conformance\s+/, 'conformance ')
    .replace(/^Examples$/, 'examples')
    .replace(/^Regression$/, 'regression')
    .replace(/^API$/, 'API')
    .replace(/^White-box$/, 'white-box');
}
