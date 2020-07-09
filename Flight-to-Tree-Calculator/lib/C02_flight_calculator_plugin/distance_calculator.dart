import 'dart:math';

import 'package:sustainibility_project/C02_flight_calculator_plugin/airport.dart';

class DistanceCalculator {

  // distance in meters to another location
  // http://stackoverflow.com/questions/12966638/how-to-calculate-the-distance-between-two-gps-coordinates-without-using-google-m
  static double distanceInMetersBetween(LocationCoordinate2D lhs, LocationCoordinate2D rhs) {

    double radPerDeg = pi / 180.0;  // PI / 180
    double rkm = 6371.0;// Earth radius in kilometers
    double rm = rkm * 1000.0;// Radius in meters

    double dLatRad = (rhs.latitude - lhs.latitude) * radPerDeg; // Delta, converted to rad
    double dLonRad = (rhs.longitude - lhs.longitude) * radPerDeg;

    double lat1Rad = lhs.latitude * radPerDeg;
    double lat2Rad = rhs.latitude * radPerDeg;

    double sinDlat = sin(dLatRad/2);
    double sinDlon = sin(dLonRad/2);

    double a = sinDlat * sinDlat + cos(lat1Rad) * cos(lat2Rad) * sinDlon * sinDlon;
    double c = 2.0 * atan2(sqrt(a), sqrt(1-a));
    return rm * c;
  }

  static double distanceInKmBetween(LocationCoordinate2D lhs, LocationCoordinate2D rhs) {
    return distanceInMetersBetween(lhs, rhs) / 1000.0;
  }
}