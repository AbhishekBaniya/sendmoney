import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendmoney/features/presentation/pages/authentication/app_auth.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/enums/hive_box_key.dart';
import '../../../data/data_source/local_data_source/hive_manager.dart';
import '../../app_routes/app_navigators.dart';
import '../../app_routes/app_routes.dart';
import '../../pages/portfolio_screen.dart';
import '../../widgets/widget_controller/checkbox_controller.dart';

class AppAuthController extends GetxController {
  var isSignUp = true.obs;  // Switch between sign-up and sign-in
  var nameController = TextEditingController().obs;
  var userMobileNumberController = TextEditingController().obs;
  var userEmailIdController = TextEditingController().obs;
  var userPasswordController = TextEditingController().obs;
  var confirmPasswordController = TextEditingController().obs;
  final checkboxController = Get.put(CheckboxController());
  var isLoggedIn = true.obs;
  var credentials = <Map<String, dynamic>>[].obs;

  //final _auth = FirebaseAuth.instance;
  //late final Rx<User?> firebaseUser;

  @override
  void onInit() async {
    super.onInit();
    Logger().info("AppAuthController OnInit() Called");
    if(!isLoggedIn.value){
    isLoggedIn.value = await HiveManager().getData(HiveBoxName.temp.name, HiveBoxKey.keepMeSignIn.name);
    if(isLoggedIn.value !=null){
      isLoggedIn.value == true ? AppNavigator().navigateToAndRemoveAll(AppRoutes.home) : SizedBox.shrink();
    }
  }}

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
   var matchedUserEmail = await HiveManager().getData(HiveBoxName.temp.name, HiveBoxKey.email.name,);
   var matchedUserPassword = await HiveManager().getData(HiveBoxName.temp.name, HiveBoxKey.password.name,);
   print("Abhishek ===================================> ${matchedUserEmail}");
    if(matchedUserEmail != null || matchedUserPassword != null){
      if (username == matchedUserEmail && password == matchedUserPassword) {
        await HiveManager().putData(HiveBoxName.temp.name, HiveBoxKey.keepMeSignIn.name, true);
        //userBox.put('isLoggedIn', true);
        //Get.offAll(() => PortfolioScreen(),);
        //Get.toNamed(AppRoutes.home,);
        Navigator.pushReplacement(
          Get.context!,
          MaterialPageRoute(builder: (context) => PortfolioScreen()),
        );
      } else {
        await HiveManager().putData(HiveBoxName.temp.name, HiveBoxKey.keepMeSignIn.name, false);
        Get.snackbar('Error', 'Invalid username or password');
      }
    }else {
      Get.snackbar('Error', 'Please Register First', icon: Icon(Icons.person, color: Colors.red, size: 24));
    }
  }

  void logout() async{
    await HiveManager().putData(HiveBoxName.temp.name, HiveBoxKey.keepMeSignIn.name, credentials);
    //userBox.put('isLoggedIn', false);
    //Get.offAllNamed(() => AppAuthScreen(),);
    //Get.to(()=> AppAuthScreen());
    //AppNavigator().navigateTo(AppRoutes.login);
    Navigator.pushReplacement(
      Get.context!,
      MaterialPageRoute(builder: (context) => AppAuthScreen()),
    );
  }


  void saveData({required name, required mobile, required email, required password, required confirmPassword}) async{
    await HiveManager().putData(HiveBoxName.temp.name, HiveBoxKey.name.name, name);
    await HiveManager().putData(HiveBoxName.temp.name, HiveBoxKey.mobile.name, mobile);
    await HiveManager().putData(HiveBoxName.temp.name, HiveBoxKey.email.name, email);
    await HiveManager().putData(HiveBoxName.temp.name, HiveBoxKey.password.name, password);
    isSignUp.value = false;
  }

  void getData() async{
    if(await HiveManager().getData(HiveBoxName.temp.name, HiveBoxKey.name.name,) != null || await HiveManager().getData(HiveBoxName.temp.name, HiveBoxKey.mobile.name,) != null || await HiveManager().getData(HiveBoxName.temp.name, HiveBoxKey.email.name,) != null || await HiveManager().getData(HiveBoxName.temp.name, HiveBoxKey.password.name,) != null){

    } /**/
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
