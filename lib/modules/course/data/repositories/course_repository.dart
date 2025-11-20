import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:learning_app/core/models/user_model.dart';
import 'package:learning_app/core/network/dio_exceptions.dart';
import 'package:learning_app/core/network/dio_failure.dart';
import 'package:learning_app/modules/course/data/datasources/course_api.dart';

class CourseRepository {
  final CourseApi api;

  CourseRepository({required this.api});

  Future<Either<DioFailure, UserModel?>> getCourses({
    required String idToken,
    String? type,
  }) async {
    try {
      final response = await api.getCourses();

      final user = response.data['user'] as Map<String, dynamic>;
      return Right(UserModel.fromJson(user));
    } on DioException catch (e) {
      final reason = DioExceptions.fromDioError(e).toString();
      final statusCode = e.response?.statusCode.toString() ?? '';
      return Left(ApiFailure(reason: reason, statusCode: statusCode));
    } catch (e) {
      return Left(ApiFailure(reason: e.toString(), statusCode: '400'));
    }
  }
}
