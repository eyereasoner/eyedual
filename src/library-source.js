// Load the portable EyeProlog Prolog-library source from the package assets.
// eyeprolog-library.pl is the source of truth for all 48 portable public
// library predicates.
import { fs, isNode } from './platform.js';

const portableLibraryUrl = new URL('./eyeprolog-library.pl', import.meta.url);

async function loadSource(url, label) {
  if (isNode) return fs.readFileSync(url, 'utf8');
  const response = await fetch(url);
  if (!response.ok) throw new Error(`could not load ${label}: ${response.status}`);
  return response.text();
}

export const eyePrologPortableLibrarySource = await loadSource(
  portableLibraryUrl,
  'EyeProlog portable library',
);
