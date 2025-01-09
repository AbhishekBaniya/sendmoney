import 'package:get/get.dart';

import '../../../../core/utils/bool_manager.dart';
import '../../../../core/utils/constants.dart';

class CheckboxController extends GetxController {
  // Singleton instance
  static final CheckboxController instance = Get.put(CheckboxController());

  // Observable checkbox state
  var isChecked = false.obs;

  // Toggle checkbox state
  void toggleCheckbox() {
    isChecked.value = !isChecked.value;
  }
}
