import 'package:flutter/material.dart';

import 'package:sustainibility_project/C02_flight_calculator_plugin/airport.dart';
import 'package:sustainibility_project/services/calculations.dart';
import 'package:sustainibility_project/services/crud_models/profile_crud_model.dart';

class ProfileDataTableEntry {
  String id;
  String uid;
  Airport departure;
  Airport arrival;
  String flightClass;
  bool isConco;

  ProfileDataTableEntry({
    this.id,
    this.uid,
    this.departure,
    this.arrival,
    this.flightClass,
    this.isConco,
  });

  ProfileDataTableEntry.fromMap(Map<String, dynamic> data)
      : this(
          id: data['id'],
          uid: data['uid'],
          departure: Airport.fromMap(data['departure']),
          arrival: Airport.fromMap(data['arrival']),
          flightClass: data['flightClass'],
          isConco: data['isConco'],
        );

  Map<String, dynamic> toMap() => {
        'id': id,
        'uid': this.uid,
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
        'isConco': this.isConco,
      };
}

class Profile with ChangeNotifier {
  ProfileCRUDModel crud = ProfileCRUDModel();
  Calculations calculations = Calculations();

  String _numOfYears = '100';
  bool _isConco = false;
  bool _concoOnly = false;
  bool _deleteIsVisible = false;

  double _totalMiles = 0;
  double _totalCo2 = 0;
  int _totalTrees = 0;
  int _totalFlights = 0;
  double _multiplier = 1;

  String get numOfYears => _numOfYears;
  bool get isConco => _isConco;
  bool get concoOnly => _concoOnly;
  bool get deleteIsVisible => _deleteIsVisible;

  double get totalMiles => _totalMiles;
  double get totalCo2 => _totalCo2;
  int get totalTrees => _totalTrees;
  int get totalFlights => _totalFlights;
  double get multiplier => _multiplier;

  void updateIsConco(bool newVal) {
    _isConco = newVal;
    notifyListeners();
  }

  void updateNumOfYears(String newVal) {
    _numOfYears = newVal;
    notifyListeners();
  }

  void makeConcoOnlyTrue() {
    _concoOnly = true;
    notifyListeners();
  }

  void makeConcoOnlyFalse() {
    _concoOnly = false;
    notifyListeners();
  }

  void updateDeleteIsVisible() {
    _deleteIsVisible = !deleteIsVisible;
    notifyListeners();
  }

  adjustMultiplier() {
    double doubleNumOfYears = double.parse(numOfYears);
    _multiplier = 100 / doubleNumOfYears;
    notifyListeners();
  }

  // CALCULATE PROFILE TOTAL METHODS

  // calculates all user flights or only conco associated user flights
  void calculateTotalProfileFlights(
    List<ProfileDataTableEntry> profileEntries,
    bool concoOnly,
    String uid,
  ) {
    if (concoOnly) {
      _totalFlights =
          calculations.profileIsConcoUserFlights(profileEntries, uid).length;
    } else {
      _totalFlights =
          calculations.profileUserFlights(profileEntries, uid).length;
    }
    notifyListeners();
  }

  // calculates all user flight miles or only conco associated user flight miles
  void calculateTotalProfileMiles(
    List<ProfileDataTableEntry> profileEntries,
    bool concoOnly,
    String uid,
  ) {
    _totalMiles = 0;
    if (concoOnly) {
      for (ProfileDataTableEntry entry
          in calculations.profileIsConcoUserFlights(
        profileEntries,
        uid,
      )) {
        _totalMiles +=
            calculations.calculateMiles(entry.departure, entry.arrival);
      }
    } else {
      for (ProfileDataTableEntry entry
          in calculations.profileUserFlights(profileEntries, uid)) {
        _totalMiles +=
            calculations.calculateMiles(entry.departure, entry.arrival);
      }
    }
    notifyListeners();
  }

  // calculates all user flight tons of co2 or only conco associated user flight tons of co2
  void calculateTotalProfileTonsCo2(
    List<ProfileDataTableEntry> profileEntries,
    bool concoOnly,
    String uid,
  ) {
    _totalCo2 = 0;
    if (concoOnly) {
      for (ProfileDataTableEntry entry
          in calculations.profileIsConcoUserFlights(profileEntries, uid)) {
        _totalCo2 += calculations.calculateTonsCO2(
          calculations.profileDataEntryDistance(entry),
          calculations.profileDataEntryFlightClass(entry),
        );
      }
    } else {
      for (ProfileDataTableEntry entry
          in calculations.profileUserFlights(profileEntries, uid)) {
        _totalCo2 += calculations.calculateTonsCO2(
          calculations.profileDataEntryDistance(entry),
          calculations.profileDataEntryFlightClass(entry),
        );
      }
    }
    notifyListeners();
  }

  // calculates the total amount of trees for user flights or only the trees for conco associated user flights
  void calculateTotalProfileTrees(
    List<ProfileDataTableEntry> profileEntries,
    bool concoOnly,
    String uid,
  ) {
    _totalTrees = 0;
    if (concoOnly) {
      for (ProfileDataTableEntry entry
          in calculations.profileIsConcoUserFlights(profileEntries, uid)) {
        _totalTrees += calculations.calculateAirportsToTrees(
          entry.departure,
          entry.arrival,
          calculations.profileDataEntryFlightClass(entry),
        );
      }
    } else {
      for (ProfileDataTableEntry entry
          in calculations.profileUserFlights(profileEntries, uid)) {
        _totalTrees += calculations.calculateAirportsToTrees(
          entry.departure,
          entry.arrival,
          calculations.profileDataEntryFlightClass(entry),
        );
      }
    }
    notifyListeners();
  }

  // calculates all profile totals at once
  void calculateProfileTotals(
    List<ProfileDataTableEntry> profileEntries,
    bool concoOnly,
    String uid,
  ) {
    calculateTotalProfileFlights(profileEntries, concoOnly, uid);
    calculateTotalProfileMiles(profileEntries, concoOnly, uid);
    calculateTotalProfileTonsCo2(profileEntries, concoOnly, uid);
    calculateTotalProfileTrees(profileEntries, concoOnly, uid);
    notifyListeners();
  }

  // adds single profile entry to totals
  void _addSingleProfileEntryForTotals(
    ProfileDataTableEntry newProfileEntry,
  ) {
    _totalMiles += calculations.calculateMiles(
        newProfileEntry.departure, newProfileEntry.arrival);

    _totalCo2 += calculations.calculateTonsCO2(
      calculations.profileDataEntryDistance(newProfileEntry),
      calculations.profileDataEntryFlightClass(newProfileEntry),
    );

    _totalTrees += calculations.calculateAirportsToTrees(
      newProfileEntry.departure,
      newProfileEntry.arrival,
      calculations.profileDataEntryFlightClass(newProfileEntry),
    );

    _totalFlights += 1;
  }

  // Calculates the total and adds a new profile data entry to the total
  void addProfileEntryToTotal(
    List<ProfileDataTableEntry> profileEntries,
    bool concoOnly,
    String uid,
    ProfileDataTableEntry newProfileEntry,
  ) {
    calculateProfileTotals(profileEntries, concoOnly, uid);
    _addSingleProfileEntryForTotals(newProfileEntry);
    notifyListeners();
  }

  // removes single profile entry from totals
  void _removeSingleProfileEntryForTotals(
    ProfileDataTableEntry profileEntryToRemove,
  ) {
    _totalMiles -= calculations.calculateMiles(
        profileEntryToRemove.departure, profileEntryToRemove.arrival);

    _totalCo2 -= calculations.calculateTonsCO2(
      calculations.profileDataEntryDistance(profileEntryToRemove),
      calculations.profileDataEntryFlightClass(profileEntryToRemove),
    );

    _totalTrees -= calculations.calculateAirportsToTrees(
      profileEntryToRemove.departure,
      profileEntryToRemove.arrival,
      calculations.profileDataEntryFlightClass(profileEntryToRemove),
    );

    _totalFlights -= 1;
  }

  // Calculates the total and removes a profile data entry from the total
  void removeProfileEntryFromTotal(
    List<ProfileDataTableEntry> profileEntries,
    bool concoOnly,
    String uid,
    ProfileDataTableEntry profileEntryToRemove,
  ) {
    calculateProfileTotals(profileEntries, concoOnly, uid);
    _removeSingleProfileEntryForTotals(profileEntryToRemove);
    notifyListeners();
  }
}
