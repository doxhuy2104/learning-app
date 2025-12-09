import 'package:dio/dio.dart';
import 'package:learning_app/core/utils/utils.dart';

class ExamApi {
  final dioClient = Utils.dioClient;
  Future<Response> getExams(int subjectId) async {
    String url = '/course/subject/$subjectId';

    try {
      final response = await dioClient.get(
        url,
        queryParameters: {'isExam': true},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getExamQuestions({
    required int examId,
    required int page,
    required int limit,
  }) async {
    String url = '/question/subject/$examId';

    try {
      final response = await dioClient.get(
        url,
        queryParameters: {'page': page, 'limit': limit},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
