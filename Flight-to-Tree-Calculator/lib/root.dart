import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sustainibility_project/views/home_view.dart';
import 'package:sustainibility_project/views/login_view.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    if (user == null) {
      return LoginView();
    } else {
      return HomeView();
    }
  }
}
