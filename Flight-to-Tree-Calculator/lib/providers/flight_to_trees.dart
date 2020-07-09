import 'package:flutter/material.dart';
import 'package:sustainibility_project/C02_flight_calculator_plugin/airport.dart';
import 'package:sustainibility_project/C02_flight_calculator_plugin/airport_lookup.dart';
import 'package:sustainibility_project/C02_flight_calculator_plugin/airport_search_delegate.dart';
import 'package:sustainibility_project/services/calculations.dart';

enum Direction {
  departure,
  arrival,
}

enum FlightType {
  oneWay,
  roundTrip,
}

class FlightToTrees with ChangeNotifier {
  Calculations calculations = Calculations();

  Airport _departure;
  Airport _arrival;
  String _flightType = 'One Way';
  String _flightClass = 'Economy';
  String _numOfYears = '100';
  int _treeNum = 0;

  Airport get departure => _departure;
  Airport get arrival => _arrival;
  String get flightType => _flightType;
  String get flightClass => _flightClass;
  String get numOfYears => _numOfYears;
  int get treeNum => _treeNum;

  void updateFlightClass(String newValue) {
    _flightClass = newValue;
    notifyListeners();
  }

  void updateFlightType(String newValue) {
    _flightType = newValue;
    notifyListeners();
  }

  void updateNumOfYears(String newValue) {
    _numOfYears = newValue;
    notifyListeners();
  }

  // makes sure depature and arrival aren't equal to null
  bool checkAirplanes() {
    if ((this.departure != null) && (this.arrival != null)) {
      return true;
    }
    return false;
  }

  // save an arrival or departure after a user selects it from the lookup screen
  selectAirplane(BuildContext context, AirportLookup airportLookup,
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

  // updates tree number displayed on home and profile page
  updateTreeNumber() {
    double doubleNumOfYears = double.parse(_numOfYears);
    double multiplier = 100 / doubleNumOfYears;
    if ((departure != null) && (arrival != null)) {
      int treeCount = (calculations.calculateAirportsToTrees(
                departure,
                arrival,
                calculations.stringToFlightClass(_flightClass),
              ) *
              multiplier)
          .round();
      if (_flightType == 'Round Trip') {
        treeCount *= 2;
      }
      if (treeCount == 0) {
        _treeNum = 1;
      } else {
        _treeNum = treeCount;
      }
    } else {
      _treeNum = 0;
    }
    notifyListeners();
  }

  resetStats() {
    _departure = null;
    _arrival = null;
    _flightType = 'One Way';
    _flightClass = 'Economy';
    _numOfYears = '100';
    _treeNum = 0;
    notifyListeners();
  }
}
