class UserEntity {
  final String name;
  final String email;
  final String photoUrl;
  final bool isActive;
  final String lastActive;

  UserEntity({
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.isActive,
    required this.lastActive,
  });
}