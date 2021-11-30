
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppFontStyle {
  AppFontStyle._();

  static const String poppins = "poppins";

  static const TextStyle font12 = TextStyle(
      fontSize: 12
  );
  static final font12Bold = font12.copyWith(fontWeight: FontWeight.bold);
  static const TextStyle font14 = TextStyle(
      fontSize: 14
  );
  static final font14Bold = font14.copyWith(fontWeight: FontWeight.bold);
  static const TextStyle font16 = TextStyle(
      fontSize: 16
  );
  static final font16Bold = font16.copyWith(fontWeight: FontWeight.bold);
  static const TextStyle font18 = TextStyle(
      fontSize: 18
  );
  static final font18Bold = font18.copyWith(fontWeight: FontWeight.bold);
  static const TextStyle font20 = TextStyle(
      fontSize: 20
  );
  static final font20Bold = font20.copyWith(fontWeight: FontWeight.bold);
  static const TextStyle errorTextStyle = TextStyle(
      color: Colors.red,
      fontSize: 14
  );
}