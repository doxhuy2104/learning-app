import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:learning_app/core/models/exam_model.dart';
import 'package:learning_app/core/models/question_model.dart';
import 'package:learning_app/core/network/dio_exceptions.dart';
import 'package:learning_app/core/network/dio_failure.dart';
import 'package:learning_app/modules/app/data/datasources/app_api.dart';

class AppRepository {
  final AppApi api;

  AppRepository({required this.api});
  Future<Either<DioFailure, List<QuestionModel>>> getQuesttionsByExamId(
    {required int examId,
    int page = 1,
    int limit=100,}
  ) async {
    try {
      final response = await api.getQuesttionsByExamId(examId, page, limit);

      final List<QuestionModel> questions =
          (response.data['data'] as List<dynamic>)
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

  
  Future<Either<DioFailure, List<ExamModel>>> getExams({int? courseId,int? lessonId}) async {
    try {
      final response = await api.getExams(courseId: courseId,lessonId: lessonId);

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
}
