import 'package:flutter/material.dart';
import 'package:comet_internet_speed_test/constants/palette.dart';

Text showLabel(String label, double speed, String unit) {
  return Text(
    '$label Speed: $speed $unit',
    style: TextStyle(
      color: txtCol,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  );
}
