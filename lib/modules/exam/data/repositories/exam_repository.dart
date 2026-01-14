import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:learning_app/core/models/course_model.dart';
import 'package:learning_app/core/models/exam_history_model.dart';
import 'package:learning_app/core/models/exam_model.dart';
import 'package:learning_app/core/models/question_model.dart';
import 'package:learning_app/core/models/user_answer_model.dart';
import 'package:learning_app/core/network/dio_exceptions.dart';
import 'package:learning_app/core/network/dio_failure.dart';
import 'package:learning_app/modules/exam/data/datasources/exam_api.dart';

class ExamRepository {
  final ExamApi api;

  ExamRepository({required this.api});

  // Future<Either<DioFailure, List<CourseModel>>> getExams({
  //   required int subjectId,
  // }) async {
  //   try {
  //     final response = await api.getExams(subjectId);

  //     final List<CourseModel> exams = (response.data as List<dynamic>)
  //         .map(
  //           (e) =>
  //               CourseModel.fromJson(e as Map<String, dynamic>) as CourseModel,
  //         )
  //         .toList();
  //     return Right(exams);
  //   } on DioException catch (e) {
  //     final reason = DioExceptions.fromDioError(e).toString();
  //     final statusCode = e.response?.statusCode.toString() ?? '';
  //     return Left(ApiFailure(reason: reason, statusCode: statusCode));
  //   } catch (e) {
  //     return Left(ApiFailure(reason: e.toString(), statusCode: '400'));
  //   }
  // }

   Future<Either<DioFailure, List<ExamModel>>> getExams({
    required int subjectId,
  }) async {
    try {
      final response = await api.getExams(subjectId);

      final List<ExamModel> exams = (response.data as List<dynamic>)
          .map(
            (e) =>
                ExamModel.fromJson(e as Map<String, dynamic>) as ExamModel,
          )
          .toList();
      return Right(exams);
    } on DioException catch (e) {
      final reason = DioExceptions.fromDioError(e).toString();
      final statusCode = e.response?.statusCode.toString() ?? '';
      return Left(ApiFailure(reason: reason, statusCode: statusCode));
    } catch (e) {
      return Left(ApiFailure(reason: e.toString(), statusCode: '400'));
    }
  }


  Future<Either<DioFailure, List<QuestionModel>>> getExamQuestions({
    required int examId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await api.getExamQuestions(
        examId: examId,
        page: page,
        limit: limit,
      );

      final List<QuestionModel> questions = (response.data as List<dynamic>)
          .map(
            (e) =>
                QuestionModel.fromJson(e as Map<String, dynamic>)
                    as QuestionModel,
          )
          .toList();
      return Right(questions);
    } on DioException catch (e) {
      final reason = DioExceptions.fromDioError(e).toString();
      final statusCode = e.response?.statusCode.toString() ?? '';
      return Left(ApiFailure(reason: reason, statusCode: statusCode));
    } catch (e) {
      return Left(ApiFailure(reason: e.toString(), statusCode: '400'));
    }
  }

  Future<Either<DioFailure, ExamHistoryModel?>> submitExam({
    required ExamHistoryModel history,
  }) async {
    try {
      final response = await api.submitExam(history);

      final ExamHistoryModel? historyRespone = ExamHistoryModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Right(historyRespone);
    } on DioException catch (e) {
      final reason = DioExceptions.fromDioError(e).toString();
      final statusCode = e.response?.statusCode.toString() ?? '';
      return Left(ApiFailure(reason: reason, statusCode: statusCode));
    } catch (e) {
      return Left(ApiFailure(reason: e.toString(), statusCode: '400'));
    }
  }

  Future<Either<DioFailure, Map<String, dynamic>>> getHistories({
    int page = 1,
    int limit = 5,
  }) async {
    try {
      final response = await api.getHistories();
      final total = response.data['total'];
      final List<ExamHistoryModel> histories =
          (response.data['data'] as List<dynamic>)
              .map(
                (e) =>
                    ExamHistoryModel.fromJson(e as Map<String, dynamic>)
                        as ExamHistoryModel,
              )
              .toList();
      return Right({'total': total, 'data': histories});
    } on DioException catch (e) {
      final reason = DioExceptions.fromDioError(e).toString();
      final statusCode = e.response?.statusCode.toString() ?? '';
      return Left(ApiFailure(reason: reason, statusCode: statusCode));
    } catch (e) {
      return Left(ApiFailure(reason: e.toString(), statusCode: '400'));
    }
  }

  Future<Either<DioFailure, Map<String, dynamic>>> getHistory({
    required int historyId,
    required int examId,
  }) async {
    try {
      final response = await api.getHistory(historyId, examId);
      final List<QuestionModel> questions =
          (response.data['questions'] as List<dynamic>)
              .map(
                (e) =>
                    QuestionModel.fromJson(e as Map<String, dynamic>)
                        as QuestionModel,
              )
              .toList();
      final List<UserAnswerModel> userAnswers =
          (response.data['userAnswers'] as List<dynamic>)
              .map(
                (e) =>
                    UserAnswerModel.fromJson(e as Map<String, dynamic>)
                        as UserAnswerModel,
              )
              .toList();

      final Map<int, UserAnswerModel> userAnswersMap = {
        for (final answer in userAnswers)
          if (answer.questionOrderIndex != null)
            answer.questionOrderIndex!: answer,
      };

      return Right({'questions': questions, 'userAnswers': userAnswersMap});
    } on DioException catch (e) {
      final reason = DioExceptions.fromDioError(e).toString();
      final statusCode = e.response?.statusCode.toString() ?? '';
      return Left(ApiFailure(reason: reason, statusCode: statusCode));
    } catch (e) {
      return Left(ApiFailure(reason: e.toString(), statusCode: '400'));
    }
  }

  Future<Either<DioFailure, Map<int, UserAnswerModel>>> getHistoryAnswers({
    required int historyId,
  }) async {
    try {
      final response = await api.getHistoryAnswers(historyId);
      final List<UserAnswerModel> userAnswersList =
          (response.data['data'] as List<dynamic>)
              .map(
                (e) =>
                    UserAnswerModel.fromJson(e as Map<String, dynamic>)
                        as UserAnswerModel,
              )
              .toList();

      final Map<int, UserAnswerModel> userAnswersMap = {
        for (final answer in userAnswersList)
          if (answer.questionOrderIndex != null)
            answer.questionOrderIndex!: answer,
      };

      return Right(userAnswersMap);
    } on DioException catch (e) {
      final reason = DioExceptions.fromDioError(e).toString();
      final statusCode = e.response?.statusCode.toString() ?? '';
      return Left(ApiFailure(reason: reason, statusCode: statusCode));
    } catch (e) {
      return Left(ApiFailure(reason: e.toString(), statusCode: '400'));
    }
  }
}
