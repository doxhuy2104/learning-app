import 'package:dio/dio.dart';
import 'package:learning_app/core/utils/globals.dart';
import 'package:learning_app/core/utils/utils.dart';

class AccountApi {
  final dioClient = Utils.dioClient;
  Future<Response> getGroups() async {
    const String url = '/group';

    try {
      final response = await dioClient.get(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> updateAccount(String? name, int? groupId) async {
    String url = '/user/${Globals.globalUserId}';
    try {
      final response = await dioClient.put(
        url,
        data: {'fullName': name, 'groupId': groupId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAccountInfo() async {
    String url = '/user/me';
    try {
      final response = await dioClient.get(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
