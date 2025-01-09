import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendmoney/config/res/colors.dart';

import 'app_text_widget.dart';
import 'widget_controller/checkbox_controller.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CheckboxController.instance;

    return Obx(() {
      return GestureDetector(
        onTap: controller.toggleCheckbox,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: controller.isChecked.value ? ColorManager.accentColor : Colors.transparent,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(4), // Optional for rounded corners
              ),
              child: controller.isChecked.value
                  ? Icon(Icons.check, color: Colors.white, size: 18)
                  : SizedBox.shrink(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppRichTextWidget().buildRichText(text1: 'Keep Me Signed In',),
            )
          ],
        ),
      );
    });
  }
}
