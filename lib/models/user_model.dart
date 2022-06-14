class UserModel {
  final String userID;
  final String email;
  final String firstName;
  final String lastName;
  final String userRole;

  UserModel({
    required this.userID,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userRole,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userID: json['user_id'] as String,
        email: json['email'] as String,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        userRole: json['user_role'] as String,
      );

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'user_role': userRole,
      };

  get fullName => '$firstName $lastName';
}
