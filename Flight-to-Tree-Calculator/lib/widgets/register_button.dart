import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final String text;
  final Function function;

  RegisterButton({this.text, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          height: 45,
          width: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
        onTap: function,
      );
  }
}
