within ;
package TRANSFORMTextbookExamples "Worked textbook examples rebuilt with TRANSFORM"
  import SI = Modelica.Units.SI;
  extends Modelica.Icons.ExamplesPackage;

  annotation (
    version="0.1.0-dev",
    uses(TRANSFORM(version="1.3.0-dev"), Modelica(version="4.0.0")),
    Documentation(info="<html>
<p>Worked examples from engineering textbooks, rebuilt as models with TRANSFORM. One
package per textbook. Each example carries the book's published answer as a reference
value and is a regression test of the TRANSFORM components it uses.</p>
<p>Only the numerical data and published answers of the cited examples are used; no
textbook text, figure or table is reproduced, and citations do not imply endorsement by
the authors or publishers.</p>
<p>Licensed under the Apache License, Version 2.0.</p>
</html>"));
end TRANSFORMTextbookExamples;
