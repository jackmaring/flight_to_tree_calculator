import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sustainibility_project/C02_flight_calculator_plugin/airport_lookup.dart';
import 'package:sustainibility_project/providers/flight_to_trees.dart';

class LookupButton extends StatelessWidget {
  final double height;
  final double width;
  final Text text;
  final TextStyle aiportNameStyle;
  final AirportLookup airportLookup;
  final Direction direction;

  LookupButton({
    this.height,
    this.width,
    this.text,
    this.aiportNameStyle,
    this.airportLookup,
    this.direction,
  });

  @override
  Widget build(BuildContext context) {
    final flightToTrees = Provider.of<FlightToTrees>(context);
    return GestureDetector(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: Center(
            child: direction == Direction.departure
                ? flightToTrees.departure != null
                    ? Text(
                        '${flightToTrees.departure.iata}',
                        style: aiportNameStyle,
                      )
                    : text
                : flightToTrees.arrival != null
                    ? Text(
                        '${flightToTrees.arrival.iata}',
                        style: aiportNameStyle,
                      )
                    : text),
      ),
      onTap: () => flightToTrees.selectAirplane(
        context,
        airportLookup,
        direction,
      ),
    );
  }
}
