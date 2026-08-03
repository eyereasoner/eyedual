dataGraph(association, skolem_g0).
why(
  dataGraph(association, skolem_g0),
  proof(
    goal(dataGraph(association, skolem_g0)),
    by(rule("context-association.pl", clause(8))),
    uses([
      proof(
        goal(context_statement(skolem_g0, bob, foaf_name, "Bob")),
        by(rule("context-association.pl", clause(7))),
        bindings([binding("Contextname", skolem_g0), binding("Subject", bob), binding("Predicate", foaf_name), binding("Object", "Bob"), binding("Context", foaf_name(bob, "Bob")), binding("Statement", foaf_name(bob, "Bob"))]),
        uses([
          proof(
            goal(log_nameOf(skolem_g0, foaf_name(bob, "Bob"))),
            by(fact("context-association.pl", clause(1)))
          ),
          proof(
            goal(context_member(foaf_name(bob, "Bob"), foaf_name(bob, "Bob"))),
            by(rule("context-association.pl", clause(6))),
            bindings([binding("Member", foaf_name(bob, "Bob"))]),
            uses([
              proof(
                goal(\=(foaf_name(bob, "Bob"), (_left, _right))),
                by(builtin(\=, 2))
              )
            ])
          ),
          proof(
            goal('=..'(foaf_name(bob, "Bob"), [foaf_name, bob, "Bob"])),
            by(builtin('=..', 2))
          )
        ])
      )
    ])
  )
).

signatureGraph(association, skolem_g1).
why(
  signatureGraph(association, skolem_g1),
  proof(
    goal(signatureGraph(association, skolem_g1)),
    by(rule("context-association.pl", clause(9))),
    uses([
      proof(
        goal(context_statement(skolem_g1, skolem_g0, sec_proof, dataSignature)),
        by(rule("context-association.pl", clause(7))),
        bindings([binding("Contextname", skolem_g1), binding("Subject", skolem_g0), binding("Predicate", sec_proof), binding("Object", dataSignature), binding("Context", (sec_proof(skolem_g0, dataSignature), type(signature1, sec_DataIntegrityProof), sec_cryptosuite(signature1, "ecdsa-proof-2019"), sec_created(signature1, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature1, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature1, "assertionMethod"), sec_proofValue(signature1, "z58DAdFfa9SkqZMVPxAQp...jQCrfFPP2oumHKtz"), sec_issuer(signature1, university), sec_validFrom(signature1, "2024-04-03T00:00:00.000Z"), sec_validUntil(signature1, "2025-04-03T00:00:00.000Z"))), binding("Statement", sec_proof(skolem_g0, dataSignature))]),
        uses([
          proof(
            goal(log_nameOf(skolem_g1, (sec_proof(skolem_g0, dataSignature), type(signature1, sec_DataIntegrityProof), sec_cryptosuite(signature1, "ecdsa-proof-2019"), sec_created(signature1, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature1, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature1, "assertionMethod"), sec_proofValue(signature1, "z58DAdFfa9SkqZMVPxAQp...jQCrfFPP2oumHKtz"), sec_issuer(signature1, university), sec_validFrom(signature1, "2024-04-03T00:00:00.000Z"), sec_validUntil(signature1, "2025-04-03T00:00:00.000Z")))),
            by(fact("context-association.pl", clause(2)))
          ),
          proof(
            goal(context_member((sec_proof(skolem_g0, dataSignature), type(signature1, sec_DataIntegrityProof), sec_cryptosuite(signature1, "ecdsa-proof-2019"), sec_created(signature1, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature1, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature1, "assertionMethod"), sec_proofValue(signature1, "z58DAdFfa9SkqZMVPxAQp...jQCrfFPP2oumHKtz"), sec_issuer(signature1, university), sec_validFrom(signature1, "2024-04-03T00:00:00.000Z"), sec_validUntil(signature1, "2025-04-03T00:00:00.000Z")), sec_proof(skolem_g0, dataSignature))),
            by(rule("context-association.pl", clause(4))),
            bindings([binding("Left", sec_proof(skolem_g0, dataSignature)), binding("_right", (type(signature1, sec_DataIntegrityProof), sec_cryptosuite(signature1, "ecdsa-proof-2019"), sec_created(signature1, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature1, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature1, "assertionMethod"), sec_proofValue(signature1, "z58DAdFfa9SkqZMVPxAQp...jQCrfFPP2oumHKtz"), sec_issuer(signature1, university), sec_validFrom(signature1, "2024-04-03T00:00:00.000Z"), sec_validUntil(signature1, "2025-04-03T00:00:00.000Z"))), binding("Member", sec_proof(skolem_g0, dataSignature))]),
            uses([
              proof(
                goal(context_member(sec_proof(skolem_g0, dataSignature), sec_proof(skolem_g0, dataSignature))),
                by(rule("context-association.pl", clause(6))),
                bindings([binding("Member", sec_proof(skolem_g0, dataSignature))]),
                uses([
                  proof(
                    goal(\=(sec_proof(skolem_g0, dataSignature), (_left, _right))),
                    by(builtin(\=, 2))
                  )
                ])
              )
            ])
          ),
          proof(
            goal('=..'(sec_proof(skolem_g0, dataSignature), [sec_proof, skolem_g0, dataSignature])),
            by(builtin('=..', 2))
          )
        ])
      )
    ])
  )
).

metadataGraph(association, g3).
why(
  metadataGraph(association, g3),
  proof(
    goal(metadataGraph(association, g3)),
    by(rule("context-association.pl", clause(10))),
    uses([
      proof(
        goal(context_statement(g3, skolem_g1, sec_proof, signature2)),
        by(rule("context-association.pl", clause(7))),
        bindings([binding("Contextname", g3), binding("Subject", skolem_g1), binding("Predicate", sec_proof), binding("Object", signature2), binding("Context", (sec_proof(skolem_g1, signature2), type(signature2, sec_DataIntegrityProof), sec_cryptosuite(signature2, "ecdsa-proof-2019"), sec_created(signature2, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature2, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature2, "assertionMethod"), sec_proofValue(signature2, "adad123efv434r5200...dqed2t44v43das"))), binding("Statement", sec_proof(skolem_g1, signature2))]),
        uses([
          proof(
            goal(log_nameOf(g3, (sec_proof(skolem_g1, signature2), type(signature2, sec_DataIntegrityProof), sec_cryptosuite(signature2, "ecdsa-proof-2019"), sec_created(signature2, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature2, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature2, "assertionMethod"), sec_proofValue(signature2, "adad123efv434r5200...dqed2t44v43das")))),
            by(fact("context-association.pl", clause(3)))
          ),
          proof(
            goal(context_member((sec_proof(skolem_g1, signature2), type(signature2, sec_DataIntegrityProof), sec_cryptosuite(signature2, "ecdsa-proof-2019"), sec_created(signature2, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature2, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature2, "assertionMethod"), sec_proofValue(signature2, "adad123efv434r5200...dqed2t44v43das")), sec_proof(skolem_g1, signature2))),
            by(rule("context-association.pl", clause(4))),
            bindings([binding("Left", sec_proof(skolem_g1, signature2)), binding("_right", (type(signature2, sec_DataIntegrityProof), sec_cryptosuite(signature2, "ecdsa-proof-2019"), sec_created(signature2, "2021-11-13T18:19:39Z"), sec_verificationMethod(signature2, "https://university.example/issuers/14#key-1"), sec_proofPurpose(signature2, "assertionMethod"), sec_proofValue(signature2, "adad123efv434r5200...dqed2t44v43das"))), binding("Member", sec_proof(skolem_g1, signature2))]),
            uses([
              proof(
                goal(context_member(sec_proof(skolem_g1, signature2), sec_proof(skolem_g1, signature2))),
                by(rule("context-association.pl", clause(6))),
                bindings([binding("Member", sec_proof(skolem_g1, signature2))]),
                uses([
                  proof(
                    goal(\=(sec_proof(skolem_g1, signature2), (_left, _right))),
                    by(builtin(\=, 2))
                  )
                ])
              )
            ])
          ),
          proof(
            goal('=..'(sec_proof(skolem_g1, signature2), [sec_proof, skolem_g1, signature2])),
            by(builtin('=..', 2))
          )
        ])
      )
    ])
  )
).

