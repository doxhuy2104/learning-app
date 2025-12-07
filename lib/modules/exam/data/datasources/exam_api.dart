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

  Future<Response> getExam(int examId) async {
     String url = '/question/subject/$subjectId';

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

  
}
