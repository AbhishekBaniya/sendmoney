import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoundedBottomSheet {
  // Private constructor for Singleton pattern
  RoundedBottomSheet._internal();

  // Static instance of the class
  static final RoundedBottomSheet _instance = RoundedBottomSheet._internal();

  // Getter for accessing the singleton instance
  factory RoundedBottomSheet() => _instance;

  // Method to display the bottom sheet
  void show({
    required Widget content,
    Color? backgroundColor,
    double radius = 16.0,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    Get.bottomSheet(
      Container(
        width: MediaQuery.of(Get.context!).size.width,
        decoration: BoxDecoration(
          color: backgroundColor ?? Get.theme.bottomSheetTheme.backgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radius),
          ),
        ),
        child: content,
      ),
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent, // Ensure background is transparent
    );
  }
}
