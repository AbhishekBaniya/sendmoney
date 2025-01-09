import 'package:get/get.dart';

import '../../../../core/utils/app_logger.dart';

class ProfileController extends GetxController {
  //AppAuthController({required this.getPortfolio});
  //final GetPortfolio getPortfolio;

  @override
  void onInit() {
    super.onInit();
    Logger().info("ProfileController OnInit() Called");
  }

  @override
  void onReady() {
    super.onReady();
    Logger().info("ProfileController onReady() Called");
  }

  @override
  void onClose() {
    super.onClose();
    Logger().info("ProfileController onClose() Called");
  }
}
