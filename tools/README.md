# RDF round-trip tools

These tools translate RDF files into ordinary EyeProlog and queried `rdf/4`
facts back into RDF 1.2 N-Quads. Input formats are selected automatically from
the file extension. Supported inputs include RDF 1.2 Turtle, TriG, N-Triples,
N-Quads and RDF/XML, plus JSON-LD, RDFa, Microdata, Notation3 and SHACL Compact
Syntax. EyeProlog remains RDF-agnostic.

```bash
node tools/rdf-to-pl.mjs --rules rules.pl data.nq -o program.pl
node bin/eyeprolog.js --goal 'rdf(S, P, O, G)' program.pl > derived.pl
node tools/pl-to-rdf.mjs derived.pl -o derived.nq
```

For standard input, specify an extension or media type with `--format`:

```bash
node tools/rdf-to-pl.mjs --format turtle --base https://example/ -o program.pl
```

Use `--include-source` when the result should contain input and derived quads.
Without it, the pipeline emits only derived quads. The lossless encoding uses
`iri/1`, scoped `bnode/2`, `literal/2`, `triple/3`, and `default_graph`.
Language annotations use `lang/1`; directional language annotations use
`lang/2`, with `ltr` or `rtl` as the second argument.

Triple terms may be nested. Turtle annotations are expanded into the asserted
base triple, an `rdf:reifies` triple containing a `triple/3` term, and ordinary
annotation triples about the reifier. The reader accepts the RDF 1.2 `VERSION
"1.2"` directive and directional language strings while remaining compatible
with RDF 1.1 N-Triples and N-Quads.
