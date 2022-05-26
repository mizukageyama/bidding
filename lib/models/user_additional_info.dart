class AdditionalInfo {
  final String profilePhoto;

  AdditionalInfo({required this.profilePhoto});

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) =>
      AdditionalInfo(profilePhoto: json['profile_photo'] as String);
}
