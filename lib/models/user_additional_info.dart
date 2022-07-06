class AdditionalInfo {
  final String profilePhoto;
  final int notifBadgeCount;

  AdditionalInfo({required this.profilePhoto, required this.notifBadgeCount});

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) => AdditionalInfo(
        profilePhoto: json['profile_photo'] as String,
        notifBadgeCount: json['notif_badge'] as int,
      );
}
