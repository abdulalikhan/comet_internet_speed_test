import 'package:percent_indicator/percent_indicator.dart';
import 'package:comet_internet_speed_test/constants/palette.dart';
import 'package:flutter/material.dart';

class ProgressBar {
  LinearPercentIndicator showBar(double displayPer) {
    return new LinearPercentIndicator(
      width: 300,
      lineHeight: 24.0,
      percent: displayPer / 100.0,
      center: Text(
        displayPer.toStringAsFixed(1) + "%",
        style: new TextStyle(
          fontSize: 14.0,
          color: txtCol,
        ),
      ),
      linearStrokeCap: LinearStrokeCap.roundAll,
      backgroundColor: progressBg,
      progressColor: progressFill,
    );
  }
}
