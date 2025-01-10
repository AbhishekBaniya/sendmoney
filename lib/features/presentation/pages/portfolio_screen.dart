import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sendmoney/core/utils/enums/hive_box_key.dart';
import 'package:sendmoney/features/data/data_source/local_data_source/hive_manager.dart';

import '../controller/portfolio_controller.dart';
import '../widgets/app_bottom_sheet_widget.dart';
import '../widgets/app_circular_indicator_widget.dart';
import '../widgets/app_text_widget.dart';

class PortfolioScreen extends StatelessWidget {
  PortfolioScreen({super.key});

  final controller = Get.put(PortfolioController(getPortfolio: Get.find()));

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Portfolio'), centerTitle: false, actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(()=> AppRichTextWidget().buildComplexRichText(textSpans: [
              TextSpan(text: 'Current Account Balance ${controller.balance.value}'),
            ],),
          ),
        ),
      ],),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: RandomColorProgressIndicator(),);
        } else if (controller.hasError.value) {
          return const Center(child: Text('Error loading Data'));
        } else {
          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: controller.portfolioItems.length,
            itemBuilder: (context, index) {
              final item = controller.portfolioItems[index];
              return  SizedBox(width: MediaQuery.of(context).size.width, child: InkWell(onTap: (){
                controller.currentIndex = index;

                RoundedBottomSheet().show(
                  content: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transaction Details',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                 // Get.back(); // Close the bottom sheet
                                },
                                child: Text('Transaction History'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                 // Get.back(); // Close the bottom sheet
                                  var amount = await HiveManager().getData(HiveBoxName.temp.name, item.name);
                                  //print('Abhishek Data ==============> ${amount.val(HiveBoxKey.date.name.tr).key}');
                                  if(amount != null ){
                                    print('Abhishek Data ==============> ${amount}');
                                    for(var data in amount){
                                      print("Abhishek Data ==============> Amount : ${data['amount']} Date : ${data['date']}");

                                    }

                                  } else {
                                    Get.snackbar('404', 'No Data Found!', icon: Icon(Icons.build_circle, color: Colors.red, size: 24));
                                  }
                                },
                                child: Text('View Balance'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: Colors.white,
                  radius: 20.0,
                );

              }, child: ListTile(
                leading: index == controller.currentIndex ? Icon(Icons.star) : Icon(Icons.star_border),
                title: AppRichTextWidget().buildComplexRichText(textSpans: [
                  TextSpan(text: 'Entry ${item.name}'),
                ],),
                trailing: ElevatedButton(
                  onPressed: () {
                  //Get.back(); // Close the bottom sheet
                  RoundedBottomSheet().show(
                  content: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         TextField(
                           inputFormatters: [
                             FilteringTextInputFormatter.digitsOnly
                           ],
                           controller: controller.amountController.value,
                           keyboardType: TextInputType.number,
                           decoration: InputDecoration(labelText: 'Enter Amount'),
                         ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            controller.sendMoney(double.parse(controller.amountController.value.text), item.name, index);
                            },
                          child: Text('Submit'),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  backgroundColor: Colors.white,
                  radius: 20.0,
                );
                },
                child: Text('Send Money'),
              ),),),);
              /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton( onPressed: (){},
                      //color: Colors.amber[colorCodes[index]],
                      child: AppRichTextWidget().buildComplexRichText(textSpans: [TextSpan(text: 'Entry ${item.name}')],),
                    ),
                  ],
                );*/
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent,),
          );
        }
      }),
    );
  }
}