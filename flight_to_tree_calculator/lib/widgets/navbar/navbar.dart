import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sustainibility_project/providers/flight_to_trees.dart';
import 'package:sustainibility_project/routing_constants.dart';
import 'package:sustainibility_project/services/auth_service.dart';
import 'package:sustainibility_project/styles/custom_colors.dart';
import 'package:sustainibility_project/widgets/rounded_button.dart';
import 'package:sustainibility_project/widgets/navbar/navbar_item.dart';

class Navbar extends StatelessWidget {
  Widget _buildAdminNavbarItem(BuildContext context, FirebaseUser user) {
    if (user != null) {
      if (user.uid == '119Zgd4lvth3wUSZlLRmAmPip3i1') {
        return NavbarItem(
          'Admin',
          () {
            Navigator.of(context).pushNamed(AdminViewRoute);
          },
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final flightToTrees = Provider.of<FlightToTrees>(context);
    return Container(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildAdminNavbarItem(context, user),
          NavbarItem(
            'Profile',
            user != null
                ? () {
                    flightToTrees.resetStats();
                    Navigator.of(context).pushNamed(ProfileViewRoute);
                  }
                : () {
                    Navigator.of(context).pushNamed(LoginViewRoute);
                  },
          ),
          NavbarItem(
            'Login',
            () => Navigator.of(context).pushNamed(LoginViewRoute),
          ),
          NavbarItem(
            'Logout',
            () {
              AuthService().signOut();
              Navigator.of(context).pushNamed(LoginViewRoute);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: RoundedButton(
              height: 60,
              width: 170,
              text: Text(
                'Sign Up',
                style: Theme.of(context).textTheme.button.merge(
                      TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              ),
              color: CustomColors.brown,
              function: () {
                Navigator.of(context).pushNamed(SignUpViewRoute);
              },
            ),
          ),
        ],
      ),
    );
  }
}
