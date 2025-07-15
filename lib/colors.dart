import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFE1FAF2),
  100: Color(0xFFB3F3E0),
  200: Color(0xFF81EBCB),
  300: Color(0xFF4EE2B6),
  400: Color(0xFF28DCA6),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFF02D18E),
  700: Color(0xFF01CC83),
  800: Color(0xFF01C679),
  900: Color(0xFF01BC68),
});
const int _primaryPrimaryValue = 0xFF02D696;

const MaterialColor primaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFFE5FFF2),
  200: Color(_primaryAccentValue),
  400: Color(0xFF7FFFBE),
  700: Color(0xFF65FFB1),
});
const int _primaryAccentValue = 0xFFB2FFD8;

class AppColors {
  final unscheduled = const Color(0xff03C0C0);
  final rescheduled = const Color(0xffFFC531);
}