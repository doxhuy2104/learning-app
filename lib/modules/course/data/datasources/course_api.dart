import 'package:dio/dio.dart';
import 'package:learning_app/core/utils/utils.dart';

class CourseApi {
  final dioClient = Utils.dioClient;
  Future<Response> getCourses() async {
    const String url = '/auth/login';

    try {
      final response = await dioClient.post(
        url,
        options: Options(extra: {"noAuth": true}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

}
