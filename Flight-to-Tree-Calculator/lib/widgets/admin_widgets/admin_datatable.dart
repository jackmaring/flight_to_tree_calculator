import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sustainibility_project/providers/admin.dart';
import 'package:sustainibility_project/providers/profile.dart';
import 'package:sustainibility_project/services/calculations.dart';
import 'package:sustainibility_project/services/crud_models/admin_crud_model.dart';
import 'package:sustainibility_project/widgets/custom_datatable.dart';

class AdminDataTable extends StatelessWidget {
  final List<AdminDataTableEntry> adminEntries;
  final List<ProfileDataTableEntry> profileEntries;
  final Calculations calculations = Calculations();
  final AdminCRUDModel adminCrud = AdminCRUDModel();

  AdminDataTable(this.adminEntries, this.profileEntries);

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<Admin>(context);
    return CustomDataTable(
        columns: [
          CustomDataColumn(
            label: Text('Name'),
            numeric: false,
          ),
          CustomDataColumn(
            label: Text('Title'),
            numeric: false,
          ),
          CustomDataColumn(
            label: Text('From'),
            numeric: false,
          ),
          CustomDataColumn(
            label: Text('To'),
            numeric: false,
          ),
          CustomDataColumn(
            label: Text('Flight Class'),
            numeric: false,
          ),
          CustomDataColumn(
            label: Text('Trees'),
            numeric: false,
          ),
          CustomDataColumn(
            label: Text('Delete'),
            numeric: false,
          ),
        ],
        rows: adminEntries
            .map(
              (adminEntry) => CustomDataRow(
                cells: [
                  CustomDataCell(
                    Text(
                      '${adminEntry.name}',
                    ),
                  ),
                  CustomDataCell(
                    Text(
                      '${adminEntry.jobTitle}',
                    ),
                  ),
                  CustomDataCell(
                    Text(
                      '${adminEntry.departure.iata}',
                    ),
                  ),
                  CustomDataCell(
                    Text(
                      '${adminEntry.arrival.iata}',
                    ),
                  ),
                  CustomDataCell(
                    Text(
                      '${adminEntry.flightClass}',
                    ),
                  ),
                  CustomDataCell(
                    Text(
                      '${calculations.calculateTrees(calculations.calculateTonsCO2(calculations.calculateDistance(adminEntry.departure, adminEntry.arrival), calculations.stringToFlightClass(adminEntry.flightClass)))}',
                    ),
                  ),
                  admin.concoDeleteisVisible
                      ? CustomDataCell(
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                adminCrud.removeAdminDataEntry(adminEntry.id);
                                admin.removeAdminEntryFromTotal(
                                  adminEntries,
                                  profileEntries,
                                  admin.adminOnly,
                                  adminEntry,
                                );
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
            .toList());
  }
}
