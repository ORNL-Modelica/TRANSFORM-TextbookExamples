within TRANSFORMTextbookExamples.Cleynen_EngineeringThermodynamics;
model FeedPump_SaturatedWater
  "Feed pump raising saturated liquid water to boiler pressure"
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.Water.StandardWater "Water (IAPWS-IF97)";
  parameter SI.Pressure p_in = 0.5e5 "Inlet pressure";
  parameter SI.Pressure p_out = 40e5 "Outlet pressure";
  parameter SI.MassFlowRate m_flow = 35 "Mass flow rate";
  parameter SI.SpecificEnthalpy h_in = Medium.bubbleEnthalpy(Medium.setSat_p(p_in))
    "Saturated liquid enthalpy at the inlet";

  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph source(
    redeclare package Medium = Medium,
    p=p_in,
    h=h_in,
    nPorts=1) "Saturated liquid from the condenser"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_ph sink(
    redeclare package Medium = Medium,
    p=p_out,
    h=h_in,
    nPorts=1) "Boiler inlet"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  TRANSFORM.Fluid.Machines.Pump_Controlled pump(
    redeclare package Medium = Medium,
    controlType="m_flow",
    redeclare model EfficiencyChar =
        TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Efficiency.Constant
        (eta_constant=1),
    p_a_start=p_in,
    p_b_start=p_out,
    use_T_start=false,
    h_a_start=h_in,
    m_flow_start=m_flow) "Lossless pump holding the given flow"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  // The book's values in SI units. The second entry is not the book's printed outlet
  // enthalpy, which has an error, but the energy balance with the book's own numbers
  // (see the documentation, "Differences from the reference").
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(
    n=4,
    x={pump.W,pump.port_b.h_outflow,pump.state_a.h,1/pump.d_inlet},
    x_reference={142.4e3,340.5e3 + 142.4e3/35,340.5e3,0.00103})
    "Reference values are the book's answers"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(source.ports[1], pump.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(pump.port_b, sink.ports[1])
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1),
    Documentation(info="<html>
<p>Finds the power and the outlet enthalpy of a feed pump with no losses, using
<code>Pump_Controlled</code>.</p>
<h4>Reference case</h4>
<p>Example 9.1, p. 245 of [Cleynen2025]: a pump takes 35 kg/s of saturated liquid water at
0.5 bar and raises it to 40 bar with no losses.</p>
<p>The book estimates the work as the pressure rise times the specific volume at the inlet,
and so does <code>Pump_Controlled</code>.</p>
<h4>Expected results</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>#</th><th>Quantity</th><th>In the model</th></tr>
<tr><td>1</td><td>Pump power</td><td><code>pump.W</code></td></tr>
<tr><td>2</td><td>Outlet enthalpy</td><td><code>pump.port_b.h_outflow</code></td></tr>
<tr><td>3</td><td>Inlet enthalpy</td><td><code>pump.state_a.h</code></td></tr>
<tr><td>4</td><td>Specific volume at the inlet</td><td><code>1/pump.d_inlet</code></td></tr>
</table>
<p>The book's values are the entries of <code>unitTests.x_reference</code>, in this order.
<code>pump.W</code> is positive when the pump gives power to the water, as in the book.</p>
<h4>Differences from the reference</h4>
<p>The book prints the outlet enthalpy as 482.9 kJ/kg. That value adds the power in kW
(142.4) to the inlet enthalpy in kJ/kg (340.5) without dividing by the flow of 35 kg/s. The
energy balance with the book's own numbers gives 344.57 kJ/kg, which is the second
reference value here.</p>
<p>The book reads water properties from printed steam tables. The model uses IAPWS-IF97.</p>
<h4>References</h4>
<p>[Cleynen2025] Cleynen, O. <i>Engineering Thermodynamics</i>, International edition with
SI units. 2025. <a href=\"https://thermodynamicsbook.com/\">https://thermodynamicsbook.com/</a></p>
</html>"));
end FeedPump_SaturatedWater;
