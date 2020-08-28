import 'dart:html' as html;

import 'package:flutter/material.dart';

extension HoverExtensions on Widget {
  static final appContainer =
      html.window.document.getElementById('app-container');

  Widget get showCursorOnHover {
    return MouseRegion(
      child: this,
      onHover: (event) {
        return appContainer.style.cursor = 'pointer';
      },
      onExit: (event) {
        return appContainer.style.cursor = 'default';
      },
    );
  }
}
