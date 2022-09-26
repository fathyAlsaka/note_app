import 'package:flutter/material.dart';
import '../../config/app_colors.dart';

AppBar appBarWidget(){
  return AppBar(
    backgroundColor: AppColors.appBarHeader,
    centerTitle: true,
    leading: Container(),
    title: Text(
      "Notes",
      style: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    ),
  );
}
