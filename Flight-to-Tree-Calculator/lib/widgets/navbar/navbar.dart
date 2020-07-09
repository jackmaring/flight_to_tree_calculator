import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sustainibility_project/providers/flight_to_trees.dart';
import 'package:sustainibility_project/services/auth_service.dart';
import 'package:sustainibility_project/styles/custom_colors.dart';
import 'package:sustainibility_project/views/admin_view.dart';
import 'package:sustainibility_project/views/login_view.dart';
import 'package:sustainibility_project/views/profile_view.dart';
import 'package:sustainibility_project/views/signup_view.dart';
import 'package:sustainibility_project/widgets/rounded_button.dart';
import 'package:sustainibility_project/widgets/navbar/navbar_item.dart';

class Navbar extends StatelessWidget {
  final String uid;

  Navbar(this.uid);

  Widget _buildAdminNavbarItem(BuildContext context, String uid) {
    if (uid == 'AjIPI4Komqg3U0kRcm0dMfqTzjt2') {
      return NavbarItem(
        'Admin',
        () {
          Navigator.of(context).pushNamed(AdminView.routeName);
        },
      );
    } else {
      return Container();
    }
  }

  Widget _buildProfileNavbarItem(BuildContext context, String uid) {
    final flightToTrees = Provider.of<FlightToTrees>(context);
    return NavbarItem(
      'Profile',
      () {
        flightToTrees.resetStats();
        Navigator.of(context).pushNamed(ProfileView.routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildAdminNavbarItem(context, uid),
          _buildProfileNavbarItem(context, uid),
          NavbarItem(
            'Login',
            () => Navigator.of(context).pushNamed(LoginView.routeName),
          ),
          NavbarItem(
            'Logout',
            () {
              AuthService().signOut();
              Navigator.of(context).pushNamed(LoginView.routeName);
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
                Navigator.of(context).pushNamed(SignUpView.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
