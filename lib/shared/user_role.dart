enum UserRole { client, delivery }

extension UserRoleX on UserRole {
  String get asString => this == UserRole.client ? 'client' : 'delivery';
  static UserRole fromString(String s) =>
      s == 'delivery' ? UserRole.delivery : UserRole.client;
}
