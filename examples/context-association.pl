% Context association adapted from Eyeling context-association.n3.
%
% This version keeps the original shape: each context is named with log_nameOf
% and its contents remain quoted formula data.  Nothing inside the three formulae
% is asserted globally unless a rule explicitly projects it.

% Output declarations: host-supplied goals select the relations written to this example's golden output.
%% goal: log_nameOf(X0, X1)

%% goal: dataGraph(X0, X1)

%% goal: signatureGraph(X0, X1)

%% goal: metadataGraph(X0, X1)


% Program structure: facts set up the scenario, and rules derive the queried conclusions.
log_nameOf(skolem_g0, foaf_name(bob, "Bob")).

log_nameOf(skolem_g1, (
  sec_proof(skolem_g0, dataSignature),
  type(signature1, sec_DataIntegrityProof),
  sec_cryptosuite(signature1, "ecdsa-proof-2019"),
  sec_created(signature1, "2021-11-13T18:19:39Z"),
  sec_verificationMethod(signature1, "https://university.example/issuers/14#key-1"),
  sec_proofPurpose(signature1, "assertionMethod"),
  sec_proofValue(signature1, "z58DAdFfa9SkqZMVPxAQp...jQCrfFPP2oumHKtz"),
  sec_issuer(signature1, university),
  sec_validFrom(signature1, "2024-04-03T00:00:00.000Z"),
  sec_validUntil(signature1, "2025-04-03T00:00:00.000Z")
)).

log_nameOf(g3, (
  sec_proof(skolem_g1, signature2),
  type(signature2, sec_DataIntegrityProof),
  sec_cryptosuite(signature2, "ecdsa-proof-2019"),
  sec_created(signature2, "2021-11-13T18:19:39Z"),
  sec_verificationMethod(signature2, "https://university.example/issuers/14#key-1"),
  sec_proofPurpose(signature2, "assertionMethod"),
  sec_proofValue(signature2, "adad123efv434r5200...dqed2t44v43das")
)).

% A tiny projection shows how a program can inspect a quoted context without
% making the entire context globally true.
context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).

% Derivation rules: each rule below contributes one logical step toward the displayed results.
context_statement(Contextname, Subject, Predicate, Object) :-
  log_nameOf(Contextname, Context),
  context_member(Context, Statement),
  (Statement =.. [Predicate, Subject, Object]).

dataGraph(association, skolem_g0) :-
  context_statement(skolem_g0, bob, foaf_name, "Bob").

signatureGraph(association, skolem_g1) :-
  context_statement(skolem_g1, skolem_g0, sec_proof, dataSignature).

metadataGraph(association, g3) :-
  context_statement(g3, skolem_g1, sec_proof, signature2).
