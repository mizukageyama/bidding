class UserModel {
  UserModel({
    required this.userID,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userID: json['user_id'] as String,
        email: json['email'] as String,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        isAdmin: json['is_admin'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'is_admin': isAdmin,
      };

  final String? userID;
  final String? email;
  final String? firstName;
  final String? lastName;
  final bool? isAdmin;
}
