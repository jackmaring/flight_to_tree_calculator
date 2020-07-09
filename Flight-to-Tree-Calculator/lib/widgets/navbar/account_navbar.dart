import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sustainibility_project/providers/flight_to_trees.dart';
import 'package:sustainibility_project/services/auth_service.dart';
import 'package:sustainibility_project/styles/custom_colors.dart';
import 'package:sustainibility_project/views/home_view.dart';
import 'package:sustainibility_project/views/login_view.dart';
import 'package:sustainibility_project/widgets/rounded_button.dart';
import 'package:sustainibility_project/widgets/navbar/navbar_item.dart';

class AccountNavbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final flightToTrees = Provider.of<FlightToTrees>(context);
    return Container(
      height: 120,
      // width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          NavbarItem(
            'Back',
            () {
              flightToTrees.resetStats();
              Navigator.of(context).pushNamed(HomeView.routeName);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: RoundedButton(
              height: 60,
              width: 170,
              text: Text(
                'Log Out',
                style: Theme.of(context).textTheme.button.merge(
                      TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              ),
              color: CustomColors.brown,
              function: () {
                AuthService().signOut();
                Navigator.of(context).pushNamed(LoginView.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
