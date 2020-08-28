import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sustainibility_project/extensions/hover_extensions.dart';
import 'package:sustainibility_project/providers/admin.dart';
import 'package:sustainibility_project/styles/custom_colors.dart';

class AdminFlightClassDropDownButton extends StatelessWidget {
  final List<String> options = ['Economy', 'Business', 'First Class'];

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<Admin>(context);
    String _flightClassValue = admin.flightClass;
    return Row(
      children: <Widget>[
        Container(
          height: 45,
          width: 300,
          decoration: BoxDecoration(
            color: CustomColors.lightGray,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _flightClassValue,
              onChanged: (String value) {
                admin.updateAdminFlightClass(value);
              },
              selectedItemBuilder: (context) {
                return options.map((value) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        _flightClassValue,
                        style: TextStyle(
                          fontSize: 14,
                          color: CustomColors.mediumGray,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  );
                }).toList();
              },
              items: options.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true,
              icon: Container(),
            ),
          ),
        ).showCursorOnHover,
      ],
    );
  }
}
