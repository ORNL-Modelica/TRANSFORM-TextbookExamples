within TRANSFORMTextbookExamples.Cleynen_EngineeringThermodynamics;
model SteamTurbine_Efficiency85
  "Steam turbine with 85 % isentropic efficiency, 40 bar and 600 degC to 0.5 bar"
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.Water.StandardWater "Water (IAPWS-IF97)";
  parameter SI.Pressure p_in = 40e5 "Inlet pressure";
  parameter SI.Temperature T_in = 873.15 "Inlet temperature (600 degC)";
  parameter SI.Pressure p_out = 0.5e5 "Outlet pressure";
  parameter SI.MassFlowRate m_flow = 35 "Mass flow rate";
  parameter SI.Efficiency eta_is = 0.85 "Isentropic efficiency";

  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT source(
    redeclare package Medium = Medium,
    p=p_in,
    T=T_in,
    nPorts=1) "Steam inlet"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT sink(
    redeclare package Medium = Medium,
    p=p_out,
    T=Medium.saturationTemperature(p_out),
    nPorts=1) "Turbine exhaust"
    annotation (Placement(transformation(extent={{60,10},{40,30}})));
  TRANSFORM.Fluid.Machines.SteamTurbine steamTurbine(
    redeclare package Medium = Medium,
    redeclare model Eta_wetSteam =
        TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency.eta_Constant (
          eta_nominal=eta_is),
    p_a_start=p_in,
    p_b_start=p_out,
    T_a_start=T_in,
    m_flow_start=m_flow,
    phi(start=0, fixed=true)) "Stodola nominal point = boundary pressures and flow; shaft angle fixed at 0 (no physical role here)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(w_fixed=
        2*Modelica.Constants.pi*50) "Shaft held at 3000 rpm"
    annotation (Placement(transformation(extent={{40,-30},{20,-10}})));
  inner TRANSFORM.Fluid.System system
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  // Book answers converted to the model's units and signs: the book's power
  // -32.98 MW (negative = work leaving the steam) becomes Q_mech = +32.98e6 W,
  // because Q_mech is positive when the steam drives the shaft;
  // h_B = 2732.6 kJ/kg, h_B' = 2566.3 kJ/kg, h_A = 3674.9 kJ/kg -> J/kg.
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(
    n=4,
    x={steamTurbine.Q_mech,steamTurbine.h_out,steamTurbine.h_is,steamTurbine.h_in},
    x_reference={32.98e6,2732.6e3,2566.3e3,3674.9e3})
    "Reference values are the book's answers"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(source.ports[1], steamTurbine.portHP) annotation (Line(points={{-40,20},
          {-20,20},{-20,6},{-10,6}}, color={0,127,255}));
  connect(steamTurbine.portLP, sink.ports[1]) annotation (Line(points={{10,6},{20,
          6},{20,20},{40,20}}, color={0,127,255}));
  connect(steamTurbine.shaft_b, constantSpeed.flange) annotation (Line(points={{10,0},
          {14,0},{14,-20},{20,-20}}, color={0,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1),
    Documentation(info="<html>
<p>A turbine expands 35 kg/s of steam from 40 bar and 600 &deg;C to 0.5 bar with an
isentropic efficiency of 85 %. The model finds the ideal (isentropic) exhaust enthalpy,
the actual exhaust enthalpy and the power delivered to the shaft.</p>
<p>Sign convention: <code>steamTurbine.Q_mech</code> is positive when the steam does work on
the shaft. The book counts work leaving the fluid as negative, so its answer of
&minus;32.98 MW corresponds to Q_mech = +32.98 MW here.</p>
<p>Both boundaries fix pressure. The turbine's Stodola (ellipse law) nominal point is set
to the boundary pressures and to 35 kg/s, so the computed flow is the book's flow.</p>
<p>Source: Olivier Cleynen, <i>Engineering Thermodynamics</i>, International edition with
SI units (2025), Example 9.2, p. 249,
<a href=\"https://thermodynamicsbook.com/\">https://thermodynamicsbook.com/</a>.</p>
<p>The book reads water properties from printed steam tables; this model uses IAPWS-IF97,
so the results differ slightly from the book's answers.</p>
</html>"));
end SteamTurbine_Efficiency85;
