import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainibility_project/C02_flight_calculator_plugin/airport_lookup.dart';
import 'package:sustainibility_project/providers/admin.dart';
import 'package:sustainibility_project/providers/flight_to_trees.dart';
import 'package:sustainibility_project/providers/profile.dart';
import 'package:sustainibility_project/services/crud_models/admin_crud_model.dart';
import 'package:sustainibility_project/styles/custom_colors.dart';
import 'package:sustainibility_project/widgets/admin_widgets/admin_flight_class_dropdown_button.dart';
import 'package:sustainibility_project/widgets/admin_widgets/admin_lookup_button.dart';
import 'package:sustainibility_project/widgets/register_button.dart';

class AdminAddEntryForm extends StatefulWidget {
  final AirportLookup airportLookup;
  final List<AdminDataTableEntry> adminEntries;
  final List<ProfileDataTableEntry> profileEntries;

  AdminAddEntryForm(this.airportLookup, this.adminEntries, this.profileEntries);

  @override
  _AdminAddEntryFormState createState() => _AdminAddEntryFormState();
}

class _AdminAddEntryFormState extends State<AdminAddEntryForm> {
  AdminCRUDModel adminCrud = AdminCRUDModel();
  String name, title;

  final _formKey = GlobalKey<FormState>();

  checkFields() {
    final form = _formKey.currentState;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<Admin>(context);

    void handleAddEntryClick() {
      AdminDataTableEntry newAdminEntry = AdminDataTableEntry(
        name: name,
        jobTitle: title,
        departure: admin.departure,
        arrival: admin.arrival,
        flightClass: admin.flightClass,
      );
      adminCrud.addAdminDataEntry(newAdminEntry);
      admin.addAdminEntryToTotal(
        widget.adminEntries,
        widget.profileEntries,
        admin.adminOnly,
        newAdminEntry,
      );
      admin.resetAdminStats();
    }

    return Form(
      key: _formKey,
      child: Container(
        height: 380,
        width: 730,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
            )
          ],
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Text(
                'Add Concordia Entry',
                style: TextStyle(
                  fontSize: 24,
                  color: CustomColors.darkGray,
                  // fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45, left: 45, right: 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 45,
                    width: 300,
                    decoration: BoxDecoration(
                      color: CustomColors.lightGray,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: TextFormField(
                      cursorColor: CustomColors.darkGray,
                      style: TextStyle(
                        fontSize: 14,
                        color: CustomColors.mediumGray,
                        fontWeight: FontWeight.w300,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15),
                        hintText: 'Name',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: CustomColors.mediumGray,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) =>
                          value.isEmpty ? 'Name is required' : null,
                      onChanged: (value) {
                        this.name = value;
                      },
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 300,
                    decoration: BoxDecoration(
                      color: CustomColors.lightGray,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: TextFormField(
                      cursorColor: CustomColors.darkGray,
                      style: TextStyle(
                        fontSize: 14,
                        color: CustomColors.mediumGray,
                        fontWeight: FontWeight.w300,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15),
                        hintText: 'Job Title',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: CustomColors.mediumGray,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) =>
                          value.isEmpty ? 'Job title is required' : null,
                      onChanged: (value) {
                        this.title = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 45, right: 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AdminLookupButton(
                    text: 'From',
                    airportLookup: widget.airportLookup,
                    direction: Direction.departure,
                  ),
                  AdminLookupButton(
                    text: 'To',
                    airportLookup: widget.airportLookup,
                    direction: Direction.arrival,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 45, right: 45),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AdminFlightClassDropDownButton(),
                  RegisterButton(
                    text: 'Add Entry',
                    function: () {
                      if (checkFields()) {
                        handleAddEntryClick();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
