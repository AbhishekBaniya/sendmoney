import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sendmoney/config/res/colors.dart';

import '../../../config/res/dims.dart';
import '../../../core/utils/enums/hive_box_key.dart';
import '../../data/data_source/local_data_source/hive_manager.dart';
import '../controller/auth/app_auth_controller.dart';
import '../controller/portfolio_controller.dart';
import '../widgets/app_bottom_sheet_widget.dart';
import '../widgets/app_circular_indicator_widget.dart';
import '../widgets/app_text_widget.dart';

class PortfolioScreen extends StatelessWidget {
  PortfolioScreen({super.key});

  final controller = Get.put(PortfolioController(getPortfolio: Get.find()));
  final authController = Get.put(AppAuthController());

  void showCustomDialog(BuildContext context, userName) async {
    var amount = await HiveManager().getData(HiveBoxName.temp.name, userName);
    //print('Abhishek Data ==============> ${amount.val(HiveBoxKey.date.name.tr).key}');
    if (amount != null) {
      //print('Abhishek Data ==============> ${amount}');
      for (var data in amount) {
        print(
            "Abhishek Data ==============> User Name : ${data['name']} Date : ${data['date']}");
        print(
            "Abhishek Data ==============> received Amount : ${data['receivedAmount']} Date : ${data['date']}");
        print(
            "Abhishek Data ==============> Current Balance : ${data['currentBalance']} Date : ${data['date']}");
        print(
            "Abhishek Data ==============> Updated Balance : ${data['updatedBalance']} Date : ${data['date']}");
      }
    } else {
      Get.snackbar('404', 'No Data Found!',
          icon: Icon(Icons.build_circle, color: Colors.red, size: 24));
    }
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Scaffold(
          body: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(40)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 24),
                      child: AppRichTextWidget().buildComplexRichText(
                        textSpans: [
                          TextSpan(text: "Current User : ",),
                          TextSpan(text: "$userName", style: TextStyle(
                            color: ColorManager.primaryTextColor,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w800,),),
                          TextSpan(
                            text: " Transaction History", style: TextStyle(
                            color: ColorManager.primaryTextColor,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w800,),),
                        ],),
                    ),

                    const Expanded(child: SizedBox()),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 24),
                      child: IconButton(onPressed: () {
                        Navigator.pop(context);
                      }, icon: Icon(Icons.close)),
                    ),
                  ],
                ),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(child: RandomColorProgressIndicator(),);
                    } else if (controller.hasError.value) {
                      return const Center(child: Text('Error loading Data'));
                    } else {
                      return ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: amount.length ?? Dim.intZero,
                        itemBuilder: (context, index) {
                          print("Test =========================> $amount");
                          return SizedBox(width: MediaQuery
                              .of(context)
                              .size
                              .width,
                            child: ExpansionTile(
                              title: AppRichTextWidget().buildComplexRichText(
                                textSpans: [
                                  TextSpan(text: "${amount[index]['date']}"),
                                ],),
                              children: [

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AppRichTextWidget()
                                        .buildComplexRichText(textSpans: [
                                      TextSpan(
                                          text: "Name : ${amount[index]['name']}"),
                                    ],),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AppRichTextWidget()
                                        .buildComplexRichText(textSpans: [
                                      TextSpan(
                                          text: "from : ${amount[index]['name']}"),
                                    ],),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AppRichTextWidget()
                                        .buildComplexRichText(textSpans: [
                                      TextSpan(
                                          text: "Current Balance : ${amount[index]['currentBalance']}"),
                                    ],),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AppRichTextWidget()
                                        .buildComplexRichText(textSpans: [
                                      TextSpan(
                                          text: "Received Amount : ${amount[index]['receivedAmount']}"),
                                    ],),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AppRichTextWidget()
                                        .buildComplexRichText(textSpans: [
                                      TextSpan(
                                          text: "New Balance : ${amount[index]['currentBalance']}"),
                                    ],),
                                  ),
                                ),

                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                        const Divider(color: Colors.transparent,),
                      );
                    }
                  }),
                ),
              ],),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(0, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: PreferredSize(preferredSize: Size(MediaQuery
            .of(context)
            .size
            .width, Dim.intEight * 10), child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() =>
                    AppRichTextWidget().buildComplexRichText(textSpans: [
                      TextSpan(text: "Current User : ${authController
                          .userEmailIdController.value.text.trim()}"),
                    ],),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() =>
                  AppRichTextWidget().buildComplexRichText(textSpans: [
                    TextSpan(text: 'Current Account Balance ${controller.balance
                        .value}'),
                  ],),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () async {
                    authController.logout();
                  },
                  child: Icon(Icons.logout)
              ),
            ),

          ],
        ),),
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
                return SizedBox(width: MediaQuery
                    .of(context)
                    .size
                    .width, child: InkWell(onTap: () {
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
                                  onPressed: () async {
                                    Get.back(); // Close the bottom sheet
                                    var amount = await HiveManager().getData(
                                        HiveBoxName.temp.name, item.name);
                                    if (amount != null) {
                                      showCustomDialog(context, item.name);
                                    } else {
                                      Get.snackbar(
                                          '404', 'No Transaction History Found!',
                                          icon: Icon(Icons.build_circle,
                                              color: Colors.red, size: 24));
                                    }
                                  },
                                  child: Text('Transaction History'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    //Get.back(); // Close the bottom sheet
                                    var amount = await HiveManager().getData(
                                        HiveBoxName.temp.name, item.name);
                                    //print('Abhishek Data ==============> ${amount.val(HiveBoxKey.date.name.tr).key}');
                                    if (amount != null) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) =>
                                            AlertDialog(
                                              title: const Text(
                                                  "Current Balance"),
                                              content: Obx(() {
                                                return Visibility(
                                                  visible: controller.isHidden
                                                      .value,
                                                  child: SizedBox(
                                                    height: 150,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        AppRichTextWidget()
                                                            .buildComplexRichText(
                                                          textSpans: [
                                                            TextSpan(
                                                                text: 'Last Balance : ${controller.personAmounts.value[index]}'),
                                                            ],),
                                                        AppRichTextWidget()
                                                            .buildComplexRichText(
                                                          textSpans: [
                                                            TextSpan(
                                                                text: 'New Balance : ${amount[index]['currentBalance']}'),
                                                          ],),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                              actions: [
                                                ElevatedButton( // FlatButton widget is used to make a text to work like a button
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  // function used to perform after pressing the button
                                                  child: Text('CANCEL'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    controller.toggleVisibility();
                                                  },
                                                  child: Text('View'),
                                                ),
                                              ],
                                            ),
                                      );
                                      //print('Abhishek Data ==============> ${amount}');
                                      /*for(var data in amount){
                                        print("Abhishek Data ==============> User Name : ${data['name']} Date : ${data['date']}");
                                        print("Abhishek Data ==============> received Amount : ${data['receivedAmount']} Date : ${data['date']}");
                                        print("Abhishek Data ==============> Current Balance : ${data['currentBalance']} Date : ${data['date']}");
                                        print("Abhishek Data ==============> Updated Balance : ${data['updatedBalance']} Date : ${data['date']}");

                                      }*/

                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) =>
                                            AlertDialog(
                                              title: const Text(
                                                  "Current Balance"),
                                              content: Obx(() {
                                                return Visibility(
                                                  visible: controller.isHidden
                                                      .value,
                                                  child: SizedBox(
                                                    height: 150,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        AppRichTextWidget()
                                                            .buildComplexRichText(
                                                          textSpans: [
                                                            TextSpan(
                                                                text: 'Last Balance : ${controller.personAmounts.value[index]}'),
                                                          ],),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                              actions: [
                                                ElevatedButton( // FlatButton widget is used to make a text to work like a button
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  // function used to perform after pressing the button
                                                  child: Text('CANCEL'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    controller.toggleVisibility();
                                                  },
                                                  child: Text('View'),
                                                ),
                                              ],
                                            ),
                                      );

                                      //Get.snackbar('404', 'No Data Found!', icon: Icon(Icons.build_circle, color: Colors.red, size: 24));
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
                  leading: index == controller.currentIndex
                      ? Icon(Icons.star)
                      : Icon(Icons.star_border),
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
                                decoration: InputDecoration(
                                    labelText: 'Enter Amount'),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  controller.sendMoney(double.parse(
                                      controller.amountController.value.text),
                                      item.name, '123456', index);
                                  controller.amountController.value.clear();
                                  //Navigator.pop(context);
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
              separatorBuilder: (BuildContext context,
                  int index) => const Divider(color: Colors.transparent,),
            );
          }
        }),
      ),
    );
  }
}