within TRANSFORMTextbookExamples.Cleynen_EngineeringThermodynamics;
model SteamTurbine_Isentropic
  "Steam turbine with no losses and no heat transfer"
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.Water.StandardWater "Water (IAPWS-IF97)";
  parameter SI.Pressure p_in = 40e5 "Inlet pressure";
  parameter SI.Temperature T_in(displayUnit="degC") = 773.15 "Inlet temperature";
  parameter SI.Pressure p_out = 0.5e5 "Outlet pressure";
  // 1 kg/s, so that the power in W equals the specific work in J/kg
  parameter SI.MassFlowRate m_flow = 1 "Mass flow rate";

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
  // phi is fixed only because the shaft angle needs a start value
  TRANSFORM.Fluid.Machines.SteamTurbine steamTurbine(
    redeclare package Medium = Medium,
    redeclare model Eta_wetSteam =
        TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency.eta_Constant (
          eta_nominal=1),
    p_a_start=p_in,
    p_b_start=p_out,
    T_a_start=T_in,
    m_flow_start=m_flow,
    phi(start=0, fixed=true)) "Turbine sized to pass m_flow at these pressures"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(w_fixed=
        2*Modelica.Constants.pi*50) "Shaft held at 3000 rpm"
    annotation (Placement(transformation(extent={{40,-30},{20,-10}})));
  inner TRANSFORM.Fluid.System system
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  // The book's values in SI units. Its work is negative (work leaving the steam);
  // Q_mech is positive when the steam drives the shaft, so the sign is turned.
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
<p>Finds the specific work, the exhaust enthalpy and the exhaust dryness fraction of a steam
turbine with no losses and no heat transfer, using <code>SteamTurbine</code>.</p>
<h4>Reference case</h4>
<p>Example 8.7, p. 223 of [Cleynen2025]: steam at 40 bar and 500 &deg;C expands to 0.5 bar in a
reversible adiabatic turbine.</p>
<p>The book works per kilogram. The model runs 1 kg/s, so its power in watts equals the
specific work in J/kg. Both boundaries fix pressure, and the turbine is sized so that its
flow at these pressures is 1 kg/s.</p>
<h4>Expected results</h4>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<tr><th>#</th><th>Quantity</th><th>In the model</th></tr>
<tr><td>1</td><td>Specific work</td><td><code>steamTurbine.Q_mech</code></td></tr>
<tr><td>2</td><td>Exhaust enthalpy</td><td><code>steamTurbine.h_out</code></td></tr>
<tr><td>3</td><td>Exhaust dryness fraction</td><td><code>steamTurbine.x_th_out</code></td></tr>
</table>
<p>The book's values are the entries of <code>unitTests.x_reference</code>, in this order.
The book counts work leaving the steam as negative; <code>steamTurbine.Q_mech</code> is positive when the
steam drives the shaft.</p>
<h4>Differences from the reference</h4>
<p>The book reads water properties from printed steam tables. The model uses IAPWS-IF97.</p>
<h4>References</h4>
<p>[Cleynen2025] Cleynen, O. <i>Engineering Thermodynamics</i>, International edition with
SI units. 2025. <a href=\"https://thermodynamicsbook.com/\">https://thermodynamicsbook.com/</a></p>
</html>"));
end SteamTurbine_Isentropic;
