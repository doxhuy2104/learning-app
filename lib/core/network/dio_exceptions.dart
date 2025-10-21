import 'package:dio/dio.dart';
// import 'package:ai_image_gen_app_flutter/core/extensions/localized_extension.dart';
import 'package:learning_app/core/constants/app_keys.dart';

class DioExceptions implements Exception {
  late String message;

  DioExceptions.fromDioError(DioException dioException) {
    dynamic error = dioException.response?.data;
    String? reason = error is Map
        ? (error['reason'] as String?)
        : (error is String ? error : null);
    if (reason != null) {
      message = reason;
    } else {
      // message =
      //     AppKeys.navigatorKey.currentContext!.localization.pleaseTryAgain;
    }
  }

  @override
  String toString() => message;
}
