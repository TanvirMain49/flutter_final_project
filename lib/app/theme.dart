import 'package:_6th_sem_project/core/constants/colors.dart';
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.primary, // all screens
  primaryColor: AppColors.primary,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryDark,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.accent,
  ),
);
