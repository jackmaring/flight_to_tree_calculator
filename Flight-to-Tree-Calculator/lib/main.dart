import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sustainibility_project/providers/admin.dart';
import 'package:sustainibility_project/services/airports_service.dart';
import 'package:sustainibility_project/providers/flight_to_trees.dart';
import 'package:sustainibility_project/providers/profile.dart';
import 'package:sustainibility_project/root.dart';
import 'package:sustainibility_project/services/crud_models/admin_crud_model.dart';
import 'package:sustainibility_project/services/crud_models/profile_crud_model.dart';
import 'package:sustainibility_project/styles/custom_colors.dart';
import 'package:sustainibility_project/views/admin_view.dart';
import 'package:sustainibility_project/views/home_view.dart';
import 'package:sustainibility_project/views/login_view.dart';
import 'package:sustainibility_project/views/profile_view.dart';
import 'package:sustainibility_project/views/signup_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Airports _airports = Airports();
  final ProfileCRUDModel _profileEntryDb = ProfileCRUDModel();
  final AdminCRUDModel _adminEntryDb = AdminCRUDModel();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: FirebaseAuth.instance.onAuthStateChanged,
        ),
        FutureProvider(
          create: (context) => _airports.loadAirportsList(),
        ),
        StreamProvider(
          create: (context) => _profileEntryDb.getProfileEntries(),
        ),
        StreamProvider(
          create: (context) => _adminEntryDb.getAdminEntries(),
        ),
        ChangeNotifierProvider(
          create: (_) => FlightToTrees(),
        ),
        ChangeNotifierProvider(
          create: (_) => Profile(),
        ),
        ChangeNotifierProvider(
          create: (_) => Admin(),
        ),
      ],
      child: MaterialApp(
        title: 'Sustainibility Project',
        theme: ThemeData(
          primaryColor: CustomColors.green,
          accentColor: CustomColors.lightGreen,
          fontFamily: 'Rubik',
          textTheme: TextTheme(
            headline1: TextStyle(
              fontSize: 72,
              color: CustomColors.darkGray,
              fontWeight: FontWeight.w500,
            ),
            headline2: TextStyle(
              fontSize: 48,
              color: CustomColors.darkGray,
              fontWeight: FontWeight.w500,
            ),
            headline3: TextStyle(
              fontSize: 36,
              color: CustomColors.darkGray,
              fontWeight: FontWeight.w500,
            ),
            headline4: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            headline5: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            bodyText1: TextStyle(
              fontSize: 18,
              color: CustomColors.darkGray,
              fontWeight: FontWeight.w500,
            ),
            bodyText2: TextStyle(
              fontSize: 16,
              color: CustomColors.darkGray,
              fontWeight: FontWeight.w300,
            ),
            button: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        home: RootPage(),
        routes: {
          HomeView.routeName: (ctx) => HomeView(),
          AdminView.routeName: (ctx) => AdminView(),
          ProfileView.routeName: (ctx) => ProfileView(),
          LoginView.routeName: (ctx) => LoginView(),
          SignUpView.routeName: (ctx) => SignUpView(),
        },
      ),
    );
  }
}
