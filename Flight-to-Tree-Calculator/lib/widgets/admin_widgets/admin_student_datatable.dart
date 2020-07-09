import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sustainibility_project/providers/admin.dart';
import 'package:sustainibility_project/providers/profile.dart';
import 'package:sustainibility_project/services/calculations.dart';
import 'package:sustainibility_project/services/crud_models/profile_crud_model.dart';
import 'package:sustainibility_project/widgets/custom_datatable.dart';

class AdminStudentDataTable extends StatelessWidget {
  final List<ProfileDataTableEntry> profileEntries;
  final List<AdminDataTableEntry> adminEntries;
  final Calculations calculations = Calculations();
  final ProfileCRUDModel profileCrud = ProfileCRUDModel();

  AdminStudentDataTable(this.profileEntries, this.adminEntries);

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<Admin>(context);
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
          label: Text("CO₂"),
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
          label: Text("Delete"),
          numeric: false,
        ),
      ],
      rows: profileEntries
          .where((entry) => entry.isConco == true)
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
                    '${calculations.calculateTonsCO2(calculations.calculateDistance(profileEntry.departure, profileEntry.arrival), calculations.stringToFlightClass(profileEntry.flightClass)).toStringAsFixed(2)}',
                  ),
                ),
                CustomDataCell(
                  Text(
                      '${calculations.calculateTrees(calculations.calculateTonsCO2(calculations.calculateDistance(profileEntry.departure, profileEntry.arrival), calculations.stringToFlightClass(profileEntry.flightClass)))}'),
                ),
                CustomDataCell(
                  Text(profileEntry.isConco ? 'Yes' : 'No'),
                ),
                admin.studentDeleteisVisible
                    ? CustomDataCell(
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              profileCrud
                                  .removeProfileDataEntry(profileEntry.id);
                              admin.removeAdminProfileEntryFromTotal(
                                adminEntries,
                                profileEntries,
                                admin.adminOnly,
                                profileEntry,
                              );
                            },
                            child: Icon(
                              Icons.do_not_disturb_on,
                              color: Colors.red,
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
