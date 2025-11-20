import 'package:dio/dio.dart';
import 'package:learning_app/core/utils/utils.dart';

class AuthApi {
  final dioClient = Utils.dioClient;
  Future<Response> loginByIdToken({
    required String idToken,
    String? type,  }) async {
    const String url = '/auth/login';
    final params = {"idToken": idToken, "type": type};

    try {
      final response = await dioClient.post(
        url,
        data: params,
        options: Options(extra: {"noAuth": true}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

   Future<Response> signUp({
    required String idToken,
     required String name,  }) async {
    const String url = '/auth/register';
    final params = {"idToken": idToken, "fullName": name};

    try {
      final response = await dioClient.post(
        url,
        data: params,
        options: Options(extra: {"noAuth": true}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
