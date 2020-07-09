import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sustainibility_project/providers/profile.dart';
import 'package:sustainibility_project/services/calculations.dart';
import 'package:sustainibility_project/services/crud_models/profile_crud_model.dart';
import 'package:sustainibility_project/styles/custom_colors.dart';
import 'package:sustainibility_project/widgets/custom_datatable.dart';

class ProfileDataTable extends StatelessWidget {
  final List<ProfileDataTableEntry> profileEntries;
  final String uid;
  final Calculations calculations = Calculations();
  final ProfileCRUDModel profileCrud = ProfileCRUDModel();

  ProfileDataTable(this.profileEntries, this.uid);

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
              .where((entry) => entry.isConco == true && entry.uid == uid)
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
                        '${calculations.calculateMiles(profileEntry.departure, profileEntry.arrival)}',
                      ),
                    ),
                    CustomDataCell(
                      Text(
                          '${calculations.calculateTrees(calculations.calculateTonsCO2(calculations.calculateDistance(profileEntry.departure, profileEntry.arrival), calculations.stringToFlightClass(profileEntry.flightClass)))}'),
                    ),
                    CustomDataCell(
                      Text(profileEntry.isConco ? 'Yes' : 'No'),
                    ),
                    profile.deleteIsVisible
                        ? CustomDataCell(
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  profileCrud
                                      .removeProfileDataEntry(profileEntry.id);
                                  print('pressed delete');
                                },
                                child: Icon(
                                  Icons.do_not_disturb_on,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          )
                        : CustomDataCell(Text('')),
                  ],
                ),
              )
              .toList()
          : profileEntries
              .where((entry) => entry.uid == uid)
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
                        '${calculations.calculateMiles(profileEntry.departure, profileEntry.arrival)}',
                      ),
                    ),
                    CustomDataCell(
                      Text(
                          '${calculations.calculateTrees(calculations.calculateTonsCO2(calculations.calculateDistance(profileEntry.departure, profileEntry.arrival), calculations.stringToFlightClass(profileEntry.flightClass)))}'),
                    ),
                    CustomDataCell(
                      Text(profileEntry.isConco ? 'Yes' : 'No'),
                    ),
                    profile.deleteIsVisible
                        ? CustomDataCell(
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  profileCrud
                                      .removeProfileDataEntry(profileEntry.id);
                                  profile.removeProfileEntryFromTotal(
                                    profileEntries,
                                    profile.concoOnly,
                                    uid,
                                    profileEntry,
                                  );
                                },
                                child: Icon(
                                  Icons.do_not_disturb_on,
                                  color: CustomColors.red,
                                ),
                              ),
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
