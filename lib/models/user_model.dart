//User Model
class UserModel {
  UserModel({
    required this.userID,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.validID,
    required this.validSelfie,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userID: json['userID'] as String,
        email: json['email'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        profileImage: json['profileImage'] as String,
        validID: json['validID'] as String,
        validSelfie: json['validSelfie'] as String,
      );

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'profileImage': profileImage,
        'validID': validID,
        'validSelfie': validSelfie,
      };

  final String? userID;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? profileImage;
  final String? validID;
  final String? validSelfie;
}
