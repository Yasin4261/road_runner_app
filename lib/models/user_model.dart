class UserModel {
  final String? name;
  final String? email;
  final String? password;
  final String? profileImageUrl;

  UserModel({
    this.name,
    this.email,
    this.password,
    this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      profileImageUrl: json['profileImageUrl'],
    );
  }
}
