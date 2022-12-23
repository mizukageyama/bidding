class AdditionalInfo {
  final String profilePhoto;
  final int badgeCount;

  AdditionalInfo({required this.profilePhoto, required this.badgeCount});

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) => AdditionalInfo(
        profilePhoto: json['profile_photo'] as String,
        badgeCount: json['notif_badge'] as int,
      );
}
