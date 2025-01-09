import 'dart:developer';

import 'package:get/get.dart';

import '../../../config/res/colors.dart';
import '../../../core/network/dio_client.dart';
import '../../data/data_source/remote_data_source/portfolio_remote_data_source.dart';
import '../../data/repositories/portfolio_repository_impl.dart';
import '../../domain/usecases/get_portfolio.dart';
import '../controller/auth/app_auth_controller.dart';
import '../controller/dashboard/dashboard_controller.dart';
import '../controller/portfolio_controller.dart';
import '../controller/profile/profile_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies

    /*// Inject DioClient first
    Get.put<DioClient>(DioClient());

    // Inject PortfolioRemoteDataSourceImpl which depends on DioClient
    Get.put<PortfolioRemoteDataSourceImpl>(
      PortfolioRemoteDataSourceImpl(Get.find<DioClient>()),
    );

    // Inject PortfolioRepositoryImpl which depends on PortfolioRemoteDataSourceImpl
    Get.put<PortfolioRepositoryImpl>(
      PortfolioRepositoryImpl(Get.find<PortfolioRemoteDataSourceImpl>()),
    );

    // Inject GetPortfolio which depends on PortfolioRepositoryImpl
    Get.put<GetPortfolio>(
      GetPortfolio(Get.find<PortfolioRepositoryImpl>()),
    );*/

    Get.put(ColorManager());
// Register DioClient first
    Get.lazyPut<DioClient>(() => DioClient());

// Register PortfolioRemoteDataSourceImpl which depends on DioClient
    Get.lazyPut<PortfolioRemoteDataSourceImpl>(() =>
        PortfolioRemoteDataSourceImpl(Get.find<DioClient>())
    );

// Register PortfolioRepositoryImpl which depends on PortfolioRemoteDataSourceImpl
    Get.lazyPut<PortfolioRepositoryImpl>(() =>
        PortfolioRepositoryImpl(Get.find<PortfolioRemoteDataSourceImpl>())
    );

// Register GetPortfolio which depends on PortfolioRepositoryImpl
    Get.lazyPut<GetPortfolio>(() => GetPortfolio(Get.find<PortfolioRepositoryImpl>()));

// Register PortfolioController which depends on GetPortfolio
    Get.lazyPut<PortfolioController>(() => PortfolioController(getPortfolio: Get.find<GetPortfolio>()));


    Get.put(AppAuthController());
    Get.put(ProfileController());
    Get.put(DashboardController());

  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    log('message');
  }
}