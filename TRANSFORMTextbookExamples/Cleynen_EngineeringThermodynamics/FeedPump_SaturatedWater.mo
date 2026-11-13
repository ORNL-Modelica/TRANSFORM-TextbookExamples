within TRANSFORMTextbookExamples.Cleynen_EngineeringThermodynamics;
model FeedPump_SaturatedWater
  "Feed pump compressing saturated liquid water from 0.5 bar to 40 bar"
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.Water.StandardWater "Water (IAPWS-IF97)";
  parameter SI.Pressure p_in = 0.5e5 "Inlet pressure";
  parameter SI.Pressure p_out = 40e5 "Outlet pressure";
  parameter SI.MassFlowRate m_flow = 35 "Mass flow rate";
  parameter SI.SpecificEnthalpy h_in = Medium.bubbleEnthalpy(Medium.setSat_p(p_in))
    "Inlet enthalpy (saturated liquid at p_in)";

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
    m_flow_start=m_flow) "Flow set to m_flow; efficiency 1, so the compression is isentropic"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  // Book answers in the model's units and signs: W is the power given to the water,
  // positive like the book's +142.4 kW -> 142.4e3 W; h_A = 340.5 kJ/kg -> J/kg;
  // v_L = 0.00103 m3/kg compared as 1/density at the inlet.
  // Outlet enthalpy: the value given as the book's h_B, 482.9 kJ/kg, equals
  // 340.5 + 142.4, i.e. the power in kW added to an enthalpy in kJ/kg. The energy
  // balance with the book's own numbers gives h_B = h_A + W/m_flow
  // = 340.5e3 + 142.4e3/35 J/kg (344.57 kJ/kg), which is the reference used here.
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
<p>A feed pump takes 35 kg/s of saturated liquid water at 0.5 bar and raises it to 40 bar
with no losses. The model finds the pumping power and the outlet enthalpy.</p>
<p><code>Pump_Controlled</code> computes the ideal enthalpy rise as the pressure rise times
the specific volume at the inlet, the same incompressible-liquid estimate the book uses;
with an efficiency of 1 the power <code>pump.W</code> is that rise times the mass flow. W is
positive when the pump gives power to the water, the same sign as the book's answer.</p>
<p>Source: Olivier Cleynen, <i>Engineering Thermodynamics</i>, International edition with
SI units (2025), Example 9.1, p. 245,
<a href=\"https://thermodynamicsbook.com/\">https://thermodynamicsbook.com/</a>.</p>
<p>The book reads water properties from printed steam tables; this model uses IAPWS-IF97,
so the results differ slightly from the book's answers.</p>
</html>"));
end FeedPump_SaturatedWater;
