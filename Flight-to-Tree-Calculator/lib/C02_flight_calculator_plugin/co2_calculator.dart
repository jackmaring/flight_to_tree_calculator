import 'package:sustainibility_project/services/calculations.dart';

class _FlightParameters {
  _FlightParameters({
    this.a,
    this.b,
    this.c,
    this.s,
    this.plf,
    this.dc,
    this.invCF,
    this.economyCW,
    this.businessCW,
    this.firstCW,
    this.ef,
    this.p,
    this.m,
  });

  final double a; // polynomial coefficient
  final double b; // polynomial coefficient
  final double c; // polynomial coefficient
  final double s; // average seat number
  final double plf; // passenger load factor
  final double dc; // detour constant
  final double invCF; // 1 - cargo factor
  final double economyCW; // economy class weight
  final double businessCW; // business class weight
  final double firstCW; // first class weight
  final double ef; // emission factor
  final double p; // Pre production
  final double m; // multiplier

  static _FlightParameters shortHaulParams = _FlightParameters(
      a: 3.87871E-05,
      b: 2.9866,
      c: 1263.42,
      s: 158.44,
      plf: 0.77,
      dc: 50,
      invCF: 0.951,
      economyCW: 0.960,
      businessCW: 1.26,
      firstCW: 2.40,
      ef: 3.150,
      p: 0.51,
      m: 2);

  static _FlightParameters longHaulParams = _FlightParameters(
      a: 0.000134576,
      b: 6.1798,
      c: 3446.20,
      s: 280.39,
      plf: 0.77,
      dc: 125,
      invCF: 0.951,
      economyCW: 0.800,
      businessCW: 1.54,
      firstCW: 2.40,
      ef: 3.150,
      p: 0.51,
      m: 2);
}

double _flightClassWeight(
    {FlightClass flightClass, double economy, double business, double first}) {
  switch (flightClass) {
    case FlightClass.economy:
      return economy;
    case FlightClass.business:
      return business;
    case FlightClass.first:
      return first;
  }
  return economy;
}

class CO2Calculator {
  static double _normalize(
      {double value, double lowerBound, double upperBound}) {
    return (value - lowerBound) / (upperBound - lowerBound);
  }

  static double _interpolate({double a, double b, double value}) {
    return b * value + a * (1 - value);
  }

  static _FlightParameters flightParameters({double distanceKm}) {
    double lowerBound = 1500.0;
    double upperBound = 2500.0;
    if (distanceKm <= lowerBound) {
      return _FlightParameters.shortHaulParams;
    }
    if (distanceKm >= upperBound) {
      return _FlightParameters.longHaulParams;
    }
    double normalizedDistance = _normalize(
        value: distanceKm, lowerBound: lowerBound, upperBound: upperBound);

    final s = _FlightParameters.shortHaulParams;
    final l = _FlightParameters.longHaulParams;

    return _FlightParameters(
        a: _interpolate(a: s.a, b: l.a, value: normalizedDistance),
        b: _interpolate(a: s.b, b: l.b, value: normalizedDistance),
        c: _interpolate(a: s.c, b: l.c, value: normalizedDistance),
        s: _interpolate(a: s.s, b: l.s, value: normalizedDistance),
        plf: _interpolate(a: s.plf, b: l.plf, value: normalizedDistance),
        dc: _interpolate(a: s.dc, b: l.dc, value: normalizedDistance),
        invCF:
            _interpolate(a: s.invCF, b: l.invCF, value: normalizedDistance),
        economyCW: _interpolate(
            a: s.economyCW, b: l.economyCW, value: normalizedDistance),
        businessCW: _interpolate(
            a: s.businessCW, b: l.businessCW, value: normalizedDistance),
        firstCW:
            _interpolate(a: s.firstCW, b: l.firstCW, value: normalizedDistance),
        ef: _interpolate(a: s.ef, b: l.ef, value: normalizedDistance),
        p: _interpolate(a: s.p, b: l.p, value: normalizedDistance),
        m: _interpolate(a: s.m, b: l.m, value: normalizedDistance));
  }

  static double calculateCO2e(double distanceKm, FlightClass flightClass) {
    _FlightParameters fp = flightParameters(distanceKm: distanceKm);
    double x = distanceKm + fp.dc;
    double cw = _flightClassWeight(
      flightClass: flightClass,
      economy: fp.economyCW,
      business: fp.businessCW,
      first: fp.firstCW,
    );
    return (fp.a * x * x + fp.b * x + fp.c) /
        (fp.s * fp.plf) *
        fp.invCF *
        cw *
        (fp.ef * fp.m + fp.p);
  }

  static double correctedDistanceKm(double distanceKm) {
    final fp = flightParameters(distanceKm: distanceKm);
    return distanceKm + fp.dc;
  }
}
