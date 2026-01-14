import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:learning_app/core/components/app_indicator.dart';
import 'package:learning_app/core/models/user_model.dart';
import 'package:learning_app/core/network/dio_exceptions.dart';
import 'package:learning_app/core/network/dio_failure.dart';
import 'package:learning_app/modules/auth/data/datasources/auth_api.dart';

class AuthRepository {
  final AuthApi api;

  AuthRepository({required this.api});

  Future<Either<DioFailure, UserModel?>> loginByIdToken({
    required String idToken,
    String? type,
  }) async {
    try {
      final response = await api.loginByIdToken(idToken: idToken, type: type);

      final user = response.data['user'] as Map<String, dynamic>;
      return Right(UserModel.fromJson(user));
    } on DioException catch (e) {
      final reason = DioExceptions.fromDioError(e).toString();
      final statusCode = e.response?.statusCode.toString() ?? '';
      AppIndicator.hide();

      return Left(ApiFailure(reason: reason, statusCode: statusCode));
    } catch (e) {
      return Left(ApiFailure(reason: e.toString(), statusCode: '400'));
    }
  }

  Future<Either<DioFailure, UserModel?>> signup({
    required String idToken,
    required String name,
  }) async {
    try {
      final response = await api.signUp(idToken: idToken, name: name);

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
