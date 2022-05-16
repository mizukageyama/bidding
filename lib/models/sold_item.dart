import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:intl/intl.dart';

class SoldItem {
  final String itemId;
  final String sellerId;
  final String bidderId;
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

  SoldItem({
    required this.itemId,
    required this.sellerId,
    required this.bidderId,
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
  });

  factory SoldItem.fromJson(Map<String, dynamic> json) => SoldItem(
        itemId: json['item_id'] as String,
        sellerId: json['seller_id'] as String,
        bidderId: json['bidder_id'] as String,
        soldAt: json['sold_at'] as double,
        title: json['title'] as String,
        description: json['description'] as String,
        askingPrice: json['asking_price'] as double,
        category: List<String>.from(json['category'] ?? []),
        condition: json['condition'] as String,
        brand: json['brand'] as String,
        endDate: json['end_date'] as Timestamp,
        dateSold: json['date_sold'] as Timestamp,
        images: List<String>.from(json['images'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'item_id': itemId,
        'seller_id': sellerId,
        'title': title,
        'description': description,
        'asking_price': askingPrice,
        'category': category,
        'condition': condition,
        'brand': brand,
        'end_date': endDate,
        'date_sold': dateSold,
        'images': images,
      };

  get formattedDT {
    final dt = endDate.toDate();
    return '${DateFormat.yMMMd().format(dt)} (${DateFormat.jm().format(dt)})';
  }

  get ftAmount {
    NumberFormat f = NumberFormat("#,##0.00", "en_US");
    return f.format(askingPrice);
  }

  get ftSoldAmount {
    NumberFormat f = NumberFormat("#,##0.00", "en_US");
    return f.format(soldAt);
  }
}
