import 'package:bidding/shared/constants/_firebase_imports.dart';

class NotificationModel {
  final String title;
  final String message;
  final Timestamp createdAt;

  NotificationModel({
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
          title: json['title'] as String,
          message: json['message'] as String,
          createdAt: json['created_at'] ?? Timestamp.now());
}
