import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:learning_app/core/models/course_model.dart';
import 'package:learning_app/core/models/exam_model.dart';
import 'package:learning_app/core/models/question_model.dart';
import 'package:learning_app/core/network/dio_exceptions.dart';
import 'package:learning_app/core/network/dio_failure.dart';
import 'package:learning_app/modules/exam/data/datasources/exam_api.dart';

class ExamRepository {
  final ExamApi api;

  ExamRepository({required this.api});

  Future<Either<DioFailure, List<CourseModel>>> getExams({
    required int subjectId,
  }) async {
    try {
      final response = await api.getExams(subjectId);

      final List<CourseModel> exams = (response.data as List<dynamic>)
          .map(
            (e) =>
                CourseModel.fromJson(e as Map<String, dynamic>) as CourseModel,
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
}
