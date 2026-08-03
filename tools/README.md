# RDF round-trip tools

These tools translate RDF files into ordinary WebEntail and queried `rdf/4`
facts back into RDF 1.2 N-Quads. Input formats are selected automatically from
the file extension. Supported inputs include RDF 1.2 Turtle, TriG, N-Triples,
N-Quads and RDF/XML, plus JSON-LD, RDFa, Microdata, Notation3 and SHACL Compact
Syntax. WebEntail remains RDF-agnostic.

```bash
node tools/rdf-to-webentail.mjs --rules rules.pl data.nq -o program.pl
node bin/webentail.js --goal 'rdf(S, P, O, G)' program.pl > derived.pl
node tools/webentail-to-rdf.mjs derived.pl -o derived.nq
```

For standard input, specify an extension or media type with `--format`:

```bash
node tools/rdf-to-webentail.mjs --format turtle --base https://example/ -o program.pl
```

Use `--include-source` when the result should contain input and derived quads.
Without it, the pipeline emits only derived quads. The lossless encoding uses
`iri/1`, scoped `bnode/2`, `literal/2`, `triple/3`, and `default_graph`.
Language annotations use `lang/1`; directional language annotations use
`lang/2`, with `ltr` or `rtl` as the second argument.

Triple terms may be nested. The reader accepts the RDF 1.2 `VERSION "1.2"`
directive and directional language strings while remaining compatible with
RDF 1.1 N-Triples and N-Quads.
