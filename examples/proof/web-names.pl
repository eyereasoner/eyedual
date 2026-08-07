affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/idlab>').
why(
  affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/idlab>'),
  proof(
    goal(affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/idlab>')),
    by(rule("web-names.pl", clause(10))),
    bindings([binding("Person", '<https://data.ugent.be/id/josd>'), binding("Org", '<https://data.ugent.be/id/idlab>')]),
    uses([
      proof(
        goal(triple('<https://data.ugent.be/id/josd>', '<https://schema.org/affiliation>', '<https://data.ugent.be/id/idlab>')),
        by(fact("web-names.pl", clause(3)))
      )
    ])
  )
).

affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/ugent>').
why(
  affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/ugent>'),
  proof(
    goal(affiliated_with('<https://data.ugent.be/id/josd>', '<https://data.ugent.be/id/ugent>')),
    by(rule("web-names.pl", clause(11))),
    bindings([binding("Person", '<https://data.ugent.be/id/josd>'), binding("Org", '<https://data.ugent.be/id/ugent>'), binding("Unit", '<https://data.ugent.be/id/idlab>')]),
    uses([
      proof(
        goal(triple('<https://data.ugent.be/id/josd>', '<https://schema.org/affiliation>', '<https://data.ugent.be/id/idlab>')),
        by(fact("web-names.pl", clause(3)))
      ),
      proof(
        goal(parent_organization('<https://data.ugent.be/id/idlab>', '<https://data.ugent.be/id/ugent>')),
        by(rule("web-names.pl", clause(8))),
        bindings([binding("Unit", '<https://data.ugent.be/id/idlab>'), binding("Org", '<https://data.ugent.be/id/ugent>')]),
        uses([
          proof(
            goal(triple('<https://data.ugent.be/id/idlab>', '<https://schema.org/parentOrganization>', '<https://data.ugent.be/id/ugent>')),
            by(fact("web-names.pl", clause(4)))
          )
        ])
      )
    ])
  )
).

project_contact('<https://github.com/eyereasoner/eyeprolog>', '<https://data.ugent.be/id/josd>', "josderoo@gmail.com").
why(
  project_contact('<https://github.com/eyereasoner/eyeprolog>', '<https://data.ugent.be/id/josd>', "josderoo@gmail.com"),
  proof(
    goal(project_contact('<https://github.com/eyereasoner/eyeprolog>', '<https://data.ugent.be/id/josd>', "josderoo@gmail.com")),
    by(rule("web-names.pl", clause(12))),
    bindings([binding("Project", '<https://github.com/eyereasoner/eyeprolog>'), binding("Person", '<https://data.ugent.be/id/josd>'), binding("Email", "josderoo@gmail.com")]),
    uses([
      proof(
        goal(triple('<https://github.com/eyereasoner/eyeprolog>', '<https://schema.org/maintainer>', '<https://data.ugent.be/id/josd>')),
        by(fact("web-names.pl", clause(7)))
      ),
      proof(
        goal(triple('<https://data.ugent.be/id/josd>', '<https://schema.org/email>', "josderoo@gmail.com")),
        by(fact("web-names.pl", clause(2)))
      )
    ])
  )
).

