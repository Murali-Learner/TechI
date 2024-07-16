import 'package:flutter/material.dart';

extension ScreenConfigExtension on num {
  Widget get vSpace => SizedBox(
        height: toDouble(),
      );
  Widget get hSpace => SizedBox(
        width: toDouble(),
      );
}
