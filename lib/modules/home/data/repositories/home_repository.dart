import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:learning_app/core/models/subject_model.dart';
import 'package:learning_app/core/network/dio_exceptions.dart';
import 'package:learning_app/core/network/dio_failure.dart';
import 'package:learning_app/modules/home/data/datasources/home_api.dart';

class HomeRepository {
  final HomeApi api;

  HomeRepository({required this.api});

  Future<Either<DioFailure, List<SubjectModel>>> getSubjects() async {
    try {
      final response = await api.getSubjects();

      final List<SubjectModel> subjects = (response.data as List<dynamic>)
          .map(
            (e) =>
                SubjectModel.fromJson(e as Map<String, dynamic>)
                    as SubjectModel,
          )
          .toList();
      return Right(subjects);
    } on DioException catch (e) {
      final reason = DioExceptions.fromDioError(e).toString();
      final statusCode = e.response?.statusCode.toString() ?? '';
      return Left(ApiFailure(reason: reason, statusCode: statusCode));
    } catch (e) {
      return Left(ApiFailure(reason: e.toString(), statusCode: '400'));
    }
  }
}
