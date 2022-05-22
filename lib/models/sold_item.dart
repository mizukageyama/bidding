import 'package:bidding/models/user_model.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';

class SoldItem {
  final String itemId;
  final String sellerId;
  final String buyerId;
  final double soldAt;
  final String title;
  final String description;
  final double askingPrice;
  final List<String> category;
  final String condition;
  final String brand;
  final Timestamp endDate;
  final Timestamp dateSold;
  final List<String> images;
  UserModel? buyer;

  SoldItem({
    required this.itemId,
    required this.sellerId,
    required this.buyerId,
    required this.soldAt,
    required this.title,
    required this.description,
    required this.askingPrice,
    required this.category,
    required this.condition,
    required this.brand,
    required this.endDate,
    required this.dateSold,
    required this.images,
    this.buyer,
  });

  factory SoldItem.fromJson(Map<String, dynamic> json) => SoldItem(
        itemId: json['item_id'] as String,
        sellerId: json['seller_id'] as String,
        buyerId: json['buyer_id'] as String,
        soldAt: double.parse('${json['sold_at']}'),
        title: json['title'] as String,
        description: json['description'] as String,
        askingPrice: double.parse('${json['asking_price']}'),
        category: List<String>.from(json['category'] ?? []),
        condition: json['condition'] as String,
        brand: json['brand'] as String,
        endDate: json['end_date'] as Timestamp,
        dateSold: json['date_sold'] as Timestamp,
        images: List<String>.from(json['images'] ?? []),
      );

  Future<void> getBuyerInfo() async {
    buyer = await firestore
        .collection('users')
        .doc(buyerId)
        .get()
        .then((doc) => UserModel.fromJson(doc.data()!));
  }

  get buyerName => '${buyer!.firstName} ${buyer!.lastName}';
}
