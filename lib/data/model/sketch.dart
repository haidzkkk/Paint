import 'package:flutter/material.dart';

import '../controller/paint_controller.dart';

class Sketch {
  final List<Offset> points;
  final Color color;
  final double size;
  final OptionPaint optionPaint;

  Sketch({
    required this.points,
    this.color = Colors.black,
    this.size = 10,
    OptionPaint? optionPaint,
  }): optionPaint = optionPaint ?? OptionPaint.draw;
}