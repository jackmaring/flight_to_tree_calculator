import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sustainibility_project/C02_flight_calculator_plugin/airport.dart';
import 'package:sustainibility_project/C02_flight_calculator_plugin/airport_lookup.dart';
import 'package:sustainibility_project/extensions/hover_extensions.dart';
import 'package:sustainibility_project/providers/flight_to_trees.dart';
import 'package:sustainibility_project/providers/profile.dart';
import 'package:sustainibility_project/services/crud_models/profile_crud_model.dart';
import 'package:sustainibility_project/styles/custom_colors.dart';
import 'package:sustainibility_project/widgets/lookup_button.dart';
import 'package:sustainibility_project/widgets/profile_widgets/flight_class_dropdown_button.dart';
import 'package:sustainibility_project/widgets/profile_widgets/is_conco_checkbox.dart';
import 'package:sustainibility_project/widgets/profile_widgets/profile_datatable.dart';
import 'package:sustainibility_project/widgets/profile_widgets/profile_totals_bar.dart';
import 'package:sustainibility_project/widgets/rounded_button.dart';
import 'package:sustainibility_project/widgets/navbar/account_navbar.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileCRUDModel profileCrud = ProfileCRUDModel();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        final user = Provider.of<FirebaseUser>(context, listen: false);
        final profile = Provider.of<Profile>(context, listen: false);
        final profileEntries =
            Provider.of<List<ProfileDataTableEntry>>(context, listen: false);
        if (profileEntries != null && user != null) {
          profile.calculateProfileTotals(
            profileEntries,
            profile.concoOnly,
            user.uid,
          );
        } else {
          return Center(
            child: Container(
              height: 200,
              width: 200,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final flightToTrees = Provider.of<FlightToTrees>(context);
    final profile = Provider.of<Profile>(context);
    final user = Provider.of<FirebaseUser>(context);
    final profileEntries = Provider.of<List<ProfileDataTableEntry>>(context);
    List<Airport> airports = Provider.of<List<Airport>>(context);
    AirportLookup airportLookup = AirportLookup(airports: airports);

    void handleSaveButtonClick() {
      ProfileDataTableEntry newProfileEntry = ProfileDataTableEntry(
        uid: user.uid,
        departure: flightToTrees.departure,
        arrival: flightToTrees.arrival,
        flightClass: flightToTrees.flightClass,
        isConco: profile.isConco,
        dateCreated: Timestamp.now(),
      );
      profileCrud.addProfileDataEntry(newProfileEntry);
      profile.addProfileEntryToTotal(
          profileEntries, profile.concoOnly, user.uid, newProfileEntry);
      flightToTrees.resetStats();
    }

    return Scaffold(
      body: (profileEntries != null)
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ProfileTotalsBar(profileEntries, user),
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 390,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AccountNavbar(),
                          Padding(
                            padding: EdgeInsets.only(top: 30, left: 120),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  flightToTrees.treeNum == 1
                                      ? '${flightToTrees.treeNum} Tree Needed!'
                                      : '${flightToTrees.treeNum} Trees Needed!',
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                SizedBox(height: 50),
                                Row(
                                  children: <Widget>[
                                    LookupButton(
                                      height: 50,
                                      width: 150,
                                      text: Text(
                                        'From',
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                                      aiportNameStyle:
                                          Theme.of(context).textTheme.button,
                                      airportLookup: airportLookup,
                                      direction: Direction.departure,
                                    ),
                                    SizedBox(width: 40),
                                    LookupButton(
                                      height: 50,
                                      width: 150,
                                      text: Text(
                                        'To',
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                                      aiportNameStyle:
                                          Theme.of(context).textTheme.button,
                                      airportLookup: airportLookup,
                                      direction: Direction.arrival,
                                    ),
                                    SizedBox(width: 40),
                                    IsConcoCheckBox(),
                                    Text(
                                      'Concordia associated flight?',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: CustomColors.darkGray,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Row(
                                  children: <Widget>[
                                    FlightClassDropDownButton(),
                                    SizedBox(width: 40),
                                    RoundedButton(
                                      height: 50,
                                      width: 150,
                                      text: Text(
                                        'Save',
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                                      color: CustomColors.brown,
                                      function: () {
                                        handleSaveButtonClick();
                                      },
                                    ),
                                    SizedBox(width: 40),
                                    RoundedButton(
                                      height: 50,
                                      width: 150,
                                      text: Text(
                                        'Calculate',
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                                      color: CustomColors.red,
                                      function: flightToTrees.updateTreeNumber,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 80),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'Flights Saved',
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: CustomColors.darkGray,
                                        size: 30,
                                      ),
                                      onPressed: profile.updateDeleteIsVisible,
                                    ).showCursorOnHover,
                                  ],
                                ),
                                SizedBox(height: 30),
                                ProfileDataTable(profileEntries, user),
                                SizedBox(height: 64),
                                Text(
                                  '* It takes 3 trees 15 years to absorb 1 metric ton of CO2',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: CustomColors.darkGray,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                SizedBox(height: 32),
                                Text(
                                  '* A Concordia associated flight is a flight sponsored directly by Concordia',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: CustomColors.darkGray,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 150),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Container(
                height: 200,
                width: 200,
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
