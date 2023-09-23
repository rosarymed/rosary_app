import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rosary/controllers/bugFeedback_controller.dart';
import 'package:rosary/controllers/feed_controller.dart';
import 'package:rosary/controllers/langauge_controller.dart';
import 'package:rosary/controllers/network_controller.dart';
import 'package:rosary/controllers/prayer_request_controller.dart';
import 'package:rosary/data/repository/bugFeedback_repo.dart';
import 'package:rosary/data/repository/feedComment_repo.dart';
import 'package:rosary/data/repository/feed_repo.dart';
import 'package:rosary/data/repository/prayer_request_repo.dart';
import 'package:rosary/model/feed_model.dart';
import 'package:rosary/model/language_model.dart';
import 'package:rosary/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/audio_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/feedComment_controller.dart';
import '../controllers/main_controller.dart';
import '../controllers/prayer_controller.dart';
import '../controllers/user_controller.dart';
import '../data/api/api_client.dart';
import '../data/repository/audio_repo.dart';
import '../data/repository/auth_repo.dart';
import '../data/repository/main_repo.dart';
import '../data/repository/prayer_repo.dart';
import '../data/repository/user_repo.dart';

Future<Map<String, Map<String, String>>> init() async {
  final sharePreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => sharePreferences);
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstant.BASE_URL, sharedPreferences: Get.find()));

  //Repos
  //Get.lazyPut(() => AccountRepo(apiClient: Get.find()));
  // Get.lazyPut(() => PopularProductRepo(apiClient: Get.find()));
  // Get.lazyPut(() => RecommendedProductRepo(apiClient: Get.find()));
  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() =>
      BugFeedbackRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut(
      () => MainRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(
      () => FeedRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() =>
      PrayerRequestRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() =>
      FeedCommentRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(
      () => PrayerRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(
      () => AudioRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  // Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  // Get.lazyPut(() => CourierRepo(apiClient: Get.find()));
  // Get.lazyPut(
  //     () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  //controllers
  // Get.lazyPut(() => PopularProductController(popularProductRepo: Get.find()));
  // Get.lazyPut(
  //     () => RecommendedProductController(recommendedProductRepo: Get.find()));

  Get.lazyPut(() =>
      FeedController(feedRepo: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => FeedCommentController(feedCommentRepo: Get.find()));
  Get.lazyPut(() => PrayerController(prayerRepo: Get.find()));
  Get.lazyPut(() => MainController(mainRepo: Get.find()));
  Get.lazyPut(() => BugFeedbackController(
      bugFeedbackRepo: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => PrayerRequestController(prayerRequestRepo: Get.find()));
  Get.lazyPut(() => AudioController(audioRepo: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() =>
      UserController(userRepo: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => NetworkController());
  Map<String, Map<String, String>> _languages = Map();
  for (LanguageModel languageModel in AppConstant.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> _mappedJson = json.decode(jsonStringValues);
    Map<String, String> _json = Map();
    _mappedJson.forEach((key, value) {
      print(value);
      print("Mapped json");
      _json[key] = value.toString();
    });
    _languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        _json;
  }
  return _languages;
}