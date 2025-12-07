import 'package:dio/dio.dart';
import 'package:learning_app/core/utils/utils.dart';

class HomeApi {
  final dioClient = Utils.dioClient;
  Future<Response> getSubjects() async {
    const String url = '/subject';

    try {
      final response = await dioClient.get(
        url,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
