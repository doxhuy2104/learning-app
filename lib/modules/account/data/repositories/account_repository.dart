import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:learning_app/core/models/group_model.dart';
import 'package:learning_app/core/models/subject_model.dart';
import 'package:learning_app/core/models/user_model.dart';
import 'package:learning_app/core/network/dio_exceptions.dart';
import 'package:learning_app/core/network/dio_failure.dart';
import 'package:learning_app/modules/account/data/datasources/account_api.dart';

class AccountRepository {
  final AccountApi api;

  AccountRepository({required this.api});

  Future<Either<DioFailure, List<GroupModel>>> getGroups() async {
    try {
      final response = await api.getGroups();

      final List<GroupModel> groups = (response.data as List<dynamic>)
          .map(
            (e) => GroupModel.fromJson(e as Map<String, dynamic>) as GroupModel,
          )
          .toList();
      return Right(groups);
    } on DioException catch (e) {
      final reason = DioExceptions.fromDioError(e).toString();
      final statusCode = e.response?.statusCode.toString() ?? '';
      return Left(ApiFailure(reason: reason, statusCode: statusCode));
    } catch (e) {
      return Left(ApiFailure(reason: e.toString(), statusCode: '400'));
    }
  }

  Future<Either<DioFailure, UserModel>> updateAccount({
    String? name,
    int? groupId,
  }) async {
    try {
      final response = await api.updateAccount(name, groupId);

      final UserModel user = UserModel.fromJson(response.data);

      return Right(user);
    } on DioException catch (e) {
      final reason = DioExceptions.fromDioError(e).toString();
      final statusCode = e.response?.statusCode.toString() ?? '';
      return Left(ApiFailure(reason: reason, statusCode: statusCode));
    } catch (e) {
      return Left(ApiFailure(reason: e.toString(), statusCode: '400'));
    }
  }

  Future<Either<DioFailure, UserModel>> getAccountInfo() async {
    try {
      final response = await api.getAccountInfo();

      final UserModel user = UserModel.fromJson(response.data);

      return Right(user);
    } on DioException catch (e) {
      final reason = DioExceptions.fromDioError(e).toString();
      final statusCode = e.response?.statusCode.toString() ?? '';
      return Left(ApiFailure(reason: reason, statusCode: statusCode));
    } catch (e) {
      return Left(ApiFailure(reason: e.toString(), statusCode: '400'));
    }
  }
}
