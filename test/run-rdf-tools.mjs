#!/usr/bin/env node
import fs from 'node:fs/promises';
import { compileRdfDocumentToEyeDual, compileRdfToEyeDual } from '../tools/rdf-to-eyedual.mjs';
import { extractEyeDualRdf } from '../tools/eyedual-to-rdf.mjs';
import { run } from '../src/index.js';
import { TestReporter, isMainModule } from './test-style.mjs';

export async function runRdfTools(reporter = new TestReporter()) {
  reporter.section('RDF tools');
  reporter.test('N-Quads survives an include-source round trip', () => {
    const input = '<https://example/s> <https://example/p> "chat"@fr <https://example/g> .\n_:a <https://example/value> "42"^^<http://www.w3.org/2001/XMLSchema#integer> .\n';
    const output = run(compileRdfToEyeDual(input, { scope: 'doc', includeSource: true }), { goal: 'rdf(S, P, O, G)' }).stdout;
    equal(extractEyeDualRdf(output), '<https://example/s> <https://example/p> "chat"@fr <https://example/g> .\n_:e646f63_61 <https://example/value> "42"^^<http://www.w3.org/2001/XMLSchema#integer> .\n');
  });
  reporter.test('default mode emits only rule-derived quads', () => {
    const input = '<https://example/s> <https://example/parent> <https://example/o> .\n';
    const rules = 'rdf(S, iri("https://example/ancestor"), O, G) :- rdf(S, iri("https://example/parent"), O, G).';
    const output = run(compileRdfToEyeDual(input, { rules }), { goal: 'rdf(S, P, O, G)' }).stdout;
    equal(extractEyeDualRdf(output), '<https://example/s> <https://example/ancestor> <https://example/o> .\n');
  });
  reporter.test('RDF 1.2 terms survive an include-source round trip', () => {
    const input = 'VERSION "1.2"\n<https://example/s> <https://example/says> <<( _:a <https://example/text> "مرحبا"@ar--rtl )>> .\n';
    const output = run(compileRdfToEyeDual(input, { scope: 'doc', includeSource: true }), { goal: 'rdf(S, P, O, G)' }).stdout;
    equal(extractEyeDualRdf(output), '<https://example/s> <https://example/says> <<( _:e646f63_61 <https://example/text> "مرحبا"@ar--rtl )>> .\n');
  });
  reporter.test('nested RDF 1.2 triple terms survive a round trip', () => {
    const input = '<https://example/s> <https://example/p> <<( <https://example/a> <https://example/b> <<( _:x <https://example/c> "line\\nfeed" )>> )>> .\n';
    const output = run(compileRdfToEyeDual(input, { scope: 'doc', includeSource: true }), { goal: 'rdf(S, P, O, G)' }).stdout;
    equal(extractEyeDualRdf(output), '<https://example/s> <https://example/p> <<( <https://example/a> <https://example/b> <<( _:e646f63_78 <https://example/c> "line\\nfeed" )>> )>> .\n');
  });
  reporter.test('RDF blank-node labels accept the full Unicode production', () => {
    const input = '_:éclair <https://example/p> _:名.\n';
    const output = run(compileRdfToEyeDual(input, { scope: 'doc', includeSource: true }), { goal: 'rdf(S, P, O, G)' }).stdout;
    equal(extractEyeDualRdf(output), '_:e646f63_c3a9636c616972 <https://example/p> _:e646f63_e5908d .\n');
  });
  const odrlFixtures = [
    ['ODRL Turtle policy example', 'odrl-policy-from-turtle', 'odrl-policy'],
    ['advanced ODRL Turtle policy example', 'odrl-policy-advanced-from-turtle', 'odrl-policy-advanced'],
    ['ODRL-DPV-FPV trust-flow example', 'odrl-dpv-fpv-trust-flow', 'odrl-dpv-fpv-trust-flow'],
    ['healthcare ODRL-DPV risk example', 'odrl-dpv-healthcare-risk-ranked', 'odrl-dpv-healthcare-risk-ranked'],
    ['consumer ODRL-DPV risk example', 'odrl-dpv-risk-ranked', 'odrl-dpv-risk-ranked'],
    ['DPV-ODRL purpose mapping example', 'dpv-odrl-purpose-mapping', 'dpv-odrl-purpose-mapping'],
  ];
  for (const [label, programStem, inputStem] of odrlFixtures) {
    const source = await fs.readFile(new URL(`../examples/input/${inputStem}.ttl`, import.meta.url), 'utf8');
    const rules = await fs.readFile(new URL(`../examples/input/${inputStem}-rules.pl`, import.meta.url), 'utf8');
    const generated = await compileRdfDocumentToEyeDual(source, {
      inputPath: `${inputStem}.ttl`,
      scope: `${inputStem}.ttl`,
      rules,
    });
    const committed = await fs.readFile(new URL(`../examples/${programStem}.pl`, import.meta.url), 'utf8');
    reporter.test(`${label} is generated from its input fixture`, () => {
      equal(generated, committed);
    });
  }
  const documents = [
    ['Turtle 1.2', 'example.ttl', '@prefix ex: <https://example/>. ex:s ex:p <<( ex:a ex:b "hello"@en--ltr )>>.'],
    ['TriG 1.2', 'example.trig', '@prefix ex: <https://example/>. ex:g { ex:s ex:p ex:o }'],
    ['JSON-LD', 'example.jsonld', JSON.stringify({ '@context': { ex: 'https://example/' }, '@id': 'ex:s', 'ex:p': { '@id': 'ex:o' } })],
    ['RDF/XML 1.2', 'example.rdf', '<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:ex="https://example/"><rdf:Description rdf:about="https://example/s"><ex:p rdf:resource="https://example/o"/></rdf:Description></rdf:RDF>'],
    ['RDFa', 'example.html', '<div prefix="ex: https://example/" about="ex:s"><a property="ex:p" href="https://example/o">o</a></div>'],
  ];
  for (const [name, inputPath, source] of documents) {
    const program = await compileRdfDocumentToEyeDual(source, { inputPath, includeSource: true, scope: inputPath, baseIRI: 'https://example/base' });
    const output = extractEyeDualRdf(run(program, { goal: 'rdf(S, P, O, G)' }).stdout);
    reporter.test(`${name} input is accepted`, () => { if (!output) throw new Error('expected at least one RDF quad'); });
  }
  reporter.sectionTotal('RDF tool');
}
function equal(a, e) { if (a !== e) throw new Error(`expected ${JSON.stringify(e)}\nactual   ${JSON.stringify(a)}`); }
if (isMainModule(import.meta.url)) { const r = new TestReporter(); try { await runRdfTools(r); r.totalLine(); } catch (_) { process.exit(1); } }
