import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sustainibility_project/extensions/hover_extensions.dart';
import 'package:sustainibility_project/providers/admin.dart';

class AdminTimeDropdownButton extends StatelessWidget {
  final List<String> options = [
    '5',
    '10',
    '15',
    '20',
    '25',
    '30'
  ];

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<Admin>(context);
    String _timeValue = admin.numOfYears;
    return DropdownButton<String>(
      value: _timeValue,
      onChanged: (String value) {
        admin.updateAdminNumOfYears(value);
        admin.adjustAdminMultiplier();
      },
      selectedItemBuilder: (context) {
        return options.map(
          (value) {
            return Center(
              child: Text(
                '$_timeValue Years',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ).toList();
      },
      items: options.map<DropdownMenuItem<String>>(
        (value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Center(
              child: Text(
                value,
              ),
            ),
          );
        },
      ).toList(),
      underline: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white),
          ),
        ),
      ),
      isExpanded: true,
      iconEnabledColor: Colors.white,
      iconSize: 20,
    ).showCursorOnHover;
  }
}
