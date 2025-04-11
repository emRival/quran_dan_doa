 import 'dart:ui';

import 'package:flutter/material.dart';

SnackBar snack({required String text, required Color bg}) {
    return SnackBar(
      content: Text(text),
      backgroundColor: bg,
    );
  }