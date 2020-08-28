import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sustainibility_project/C02_flight_calculator_plugin/airport.dart';
import 'package:sustainibility_project/C02_flight_calculator_plugin/airport_lookup.dart';
import 'package:sustainibility_project/extensions/hover_extensions.dart';
import 'package:sustainibility_project/providers/admin.dart';
import 'package:sustainibility_project/providers/profile.dart';
import 'package:sustainibility_project/styles/custom_colors.dart';
import 'package:sustainibility_project/widgets/admin_widgets/admin_add_entry_form.dart';
import 'package:sustainibility_project/widgets/admin_widgets/admin_datatable.dart';
import 'package:sustainibility_project/widgets/admin_widgets/admin_student_datatable.dart';
import 'package:sustainibility_project/widgets/admin_widgets/admin_totals_bar.dart';
import 'package:sustainibility_project/widgets/navbar/account_navbar.dart';

class AdminView extends StatefulWidget {
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final admin = Provider.of<Admin>(context, listen: false);
      final profileEntries =
          Provider.of<List<ProfileDataTableEntry>>(context, listen: false);
      final adminEntries =
          Provider.of<List<AdminDataTableEntry>>(context, listen: false);
      if (adminEntries != null && profileEntries != null) {
        admin.calculateAdminTotals(
          adminEntries,
          profileEntries,
          admin.adminOnly,
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
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Airport> airports = Provider.of<List<Airport>>(context);
    AirportLookup airportLookup = AirportLookup(airports: airports);
    final admin = Provider.of<Admin>(context);
    final adminEntries = Provider.of<List<AdminDataTableEntry>>(context);
    final profileEntries = Provider.of<List<ProfileDataTableEntry>>(context);

    return Scaffold(
      body: (profileEntries != null && adminEntries != null)
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AdminTotalsBar(adminEntries, profileEntries),
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
                                AdminAddEntryForm(
                                  airportLookup,
                                  adminEntries,
                                  profileEntries,
                                ),
                                SizedBox(height: 80),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'CONCORDIA Table',
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
                                      ).showCursorOnHover,
                                      onPressed: () {
                                        admin.updateConcoDeleteIsVisible();
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                AdminDataTable(adminEntries, profileEntries),
                                SizedBox(height: 80),
                                admin.studentTableIsVisible
                                    ? Row(
                                        children: <Widget>[
                                          Text(
                                            'STUDENT Table',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
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
                                            onPressed: () {
                                              admin
                                                  .updateStudentDeleteIsVisible();
                                            },
                                          ).showCursorOnHover,
                                        ],
                                      )
                                    : Container(),
                                SizedBox(height: 30),
                                admin.studentTableIsVisible
                                    ? AdminStudentDataTable(
                                        profileEntries, adminEntries)
                                    : Container(),
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
