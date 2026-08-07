#!/usr/bin/env node
// Static conformance corpus report.
// This complements the executable runner with a category summary that makes
// coverage growth visible without running every case.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)));
const packageRoot = path.resolve(root, '..');
const conformanceRoot = path.join(root, 'conformance');

const KINDS = [
  { kind: 'cases', expectedKind: 'expected', expectedExt: '.pl', column: 'positive' },
  { kind: 'errors', expectedKind: 'expected-errors', expectedExt: '.txt', column: 'errors' },
  { kind: 'warnings', expectedKind: 'expected-warnings', expectedExt: '.pl', column: 'warnings' },
  { kind: 'proofs', expectedKind: 'expected-proofs', expectedExt: '.pl', column: 'proofs' },
];

export function buildConformanceReport() {
  const categories = new Map();
  const issues = [];

  for (const { kind, expectedKind, expectedExt, column } of KINDS) {
    const base = path.join(conformanceRoot, kind);
    if (!fs.existsSync(base)) continue;
    for (const file of listEyePrologFiles(base)) {
      const category = categoryOf(file);
      const counts = ensureCategory(categories, category);
      counts[column]++;
      counts.total++;

      const stem = file.slice(0, -3);
      const expected = path.join(conformanceRoot, expectedKind, `${stem}${expectedExt}`);
      if (!fs.existsSync(expected)) issues.push(`missing ${expectedKind}/${stem}${expectedExt}`);
      if (kind === 'warnings') {
        const expectedStderr = path.join(conformanceRoot, expectedKind, `${stem}.txt`);
        if (!fs.existsSync(expectedStderr)) issues.push(`missing ${expectedKind}/${stem}.txt`);
      }
    }
  }

  const rows = [...categories.entries()]
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([category, counts]) => ({ category, ...counts }));
  const total = rows.reduce((acc, row) => ({
    positive: acc.positive + row.positive,
    errors: acc.errors + row.errors,
    warnings: acc.warnings + row.warnings,
    proofs: acc.proofs + row.proofs,
    total: acc.total + row.total,
  }), { positive: 0, errors: 0, warnings: 0, proofs: 0, total: 0 });

  return { rows, total, issues: issues.sort() };
}

export function formatConformanceReport(report = buildConformanceReport()) {
  const lines = [
    '# EyeProlog conformance report',
    '',
    'This report summarizes the file-based conformance corpus under `test/conformance/`.',
    '',
    '| Category | Positive | Errors | Warnings | Proofs | Total |',
    '|---|---:|---:|---:|---:|---:|',
  ];

  for (const row of report.rows) {
    lines.push(`| ${row.category} | ${row.positive} | ${row.errors} | ${row.warnings} | ${row.proofs} | ${row.total} |`);
  }
  lines.push(`| **Total** | **${report.total.positive}** | **${report.total.errors}** | **${report.total.warnings}** | **${report.total.proofs}** | **${report.total.total}** |`);

  if (report.issues.length > 0) {
    lines.push('', '## Corpus issues', '');
    for (const issue of report.issues) lines.push(`- ${issue}`);
  }

  return `${lines.join('\n')}\n`;
}

function listEyePrologFiles(base, dir = base) {
  const files = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...listEyePrologFiles(base, full));
    } else if (entry.isFile() && entry.name.endsWith('.pl')) {
      files.push(path.relative(base, full).split(path.sep).join('/'));
    }
  }
  return files.sort();
}

function categoryOf(file) {
  const parts = file.split('/');
  return parts.length > 1 ? parts[0] : 'legacy-numbered';
}

function ensureCategory(categories, category) {
  let counts = categories.get(category);
  if (!counts) {
    counts = { positive: 0, errors: 0, warnings: 0, proofs: 0, total: 0 };
    categories.set(category, counts);
  }
  return counts;
}

if (process.argv[1] != null && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const report = buildConformanceReport();
  const text = formatConformanceReport(report);
  const outputPath = process.argv[2] ?? null;
  if (outputPath == null) {
    process.stdout.write(text);
  } else {
    const resolved = path.resolve(packageRoot, outputPath);
    fs.mkdirSync(path.dirname(resolved), { recursive: true });
    fs.writeFileSync(resolved, text);
    process.stdout.write(`wrote ${path.relative(packageRoot, resolved)}\n`);
  }
  if (report.issues.length > 0) process.exit(1);
}
