import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sustainibility_project/providers/admin.dart';
import 'package:sustainibility_project/providers/profile.dart';
import 'package:sustainibility_project/widgets/admin_widgets/admin_time_dropdown_button.dart';
import 'package:sustainibility_project/widgets/rounded_button.dart';

class AdminTotalsBar extends StatelessWidget {
  final List<AdminDataTableEntry> adminEntries;
  final List<ProfileDataTableEntry> profileEntries;

  AdminTotalsBar(this.adminEntries, this.profileEntries);

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<Admin>(context);
    return Container(
      width: 390,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 120,
            width: 390,
            child: Center(
              child: Text(
                'TOTALS',
                style: Theme.of(context).textTheme.headline2.merge(
                      TextStyle(
                        color: Colors.white,
                      ),
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RoundedButton(
                  height: 50,
                  width: 150,
                  text: Text(
                    'ALL',
                    style: Theme.of(context).textTheme.button,
                  ),
                  color: Theme.of(context).accentColor,
                  function: () {
                    admin.makeAdminOnlyFalse();
                    admin.calculateAdminTotals(adminEntries, profileEntries, admin.adminOnly);
                  },
                ),
                RoundedButton(
                  height: 50,
                  width: 170,
                  text: Text(
                    'CONCORDIA',
                    style: Theme.of(context).textTheme.button,
                  ),
                  color: Theme.of(context).accentColor,
                  function: () {
                    admin.makeAdminOnlyTrue();
                    admin.calculateAdminTotals(adminEntries, profileEntries, admin.adminOnly);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 60, left: 40, right: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Total Flights:',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Miles:',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Tons CO₂:',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Trees:',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${admin.totalFlights}',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${admin.totalMiles}',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${admin.totalCo2.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '${(admin.totalTrees * admin.multiplier).toStringAsFixed(0)}',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 60, left: 40, right: 40),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Time:',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AdminTimeDropdownButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: GestureDetector(
                  onTap: admin.updateStudentTableIsVisible,
                  child: Text(
                    'Show student table (+)',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
