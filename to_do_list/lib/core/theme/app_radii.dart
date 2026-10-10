import 'package:flutter/material.dart';

/// Centralized corner radii matching "Radius / Card 16-18 · Control 12 · Small 8 · Pill".
class AppRadii {
  AppRadii._();

  static const double card = 18.0;
  static const double control = 12.0;
  static const double small = 8.0;
  static const double pill = 999.0;

  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(card));
  static const BorderRadius controlRadius = BorderRadius.all(Radius.circular(control));
  static const BorderRadius smallRadius = BorderRadius.all(Radius.circular(small));
  static const BorderRadius pillRadius = BorderRadius.all(Radius.circular(pill));
}
