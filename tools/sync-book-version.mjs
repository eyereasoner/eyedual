import { readFile, writeFile } from 'node:fs/promises';

const packageUrl = new URL('../package.json', import.meta.url);
const bookUrl = new URL('../the-art-of-eyepl.md', import.meta.url);

const packageJson = JSON.parse(await readFile(packageUrl, 'utf8'));
const version = packageJson.version;

if (typeof version !== 'string' || !/^\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?$/.test(version)) {
  throw new Error(`Invalid package version: ${JSON.stringify(version)}`);
}

const book = await readFile(bookUrl, 'utf8');
const versionLine = `**Applies to Eyepl:** \`${version}\``;
const versionPattern = /^\*\*Applies to Eyepl:\*\*.*$/m;
const authorPattern = /^(\*\*Author:\*\*.*)$/m;

let updated;

if (versionPattern.test(book)) {
  updated = book.replace(versionPattern, versionLine);
} else if (authorPattern.test(book)) {
  updated = book.replace(authorPattern, `$1\n\n${versionLine}`);
} else {
  throw new Error('Could not find the Author metadata in the book.');
}

if (updated !== book) {
  await writeFile(bookUrl, updated, 'utf8');
  console.log(`Updated book metadata for Eyepl ${version}.`);
} else {
  console.log(`Book metadata already matches Eyepl ${version}.`);
}
