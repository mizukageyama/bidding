class NotificationModel {
  NotificationModel({
    required this.title,
    required this.seller,
    required this.approved,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
          title: json['title'] as String,
          seller: json['seller'] as String,
          approved: json['seller'] as String);

  Map<String, dynamic> toJson() => {
        'title': title,
        'seller': seller,
        'approved': approved,
      };

  final String? title;
  final String? seller;
  final String? approved;
}
