import 'package:dio/dio.dart';
import 'package:learning_app/core/models/exam_history_model.dart';
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

  Future<Response> submitExam(ExamHistoryModel history) async {
    String url = '/history/submit';

    try {
      final response = await dioClient.post(url, data: history.toJson());
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getHistories() async {
    String url = '/history';

    try {
      final response = await dioClient.get(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getHistory(int historyId, int examId) async {
    String url = '/history/answers';

    try {
      final response = await dioClient.get(
        url,
        queryParameters: {'historyId': historyId, 'examId': examId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getHistoryAnswers(int historyId) async {
    String url = '/history/$historyId/answers';

    try {
      final response = await dioClient.get(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
