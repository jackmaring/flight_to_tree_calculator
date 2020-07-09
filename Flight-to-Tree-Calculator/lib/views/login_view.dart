import 'package:flutter/material.dart';

import 'package:sustainibility_project/services/auth_service.dart';
import 'package:sustainibility_project/styles/custom_colors.dart';
import 'package:sustainibility_project/views/signup_view.dart';
import 'package:sustainibility_project/widgets/register_button.dart';

class LoginView extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  String email, password;

  checkFields() {
    final form = _formKey.currentState;
    if (form.validate()) {
      return true;
    } else {
      print('login returned false');
      return false;
    }
  }

  String validateEmail(String value) {
    Pattern pattern = r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        color: CustomColors.registerBackground,
        child: Form(
          key: _formKey,
          child: Center(
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  left: 325,
                  bottom: 130,
                  child: Image.asset(
                    'assets/images/heartgirl.png',
                    height: 355,
                    width: 425,
                  ),
                ),
                Positioned(
                  top: 230,
                  right: 330,
                  child: Image.asset(
                    'assets/images/girlwalking.png',
                    height: 335,
                    width: 535,
                  ),
                ),
                Container(
                  height: 460,
                  width: 400,
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
                          'Login to Account',
                          style: TextStyle(
                            fontSize: 24,
                            color: CustomColors.darkGray,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 45, left: 45, right: 45),
                        child: Container(
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
                              color: CustomColors.darkGray,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 15),
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: CustomColors.mediumGray,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) => value.isEmpty
                                ? 'Email is required'
                                : validateEmail(value.trim()),
                            onChanged: (value) {
                              this.email = value;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 45, right: 45),
                        child: Container(
                          height: 45,
                          width: 300,
                          decoration: BoxDecoration(
                            color: CustomColors.lightGray,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: TextFormField(
                            obscureText: true,
                            cursorColor: CustomColors.darkGray,
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColors.darkGray,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 15),
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: CustomColors.mediumGray,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) =>
                                value.isEmpty ? 'Password is required' : null,
                            onChanged: (value) {
                              this.password = value;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 45, right: 45),
                        child: RegisterButton(
                          text: 'LOGIN',
                          function: () {
                            if (checkFields()) {
                              AuthService().login(context, email, password);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text(
                          'Dont have an account yet?',
                          style: TextStyle(
                            fontSize: 14,
                            color: CustomColors.darkGray,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          child: Text(
                            'Click here to sign up!',
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColors.mediumGray,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(SignUpView.routeName);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
