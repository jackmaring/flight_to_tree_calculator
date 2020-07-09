import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:sustainibility_project/views/home_view.dart';

class AuthService {
  // Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  // Log in user
  void login(BuildContext context, String email, String password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) {
      if (user != null) {
        Navigator.of(context).pushNamed(HomeView.routeName);
      } else {
        print('oops');
      }
    }).catchError((e) {
      print(e);
    });
  }

  // Create new user
  void createUser(BuildContext context, String email, String password) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user) {
      if (user != null) {
        Navigator.of(context).pushNamed(HomeView.routeName);
      } else {
        print('oops');
      }
    }).catchError((e) {
      print(e);
    });
  }
}
