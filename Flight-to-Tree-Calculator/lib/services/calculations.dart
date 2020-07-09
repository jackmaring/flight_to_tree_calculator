import 'package:sustainibility_project/C02_flight_calculator_plugin/airport.dart';
import 'package:sustainibility_project/C02_flight_calculator_plugin/co2_calculator.dart';
import 'package:sustainibility_project/C02_flight_calculator_plugin/distance_calculator.dart';
import 'package:sustainibility_project/providers/admin.dart';
import 'package:sustainibility_project/providers/profile.dart';

enum FlightClass {
  economy,
  business,
  first,
}

class Calculations {
  // converts string to FlightClass type
  FlightClass stringToFlightClass(String flightClass) {
    if (flightClass == 'Economy') {
      return FlightClass.economy;
    } else if (flightClass == 'Business') {
      return FlightClass.business;
    } else {
      return FlightClass.first;
    }
  }

  // converts FlightClass to string
  String flightClassToString(FlightClass flightClass) {
    if (flightClass == FlightClass.economy) {
      return 'Economy';
    } else if (flightClass == FlightClass.business) {
      return 'Business';
    } else {
      return 'First';
    }
  }

  // calculates the distance between 2 airports
  double calculateDistance(Airport departure, Airport arrival) {
    double distance = DistanceCalculator.distanceInKmBetween(
        departure.location, arrival.location);
    return distance;
  }

  // calculates the distance in miles between 2 airports
  int calculateMiles(Airport departure, Airport arrival) {
    return (calculateDistance(departure, arrival) * 0.621371).round();
  }

  // calculates the tons of co2 emmitted from an airport using the distance and flight class of the passenger
  double calculateTonsCO2(double distance, FlightClass flightClass) {
    double tonsC02 = CO2Calculator.calculateCO2e(distance, flightClass) / 1000;
    return tonsC02;
  }

  // calculates the trees needed from tons of co2
  // going off the metric that it takes 4 trees per ton of CO2 per 100 years
  int calculateTrees(double tonsCo2) {
    return (tonsCo2 * 4).round();
  }

  // calculates the trees needed straight from using the airports and flight class
  int calculateAirportsToTrees(
      Airport departure, Airport arrival, FlightClass flightClass) {
    double distance = calculateDistance(departure, arrival);
    double tonsCo2 = calculateTonsCO2(distance, flightClass);
    return calculateTrees(tonsCo2);
  }

  // returns a list of profile entries that the user created and where isConco is true
  List<ProfileDataTableEntry> profileIsConcoUserFlights(
    List<ProfileDataTableEntry> profileEntries,
    String uid,
  ) {
    List<ProfileDataTableEntry> profileIsConcoUserFlights = profileEntries
        .where((entry) => entry.isConco == true && uid == entry.uid)
        .toList();
    return profileIsConcoUserFlights;
  }

  // returns a list of profile entries that the user created
  List<ProfileDataTableEntry> profileUserFlights(
    List<ProfileDataTableEntry> profileEntries,
    String uid,
  ) {
    List<ProfileDataTableEntry> profileUserFlights =
        profileEntries.where((entry) => uid == entry.uid).toList();
    return profileUserFlights;
  }

  // returns a list of profile entries where isConco is true
  List<ProfileDataTableEntry> profileIsConcoFlights(
      List<ProfileDataTableEntry> profileEntries) {
    List<ProfileDataTableEntry> profileIsConcoFlights =
        profileEntries.where((entry) => entry.isConco == true).toList();
    return profileIsConcoFlights;
  }

  // returns the distance calculated from a profile data entry
  double profileDataEntryDistance(ProfileDataTableEntry entry) {
    double distance = calculateDistance(
      entry.departure,
      entry.arrival,
    );
    return distance;
  }

  // returns the profile entry flight class type from a string
  FlightClass profileDataEntryFlightClass(ProfileDataTableEntry entry) {
    FlightClass flightClass = stringToFlightClass(
      entry.flightClass,
    );
    return flightClass;
  }

  // returns the distance calculated from an admin data entry
  double adminDataEntryDistance(AdminDataTableEntry entry) {
    double distance = calculateDistance(
      entry.departure,
      entry.arrival,
    );
    return distance;
  }

  // returns the admin entry flight class type from a string
  FlightClass adminDataEntryFlightClass(AdminDataTableEntry entry) {
    FlightClass flightClass = stringToFlightClass(
      entry.flightClass,
    );
    return flightClass;
  }
}
