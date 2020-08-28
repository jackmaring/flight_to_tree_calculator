import 'package:flutter/material.dart';

import 'package:sustainibility_project/extensions/string_extensions.dart';
import 'package:sustainibility_project/routing_constants.dart';
import 'package:sustainibility_project/views/admin_view.dart';
import 'package:sustainibility_project/views/home_view.dart';
import 'package:sustainibility_project/views/login_view.dart';
import 'package:sustainibility_project/views/profile_view.dart';
import 'package:sustainibility_project/views/signup_view.dart';
import 'package:sustainibility_project/views/undefined_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  var routingData = settings.name.getRoutingData;
  switch (routingData.route) {
    case HomeViewRoute:
      // return MaterialPageRoute(builder: (context) => HomeView());
      return _getPageRoute(HomeView(), settings);
    case LoginViewRoute:
      return _getPageRoute(LoginView(), settings);
    case SignUpViewRoute:
      return _getPageRoute(SignUpView(), settings);
    case ProfileViewRoute:
      return _getPageRoute(ProfileView(), settings);
    case AdminViewRoute:
      return _getPageRoute(AdminView(), settings);
    default:
      return _getPageRoute(UndefinedView(), settings);
    // return MaterialPageRoute(
    //   builder: (context) => UndefinedView(
    //     name: settings.name,
    //   ),
    // );
  }
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  _FadeRoute({this.child, this.routeName})
      : super(
            settings: RouteSettings(name: routeName),
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                child,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                FadeTransition(
                  opacity: animation,
                  child: child,
                ));
}
