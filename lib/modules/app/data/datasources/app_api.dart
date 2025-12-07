import 'package:dio/dio.dart';
import 'package:learning_app/core/utils/utils.dart';

class AppApi {
  final dioClient = Utils.dioClient;
  Future<Response> getQuesttionsByExamId(
    int examId,
    int page,
    int limit,
  ) async {
    const String url = '/question/exam';

    try {
      final response = await dioClient.get(
        '$url/$examId',
        queryParameters: {'page': page, 'limit': limit},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getExams({int? courseId, int? lessonId}) async {
    String url = '/exam/${courseId != null ? 'course' : 'lesson'}';

    try {
      final response = await dioClient.get('$url/${courseId ?? lessonId}');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
