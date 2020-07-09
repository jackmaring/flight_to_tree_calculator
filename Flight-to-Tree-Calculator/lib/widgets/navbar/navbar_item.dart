import 'package:flutter/material.dart';

class NavbarItem extends StatelessWidget {
  final String text;
  final Function function;

  NavbarItem(this.text, this.function);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60),
      child: GestureDetector(
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        onTap: function,
      ),
    );
  }
}
