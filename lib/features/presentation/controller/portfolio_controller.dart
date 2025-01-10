import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendmoney/core/utils/enums/hive_box_key.dart';
import 'package:sendmoney/features/data/data_source/local_data_source/hive_manager.dart';

import '../../../core/utils/app_logger.dart';
import '../../data/model/transactions_model.dart';
import '../../domain/entities/portfolio_entity.dart';
import '../../domain/usecases/get_portfolio.dart';

class PortfolioController extends GetxController {
  PortfolioController({required this.getPortfolio});
  final GetPortfolio getPortfolio;

  var portfolioItems = <PortfolioEntity>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  var currentIndex = -1.obs;
  //var /*List<int> */colorCodes = <int>[50, 100, 200, 300, 400, 500, 600, 700, 800, 900].obs;
  var personAmounts = <double>[5000, 10000, 20000, 30000, 40000, 50000, 60000, 70000, 80000, 90000].obs;
  var amount = 0.0.obs;
  var amountController = TextEditingController().obs;

  var balance = 100000.0.obs;
  var isHidden = false.obs;
  var transactions = <Map<String, dynamic>>[].obs;
  var totalBalance = 0.0.obs;


  @override
  void onInit() async {
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

  void sendMoney(double amount, String userName, String userNameFrom, int index) async {
    if (amount <= 0) {
      Get.snackbar('Error', 'Enter a valid amount');
      return;
    }

    if (amount > balance.value) {
      Get.snackbar('Error', 'Insufficient balance');
      return;
    }

    balance.value -= amount;
    //await HiveManager().putData(HiveBoxName.temp.name, HiveBoxKey.myBalance.name, balance.value -= amount);

    //personAmounts.value[index]+=amount;

    //print('added amount is ===============================> ${personAmounts.value[index]+=amount}');
    transactions.value.add({
      'name':userName,
      'currentBalance': personAmounts.value[index],
      'receivedAmount': amount,
      'updatedBalance': personAmounts.value[index]+amount,
      'date': DateTime.now().toString(),
    });
    await HiveManager().putData(HiveBoxName.temp.name, userName, transactions);
    Get.back();
    Get.snackbar('Success', 'Transaction Successful!', icon: Icon(Icons.check_circle, color: Colors.green, size: 24));
  }
}
