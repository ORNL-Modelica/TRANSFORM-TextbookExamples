within TRANSFORMTextbookExamples.Cleynen_EngineeringThermodynamics;
model SteamTurbine_Isentropic
  "Reversible adiabatic steam turbine from 40 bar, 500 degC to 0.5 bar"
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.Water.StandardWater "Water (IAPWS-IF97)";
  parameter SI.Pressure p_in = 40e5 "Inlet pressure";
  parameter SI.Temperature T_in = 773.15 "Inlet temperature (500 degC)";
  parameter SI.Pressure p_out = 0.5e5 "Outlet pressure";
  parameter SI.MassFlowRate m_flow = 1 "Mass flow rate (1 kg/s, so power equals specific work)";

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
          eta_nominal=1),
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
  // Book answers converted to the model's units and signs: the book's work
  // w = -978.3 kJ/kg (negative = work leaving the steam) becomes Q_mech = +978.3e3 W
  // at 1 kg/s, because Q_mech is positive when the steam drives the shaft;
  // h_B = 2467.7 kJ/kg -> 2467.7e3 J/kg; dryness x_B = 0.923.
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(
    n=3,
    x={steamTurbine.Q_mech,steamTurbine.h_out,steamTurbine.x_th_out},
    x_reference={978.3e3,2467.7e3,0.923}) "Reference values are the book's answers"
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
<p>Steam at 40 bar and 500 &deg;C expands in a turbine with no losses and no heat
transfer (isentropic efficiency 1) down to 0.5 bar. The model finds the work per kilogram,
the exhaust enthalpy and the exhaust dryness fraction. The flow is 1 kg/s, so the
turbine power in watts equals the specific work in J/kg.</p>
<p>Sign convention: <code>steamTurbine.Q_mech</code> is positive when the steam does work on
the shaft. The book counts work leaving the fluid as negative, so its answer of
&minus;978.3 kJ/kg corresponds to Q_mech = +978.3 kW here.</p>
<p>Both boundaries fix pressure. The turbine's Stodola (ellipse law) nominal point is set
to the boundary pressures and to 1 kg/s, so the computed flow is the book's flow.</p>
<p>Source: Olivier Cleynen, <i>Engineering Thermodynamics</i>, International edition with
SI units (2025), Example 8.7, p. 223,
<a href=\"https://thermodynamicsbook.com/\">https://thermodynamicsbook.com/</a>.</p>
<p>The book reads water properties from printed steam tables; this model uses IAPWS-IF97,
so the results differ slightly from the book's answers.</p>
</html>"));
end SteamTurbine_Isentropic;
