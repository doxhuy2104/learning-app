import 'package:equatable/equatable.dart';
import 'package:learning_app/core/models/group_model.dart';

class UserModel extends Equatable {
  final int? id;
  final String? avatar;
  final String? fullName;
  final String? accessToken;
  final String? email;
  final String? loginType;
  final GroupModel? group;

  const UserModel({
    this.id,
    this.avatar,
    this.fullName,
    this.accessToken,
    this.email,
    this.loginType,
    this.group,
  });

  static fromJson(Map<String, dynamic>? mapData) {
    if (mapData == null) return null;

    final int? id = mapData['id'];
    final String? avatar = mapData['avatar'];
    final String? fullName = mapData['fullName'];
    final String? accessToken = mapData['accessToken'];
    final String? email = mapData['email'];
    final String? loginType = mapData['loginType'];
    final GroupModel? group = GroupModel.fromJson(
      mapData['group'] as Map<String, dynamic>?,
    );

    return UserModel(
      id: id,
      avatar: avatar,
      fullName: fullName,
      accessToken: accessToken,
      email: email,
      loginType: loginType,
      group: group,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'avatar': avatar,
    'fullName': fullName,
    'accessToken': accessToken,
    'email': email,
    'loginType': loginType,
    'group': group?.toJson(),
  };

  UserModel copyWith({
    int? id,
    String? avatar,
    String? fullName,
    String? accessToken,
    String? email,
    String? loginType,
    GroupModel? group,
  }) {
    return UserModel(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      fullName: fullName ?? this.fullName,
      accessToken: accessToken ?? this.accessToken,
      email: email ?? this.email,
      loginType: loginType ?? this.loginType,
      group: group ?? this.group,
    );
  }

  @override
  List<Object?> get props => [
    id,
    avatar,
    fullName,
    accessToken,
    email,
    loginType,
    group,
  ];

  @override
  String toString() {
    return 'User: id:$id, avatar: $avatar, fullName: $fullName, accessToken: $accessToken, email: $email, loginType:$loginType, group:$group';
  }
}
