import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:sustainibility_project/C02_flight_calculator_plugin/airport.dart';
import 'package:sustainibility_project/C02_flight_calculator_plugin/airport_lookup.dart';
import 'package:sustainibility_project/C02_flight_calculator_plugin/airport_search_delegate.dart';
import 'package:sustainibility_project/providers/flight_to_trees.dart';
import 'package:sustainibility_project/providers/profile.dart';
import 'package:sustainibility_project/services/calculations.dart';

class AdminDataTableEntry {
  String id;
  String name;
  String jobTitle;
  Airport departure;
  Airport arrival;
  String flightClass;
  Timestamp dateCreated;

  AdminDataTableEntry({
    this.id,
    this.name,
    this.jobTitle,
    this.departure,
    this.arrival,
    this.flightClass,
    this.dateCreated,
  });

  AdminDataTableEntry.fromMap(Map<String, dynamic> data)
      : this(
          id: data['id'],
          name: data['name'],
          jobTitle: data['jobTitle'],
          departure: Airport.fromMap(data['departure']),
          arrival: Airport.fromMap(data['arrival']),
          flightClass: data['flightClass'],
          dateCreated: data['dateCreated'],
        );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': this.name,
        'jobTitle': this.jobTitle,
        'departure': {
          'name': this.departure.name,
          'city': this.departure.city,
          'country': this.departure.country,
          'iata': this.departure.iata,
          'location': {
            'lat': this.departure.location.latitude,
            'lon': this.departure.location.longitude,
          }
        },
        'arrival': {
          'name': this.arrival.name,
          'city': this.arrival.city,
          'country': this.arrival.country,
          'iata': this.arrival.iata,
          'location': {
            'lat': this.arrival.location.latitude,
            'lon': this.arrival.location.longitude,
          }
        },
        'flightClass': this.flightClass,
        'dateCreated': this.dateCreated,
      };
}

class Admin with ChangeNotifier {
  Airport _departure;
  Airport _arrival;
  String _flightClass = 'Economy';
  String _numOfYears = '15';
  bool _adminOnly = true;
  bool _studentTableIsVisible = false;
  bool _concoDeleteisVisible = false;
  bool _studentDeleteisVisible = false;

  double _totalMiles = 0;
  double _totalCo2 = 0;
  int _totalTrees = 0;
  int _totalFlights = 0;
  double _multiplier = 1;

  Airport get departure => _departure;
  Airport get arrival => _arrival;
  String get flightClass => _flightClass;
  String get numOfYears => _numOfYears;
  bool get adminOnly => _adminOnly;
  bool get studentTableIsVisible => _studentTableIsVisible;
  bool get concoDeleteisVisible => _concoDeleteisVisible;
  bool get studentDeleteisVisible => _studentDeleteisVisible;

  double get totalMiles => _totalMiles;
  double get totalCo2 => _totalCo2;
  int get totalTrees => _totalTrees;
  int get totalFlights => _totalFlights;
  double get multiplier => _multiplier;

  void updateAdminFlightClass(String newValue) {
    _flightClass = newValue;
    notifyListeners();
  }

  void updateAdminNumOfYears(String newValue) {
    _numOfYears = newValue;
    notifyListeners();
  }

  void makeAdminOnlyTrue() {
    _adminOnly = true;
    notifyListeners();
  }

  void makeAdminOnlyFalse() {
    _adminOnly = false;
    notifyListeners();
  }

  void updateStudentTableIsVisible() {
    _studentTableIsVisible = !studentTableIsVisible;
    notifyListeners();
  }

  void updateConcoDeleteIsVisible() {
    _concoDeleteisVisible = !concoDeleteisVisible;
    notifyListeners();
  }

  void updateStudentDeleteIsVisible() {
    _studentDeleteisVisible = !studentDeleteisVisible;
    notifyListeners();
  }

  // adjusts multiplier for tree count number when years is modified
  adjustAdminMultiplier() {
    double doubleNumOfYears = double.parse(numOfYears);
    _multiplier = 15 / doubleNumOfYears;
    notifyListeners();
  }

  // save an arrival or departure after a user selects it from the lookup screen
  selectAdminAirplane(BuildContext context, AirportLookup airportLookup,
      Direction direction) async {
    Airport result = await showSearch(
      context: context,
      delegate: AirportSearchDelegate(airportLookup: airportLookup),
    );
    if (direction == Direction.departure) {
      _departure = result;
    } else {
      _arrival = result;
    }
    notifyListeners();
  }

  // CALCULATE PROFILE TOTAL METHODS

  // calculates total admin flights or total admin and conco associated flights
  void calculateTotalAdminFlights(List<AdminDataTableEntry> adminEntries,
      List<ProfileDataTableEntry> profileEntries, bool adminOnly) {
    if (adminOnly) {
      _totalFlights = adminEntries.length;
    } else {
      _totalFlights = adminEntries.length +
          Calculations.profileIsConcoFlights(profileEntries).length;
    }
    notifyListeners();
  }

  // calculates total admin miles or total admin and conco associated miles
  void calculateTotalAdminMiles(List<AdminDataTableEntry> adminEntries,
      List<ProfileDataTableEntry> profileEntries, bool adminOnly) {
    _totalMiles = 0;
    void _calculateAdminMiles() {
      for (AdminDataTableEntry entry in adminEntries) {
        _totalMiles +=
            Calculations.calculateMiles(entry.departure, entry.arrival);
      }
    }

    void _calculateConcoProfileMiles() {
      for (ProfileDataTableEntry entry
          in Calculations.profileIsConcoFlights(profileEntries)) {
        _totalMiles +=
            Calculations.calculateMiles(entry.departure, entry.arrival);
      }
    }

    if (adminOnly) {
      _calculateAdminMiles();
    } else {
      _calculateAdminMiles();
      _calculateConcoProfileMiles();
    }
    notifyListeners();
  }

  // calculates total tons of co2 in admin flights or in admin and conco associated flights
  void calculateTotalAdminTonsCo2(List<AdminDataTableEntry> adminEntries,
      List<ProfileDataTableEntry> profileEntries, bool adminOnly) {
    _totalCo2 = 0;
    void _calculateAdminCO2() {
      for (AdminDataTableEntry entry in adminEntries) {
        _totalCo2 += Calculations.calculateMetricTonsCO2(
          Calculations.adminDataEntryDistance(entry),
          Calculations.adminDataEntryFlightClass(entry),
        );
      }
    }

    void _calculateConcoProfileCO2() {
      for (ProfileDataTableEntry entry
          in Calculations.profileIsConcoFlights(profileEntries)) {
        _totalCo2 += Calculations.calculateMetricTonsCO2(
          Calculations.profileDataEntryDistance(entry),
          Calculations.profileDataEntryFlightClass(entry),
        );
      }
    }

    if (adminOnly) {
      _calculateAdminCO2();
    } else {
      _calculateAdminCO2();
      _calculateConcoProfileCO2();
    }
    notifyListeners();
  }

  // calculates total trees for admin flights or for admin and conco associated flights
  void calculateTotalAdminTrees(List<AdminDataTableEntry> adminEntries,
      List<ProfileDataTableEntry> profileEntries, bool adminOnly) {
    _totalTrees = 0;
    void _calculateAdminTrees() {
      for (AdminDataTableEntry entry in adminEntries) {
        _totalTrees += Calculations.calculateAirportsToTrees(
          entry.departure,
          entry.arrival,
          Calculations.adminDataEntryFlightClass(entry),
        );
      }
    }

    void _calculateConcoProfileTrees() {
      for (ProfileDataTableEntry entry
          in Calculations.profileIsConcoFlights(profileEntries)) {
        _totalTrees += Calculations.calculateAirportsToTrees(
          entry.departure,
          entry.arrival,
          Calculations.profileDataEntryFlightClass(entry),
        );
      }
    }

    if (adminOnly) {
      _calculateAdminTrees();
    } else {
      _calculateAdminTrees();
      _calculateConcoProfileTrees();
    }
    notifyListeners();
  }

  // calculate all the totals at once
  void calculateAdminTotals(
    List<AdminDataTableEntry> adminEntries,
    List<ProfileDataTableEntry> profileEntries,
    bool adminOnly,
  ) {
    calculateTotalAdminFlights(adminEntries, profileEntries, adminOnly);
    calculateTotalAdminMiles(adminEntries, profileEntries, adminOnly);
    calculateTotalAdminTonsCo2(adminEntries, profileEntries, adminOnly);
    calculateTotalAdminTrees(adminEntries, profileEntries, adminOnly);
    notifyListeners();
  }

  // adds single admin entry to totals
  void _addSingleAdminEntryForTotals(
    AdminDataTableEntry newAdminEntry,
  ) {
    _totalMiles += Calculations.calculateMiles(
        newAdminEntry.departure, newAdminEntry.arrival);

    _totalCo2 += Calculations.calculateMetricTonsCO2(
      Calculations.adminDataEntryDistance(newAdminEntry),
      Calculations.adminDataEntryFlightClass(newAdminEntry),
    );

    _totalTrees += Calculations.calculateAirportsToTrees(
      newAdminEntry.departure,
      newAdminEntry.arrival,
      Calculations.adminDataEntryFlightClass(newAdminEntry),
    );

    _totalFlights += 1;
  }

  // Calculates the total and adds a new admin data entry to the total
  void addAdminEntryToTotal(
    List<AdminDataTableEntry> adminEntries,
    List<ProfileDataTableEntry> profileEntries,
    bool adminOnly,
    AdminDataTableEntry newAdminEntry,
  ) {
    calculateAdminTotals(adminEntries, profileEntries, adminOnly);
    _addSingleAdminEntryForTotals(newAdminEntry);
    notifyListeners();
  }

  // removes single admin entry from totals
  void _removeSingleAdminEntryForTotals(
    AdminDataTableEntry adminEntryToRemove,
  ) {
    _totalMiles -= Calculations.calculateMiles(
        adminEntryToRemove.departure, adminEntryToRemove.arrival);

    _totalCo2 -= Calculations.calculateMetricTonsCO2(
      Calculations.adminDataEntryDistance(adminEntryToRemove),
      Calculations.adminDataEntryFlightClass(adminEntryToRemove),
    );

    _totalTrees -= Calculations.calculateAirportsToTrees(
      adminEntryToRemove.departure,
      adminEntryToRemove.arrival,
      Calculations.adminDataEntryFlightClass(adminEntryToRemove),
    );

    _totalFlights -= 1;
  }

  // Calculates the total and removes an admin data entry from the total
  void removeAdminEntryFromTotal(
    List<AdminDataTableEntry> adminEntries,
    List<ProfileDataTableEntry> profileEntries,
    bool adminOnly,
    AdminDataTableEntry adminEntryToRemove,
  ) {
    calculateAdminTotals(adminEntries, profileEntries, adminOnly);
    _removeSingleAdminEntryForTotals(adminEntryToRemove);
    notifyListeners();
  }

  // removes single admin profile entry from totals
  void _removeSingleAdminProfileEntryForTotals(
    ProfileDataTableEntry profileEntryToRemove,
  ) {
    _totalMiles -= Calculations.calculateMiles(
        profileEntryToRemove.departure, profileEntryToRemove.arrival);

    _totalCo2 -= Calculations.calculateMetricTonsCO2(
      Calculations.profileDataEntryDistance(profileEntryToRemove),
      Calculations.profileDataEntryFlightClass(profileEntryToRemove),
    );

    _totalTrees -= Calculations.calculateAirportsToTrees(
      profileEntryToRemove.departure,
      profileEntryToRemove.arrival,
      Calculations.profileDataEntryFlightClass(profileEntryToRemove),
    );

    _totalFlights -= 1;
  }

  // Calculates the total and removes an admin profile data entry from the total
  void removeAdminProfileEntryFromTotal(
    List<AdminDataTableEntry> adminEntries,
    List<ProfileDataTableEntry> profileEntries,
    bool adminOnly,
    ProfileDataTableEntry profileEntryToRemove,
  ) {
    calculateAdminTotals(adminEntries, profileEntries, adminOnly);
    _removeSingleAdminProfileEntryForTotals(profileEntryToRemove);
    notifyListeners();
  }

  void resetAdminStats() {
    _departure = null;
    _arrival = null;
    _flightClass = 'Economy';
  }
}
