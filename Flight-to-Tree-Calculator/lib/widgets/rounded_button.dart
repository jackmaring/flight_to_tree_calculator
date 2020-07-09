import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final double height;
  final double width;
  final Text text;
  final Color color;
  final Function function;

  RoundedButton({
    this.height,
    this.width,
    this.text,
    this.color,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(height),
        ),
        child: InkWell(
          child: Center(
            child: text,
          ),
        ),
      ),
      onTap: function,
    );
  }
}
