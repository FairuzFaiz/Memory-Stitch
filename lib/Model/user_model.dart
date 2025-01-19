class UserTableModel {
  final String id;
  final String username;
  final String email;
  final String bio;
  final String foto_profile;

  UserTableModel(
      {required this.id,
      required this.username,
      required this.email,
      required this.bio,
      required this.foto_profile});

  factory UserTableModel.fromJson(Map data) {
    return UserTableModel(
        id: data['_id'],
        username: data['username'],
        email: data['email'],
        bio: data['bio'],
        foto_profile: data['foto_profile']);
  }
}
