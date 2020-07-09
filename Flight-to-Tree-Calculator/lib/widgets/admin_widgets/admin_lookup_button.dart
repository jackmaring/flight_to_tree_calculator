import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sustainibility_project/C02_flight_calculator_plugin/airport_lookup.dart';
import 'package:sustainibility_project/providers/admin.dart';
import 'package:sustainibility_project/providers/flight_to_trees.dart';
import 'package:sustainibility_project/styles/custom_colors.dart';

class AdminLookupButton extends StatelessWidget {
  final String text;
  final AirportLookup airportLookup;
  final Direction direction;

  AdminLookupButton({
    this.text,
    this.airportLookup,
    this.direction,
  });

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<Admin>(context);
    return GestureDetector(
      child: Container(
        height: 45,
        width: 300,
        decoration: BoxDecoration(
          color: CustomColors.lightGray,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(width: 15,),
            direction == Direction.departure
                ? admin.departure != null
                    ? Text(
                        admin.departure.iata,
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomColors.mediumGray,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    : Text(
                        text,
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomColors.mediumGray,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                : admin.arrival != null
                    ? Text(
                        admin.arrival.iata,
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomColors.mediumGray,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    : Text(
                        text,
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomColors.mediumGray,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
          ],
        ),
      ),
      onTap: () => admin.selectAdminAirplane(
        context,
        airportLookup,
        direction,
      ),
    );
  }
}