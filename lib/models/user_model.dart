class UserModel {
  final String? userID;
  final String? email;
  final String? firstName;
  final String? lastName;
  final bool? isSeller;

  UserModel({
    required this.userID,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isSeller,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userID: json['user_id'] as String,
        email: json['email'] as String,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        isSeller: json['is_seller'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'is_seller': isSeller,
      };
}
