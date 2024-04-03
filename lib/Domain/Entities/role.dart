import 'package:equatable/equatable.dart';

class Role extends Equatable {
  const Role({
    required this.roleId,
    required this.roleName,
  });

  final int roleId;
  final String roleName;

  factory Role.fromJson(Map<String, dynamic> json){
    return Role(
      roleId: json["RoleID"] ?? 0,
      roleName: json["RoleName"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "RoleID": roleId,
    "RoleName": roleName,
  };

  @override
  String toString(){
    return "$roleId, $roleName, ";
  }

  @override
  List<Object?> get props => [
    roleId, roleName, ];
}
