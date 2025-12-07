import 'package:dio/dio.dart';
import 'package:learning_app/core/utils/utils.dart';

class PracticeApi {
  final dioClient = Utils.dioClient;

  Future<Response> getSubjects() async {
    const String url = '/subject';

    try {
      final response = await dioClient.get(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getCourses(int subjectId) async {
    String url = '/course/subject/$subjectId';

    try {
      final response = await dioClient.get(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
