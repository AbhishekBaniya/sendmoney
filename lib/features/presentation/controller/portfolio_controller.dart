import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendmoney/core/utils/enums/hive_box_key.dart';
import 'package:sendmoney/features/data/data_source/local_data_source/hive_manager.dart';

import '../../../core/utils/app_logger.dart';
import '../../domain/entities/portfolio_entity.dart';
import '../../domain/usecases/get_portfolio.dart';

class PortfolioController extends GetxController {
  PortfolioController({required this.getPortfolio});
  final GetPortfolio getPortfolio;

  var portfolioItems = <PortfolioEntity>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  var currentIndex = -1.obs;
  var /*List<int> */colorCodes = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900].obs;
  //var amounts = <int>[5000, 10000, 20000, 30000, 40000, 50000, 60000, 70000, 80000, 90000].obs;
  var amount = 0.0.obs;
  var amountController = TextEditingController().obs;

  var balance = 500.0.obs;
  var isHidden = false.obs;
  var transactions = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    fetchPortfolio();
    super.onInit();
    Logger().info("PortfolioController OnInit() Called");
  }

  @override
  void onReady() {
    super.onReady();
    Logger().info("PortfolioController onReady() Called");
  }

  @override
  void onClose() {
    super.onClose();
    Logger().info("PortfolioController onClose() Called");
  }

  void fetchPortfolio() async {
    isLoading(true);
    final result = await getPortfolio();
    result.fold(
          (error) {
        hasError(true);
      },
          (success) {
        portfolioItems.assignAll(success);
      },
    );
    isLoading(false);
  }

  void toggleVisibility() {
    isHidden.value = !isHidden.value;
  }

  void sendMoney(double amount) async {
    if (amount <= 0) {
      Get.snackbar('Error', 'Enter a valid amount');
      return;
    }

    if (amount > balance.value) {
      Get.snackbar('Error', 'Insufficient balance');
      return;
    }

    balance.value -= amount;
    await HiveManager().putMap(HiveBoxName.temp.name, {HiveBoxKey.amount.name : amount, HiveBoxKey.date.name : DateTime.now().toString()});
    transactions.add({
      'amount': amount,
      'date': DateTime.now().toString(),
    });

    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 50),
            Text('Transaction Successful!'),
          ],
        ),
      ),
    );
    Get.back();
  }
}
