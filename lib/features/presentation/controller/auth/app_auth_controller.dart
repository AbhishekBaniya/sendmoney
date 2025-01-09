import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendmoney/core/utils/bool_manager.dart';
import 'package:sendmoney/core/utils/enums/hive_box_key.dart';
import 'package:sendmoney/features/data/data_source/local_data_source/hive_manager.dart';
import 'package:sendmoney/features/presentation/pages/authentication/app_auth.dart';
import 'package:sendmoney/features/presentation/pages/portfolio_screen.dart';

import '../../../../core/utils/app_logger.dart';
import '../../widgets/widget_controller/checkbox_controller.dart';

class AppAuthController extends GetxController {
  var isSignUp = false.obs;  // Switch between sign-up and sign-in
  var nameController = TextEditingController().obs;
  var userMobileNumberController = TextEditingController().obs;
  var userEmailIdController = TextEditingController().obs;
  var userPasswordController = TextEditingController().obs;
  var confirmPasswordController = TextEditingController().obs;
  final checkboxController = Get.put(CheckboxController());

  //final _auth = FirebaseAuth.instance;
  //late final Rx<User?> firebaseUser;

  @override
  void onInit() {
    super.onInit();
    Logger().info("AppAuthController OnInit() Called");
  }

  @override
  void onReady() {
    super.onReady();
    /*firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
    */Logger().info("AppAuthController onReady() Called");
  }

  @override
  void onClose() {
    super.onClose();
    Logger().info("AppAuthController onClose() Called");
  }

  void toggleAuthMode() {
    isSignUp.value = !isSignUp.value;
  }

  void login(String username, String password) async {
    if (username == '123456' && password == '123456') {
      await HiveManager().putData(HiveBoxName.temp.name, HiveBoxKey.keepMeSignIn.name, true);
      //userBox.put('isLoggedIn', true);
      Get.offAll(() => PortfolioScreen(),);
    } else {
      Get.snackbar('Error', 'Invalid username or password');
    }
  }

  void logout() async{
    await HiveManager().putData(HiveBoxName.temp.name, HiveBoxKey.keepMeSignIn.name, false);
    //userBox.put('isLoggedIn', false);
    Get.offAll(() => AppAuthScreen(),);
  }

  /*_setInitialScreen (User? user) {
    user == null ? Get.offAll(()=>const SignInScreen()) : Get.offAll(()=> PortfolioScreen());
  }

  Future<void> createUserWithPassEmail ({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
    } catch (_) {
    }
  }

  Future<void> loginUserWithPassEmail ({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
    } catch (_) {
    }
  }


  Future<void> loginOutl ({required String email, required String password}) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
    } catch (_) {
    }
  }*/

}
