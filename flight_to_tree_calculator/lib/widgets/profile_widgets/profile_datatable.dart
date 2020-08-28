import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sustainibility_project/extensions/hover_extensions.dart';
import 'package:sustainibility_project/providers/profile.dart';
import 'package:sustainibility_project/services/calculations.dart';
import 'package:sustainibility_project/services/crud_models/profile_crud_model.dart';
import 'package:sustainibility_project/styles/custom_colors.dart';
import 'package:sustainibility_project/widgets/custom_datatable.dart';

class ProfileDataTable extends StatelessWidget {
  final List<ProfileDataTableEntry> profileEntries;
  final FirebaseUser user;
  final ProfileCRUDModel profileCrud = ProfileCRUDModel();

  ProfileDataTable(this.profileEntries, this.user);

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Profile>(context);
    return CustomDataTable(
      columns: [
        CustomDataColumn(
          label: Text("From"),
          numeric: false,
        ),
        CustomDataColumn(
          label: Text("To"),
          numeric: false,
        ),
        CustomDataColumn(
          label: Text('Class'),
          numeric: false,
        ),
        CustomDataColumn(
          label: Text("Miles"),
          numeric: false,
        ),
        CustomDataColumn(
          label: Text("Trees"),
          numeric: false,
        ),
        CustomDataColumn(
          label: Text("Conco"),
          numeric: false,
        ),
        CustomDataColumn(
          label: Text('Delete'),
          numeric: false,
        ),
      ],
      rows: profile.concoOnly
          ? profileEntries
              .where((entry) => entry.isConco == true && entry.uid == user.uid)
              .map(
                (profileEntry) => CustomDataRow(
                  cells: [
                    CustomDataCell(
                      Text(
                        '${profileEntry.departure.iata}',
                      ),
                    ),
                    CustomDataCell(
                      Text(
                        '${profileEntry.arrival.iata}',
                      ),
                    ),
                    CustomDataCell(
                      Text(
                        '${profileEntry.flightClass}',
                      ),
                    ),
                    CustomDataCell(
                      Text(
                        '${Calculations.calculateMiles(profileEntry.departure, profileEntry.arrival)}',
                      ),
                    ),
                    CustomDataCell(
                      Text(
                          '${Calculations.calculateTrees(Calculations.calculateMetricTonsCO2(Calculations.calculateDistance(profileEntry.departure, profileEntry.arrival), Calculations.stringToFlightClass(profileEntry.flightClass)))}'),
                    ),
                    CustomDataCell(
                      Text(profileEntry.isConco ? 'Yes' : 'No'),
                    ),
                    profile.deleteIsVisible
                        ? CustomDataCell(
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  profileCrud.removeProfileDataEntry(
                                    profileEntry.id,
                                  );
                                },
                                child: Icon(
                                  Icons.do_not_disturb_on,
                                  color: Colors.red,
                                ),
                              ).showCursorOnHover,
                            ),
                          )
                        : CustomDataCell(Text('')),
                  ],
                ),
              )
              .toList()
          : profileEntries
              .where((entry) => entry.uid == user.uid)
              .map(
                (profileEntry) => CustomDataRow(
                  cells: [
                    CustomDataCell(
                      Text(
                        '${profileEntry.departure.iata}',
                        // uid,
                      ),
                    ),
                    CustomDataCell(
                      Text(
                        '${profileEntry.arrival.iata}',
                        // '${profileEntry.uid}',
                      ),
                    ),
                    CustomDataCell(
                      Text(
                        '${profileEntry.flightClass}',
                      ),
                    ),
                    CustomDataCell(
                      Text(
                        '${Calculations.calculateMiles(profileEntry.departure, profileEntry.arrival)}',
                      ),
                    ),
                    CustomDataCell(
                      Text(
                          '${Calculations.calculateTrees(Calculations.calculateMetricTonsCO2(Calculations.calculateDistance(profileEntry.departure, profileEntry.arrival), Calculations.stringToFlightClass(profileEntry.flightClass)))}'),
                    ),
                    CustomDataCell(
                      Text(profileEntry.isConco ? 'Yes' : 'No'),
                    ),
                    profile.deleteIsVisible
                        ? CustomDataCell(
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  profileCrud.removeProfileDataEntry(
                                    profileEntry.id,
                                  );
                                  profile.removeProfileEntryFromTotal(
                                    profileEntries,
                                    profile.concoOnly,
                                    user.uid,
                                    profileEntry,
                                  );
                                },
                                child: Icon(
                                  Icons.do_not_disturb_on,
                                  color: CustomColors.red,
                                ),
                              ).showCursorOnHover,
                            ),
                          )
                        : CustomDataCell(
                            Text(''),
                          ),
                  ],
                ),
              )
              .toList(),
    );
  }
}
