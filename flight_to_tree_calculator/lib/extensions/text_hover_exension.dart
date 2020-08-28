import 'dart:html' as html;

import 'package:flutter/material.dart';

extension TextHoverExtension on Widget {
  static final appContainer =
      html.window.document.getElementById('app-container');

  Widget get showTextCursorOnHover {
    return MouseRegion(
      child: this,
      onHover: (event) {
        return appContainer.style.cursor = 'text';
      },
      onExit: (event) {
        return appContainer.style.cursor = 'default';
      },
    );
  }
}