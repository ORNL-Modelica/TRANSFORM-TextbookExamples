# TRANSFORM-TextbookExamples

Worked examples from engineering textbooks, rebuilt as Modelica models with the
[TRANSFORM](https://github.com/ORNL-Modelica/TRANSFORM-Library) library. Each model
reproduces a textbook's worked example and carries the book's published answer as a
reference value, so the examples double as tests of TRANSFORM's components.

The library has one package per textbook. Within a package, models have descriptive
names; each model's documentation gives the book, edition, example number and page.

Models follow the conventions of the TRANSFORM library (`TRANSFORM.UsersGuide.Conventions`),
in particular its pages on examples, documentation and citing a source.

## Textbook-source policy

Models in this repository are independently written implementations using the TRANSFORM
Modelica library. They use numerical input data and published numerical answers from the
cited textbooks' worked examples. This repository does not reproduce textbook problem
statements, solution text, figures, tables or other text of the books; any documentation
or figure here is our own. Citations identify the source of the engineering problem and
do not imply sponsorship or endorsement by the textbook authors or publishers. We use a
selection of worked examples, not a book's complete set of problems or answers.

Books used so far:

| Package | Book | Source |
| --- | --- | --- |
| `Cleynen_EngineeringThermodynamics` | Olivier Cleynen, *Engineering Thermodynamics*, International edition with SI units (2025) | [thermodynamicsbook.com](https://thermodynamicsbook.com/) (free PDF, CC BY-SA 4.0) |

## Using it

Load TRANSFORM (version 1.3.0-dev or later), then `TRANSFORMTextbookExamples/package.mo`.
Every example has an experiment setup and simulates as it is, in Dymola and in
OpenModelica.

## Tests

The examples are tests: each has a `UnitTests` block whose `x_reference` values are the
book's answers. Regression baselines are kept with the
[Dynamic Systems Testing Framework](https://github.com/ORNL-Modelica/DynamicSystemsTestingFramework)
in `TRANSFORMTextbookExamples/Resources/ReferenceResults/`, which expects a TRANSFORM-Library
checkout next to this repository:

```bash
dstf --config TRANSFORMTextbookExamples/Resources/ReferenceResults/testing.json run
```

A model's result can differ slightly from the book's answer where the book reads values
from printed property tables and TRANSFORM computes them (for example, IAPWS-IF97 for
water); the model documentation says so where it matters.

## License

Apache License 2.0 (see `LICENSE` and `NOTICE`).
