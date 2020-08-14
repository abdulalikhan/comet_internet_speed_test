import 'package:flutter/material.dart';
import 'package:comet_internet_speed_test/constants/palette.dart';

Ink btnInk = Ink(
  decoration: BoxDecoration(
    gradient: buttonGradient,
    borderRadius: BorderRadius.all(Radius.circular(80.0)),
  ),
  child: Container(
    constraints: const BoxConstraints(
        minWidth: 188.0, minHeight: 46.0), // min sizes for Material buttons
    alignment: Alignment.center,
    child: const Text(
      'Start Test',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);
