import 'package:flutter/material.dart';

import 'package:sustainibility_project/styles/custom_colors.dart';
import 'package:sustainibility_project/widgets/rounded_button.dart';

class HomePageCategoryRow extends StatelessWidget {
  final String text;
  final String buttonText;
  final Function function;

  HomePageCategoryRow({
    this.text,
    this.buttonText,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          text,
          style: Theme.of(context).textTheme.headline3,
        ),
        SizedBox(width: 60),
        RoundedButton(
          height: 65,
          width: 235,
          text: Text(
            buttonText,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w400
            ),
          ),
          color: CustomColors.brown,
          function: function,
        ),
      ],
    );
  }
}
