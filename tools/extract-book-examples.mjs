#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const bookPath = path.join(root, 'the-art-of-webentail.md');
const outputRoot = path.join(root, 'examples', 'book');
const checkOnly = process.argv.includes('--check');
const book = fs.readFileSync(bookPath, 'utf8');

const chapters = [];
let chapter;
let cursor = 0;

for (const match of book.matchAll(/^(## \d+\. ([^\n]+)|# ([^\n]+)|```webentail\n([\s\S]*?)```)/gm)) {
  const preceding = book.slice(cursor, match.index);
  cursor = match.index + match[0].length;

  if (match[2]) {
    chapter = {
      number: Number(match[1].match(/\d+/)[0]),
      title: match[2].trim(),
      examples: [],
    };
    chapters.push(chapter);
    continue;
  }

  if (match[3]) {
    chapter = undefined;
    continue;
  }

  if (!chapter) continue;
  const source = match[4].trim();
  if (!source.endsWith('.')) continue;

  const firstClause = source
    .split('\n')
    .map((line) => line.trim())
    .find((line) => line && !line.startsWith('%'));
  const predicate = firstClause?.match(/^([a-z][a-z0-9_]*)\s*(?:\(|\.)/)?.[1] ?? 'program';
  const section = [...preceding.matchAll(/^### ([^\n]+)$/gm)].at(-1)?.[1] ?? '';
  chapter.examples.push({ predicate, section, source });
}

const files = new Map();
const readme = [
  '# The Art of WebEntail — inline examples',
  '',
  'These files are generated from the complete `webentail` code blocks in',
  '[The Art of WebEntail](../../the-art-of-webentail.md). They are grouped by chapter and',
  'retain the source text from the book. Goal fragments and non-WebEntail blocks are',
  'not extracted.',
  '',
  'Regenerate them from the repository root with:',
  '',
  '```sh',
  'npm run generate',
  '```',
  '',
];

let total = 0;
for (const item of chapters) {
  if (item.examples.length === 0) continue;
  const chapterName = `chapter-${String(item.number).padStart(2, '0')}`;
  readme.push(`## Chapter ${item.number}: ${item.title}`, '');
  const names = new Map();

  for (const [index, example] of item.examples.entries()) {
    const count = (names.get(example.predicate) ?? 0) + 1;
    names.set(example.predicate, count);
    const suffix = count === 1 ? '' : `-${count}`;
    const filename = `${String(index + 1).padStart(2, '0')}-${example.predicate}${suffix}.pl`;
    const relative = path.join(chapterName, filename);
    const heading = example.section ? ` — ${example.section}` : '';
    files.set(
      relative,
      `% From The Art of WebEntail, Chapter ${item.number}${heading}.\n${example.source}\n`,
    );
    readme.push(`- [${filename}](${relative})${heading}`);
    total += 1;
  }
  readme.push('');
}

files.set('README.md', `${readme.join('\n').trimEnd()}\n`);

if (checkOnly) {
  const actual = listFiles(outputRoot);
  const expected = [...files.keys()].sort();
  const failures = [];
  for (const relative of expected) {
    const target = path.join(outputRoot, relative);
    if (!fs.existsSync(target)) failures.push(`Missing ${relative}`);
    else if (fs.readFileSync(target, 'utf8') !== files.get(relative)) {
      failures.push(`Out of date ${relative}`);
    }
  }
  for (const relative of actual) {
    if (!files.has(relative)) failures.push(`Unexpected ${relative}`);
  }
  if (failures.length) {
    process.stderr.write(`${failures.join('\n')}\n`);
    process.exitCode = 1;
  } else {
    process.stdout.write(`${total} extracted book examples are up to date.\n`);
  }
} else {
  fs.rmSync(outputRoot, { recursive: true, force: true });
  for (const [relative, content] of files) {
    const target = path.join(outputRoot, relative);
    fs.mkdirSync(path.dirname(target), { recursive: true });
    fs.writeFileSync(target, content);
  }
  process.stdout.write(`Extracted ${total} book examples to examples/book/.\n`);
}

function listFiles(directory, base = directory) {
  if (!fs.existsSync(directory)) return [];
  return fs.readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const target = path.join(directory, entry.name);
    return entry.isDirectory()
      ? listFiles(target, base)
      : [path.relative(base, target)];
  }).sort();
}
