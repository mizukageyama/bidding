import 'package:bidding/models/bid_model.dart';
import 'package:bidding/models/user_model.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';

class Item {
  final String itemId;
  final String sellerId;
  final String title;
  final String description;
  final double askingPrice;
  final List<String> category;
  final String condition;
  final String brand;
  final Timestamp endDate;
  //final Timestamp datePosted;
  final String winningBid;
  final List<String> images;
  UserModel? sellerInfo;
  List<Bid> bids = List.empty(growable: true);

  Item({
    required this.itemId,
    required this.sellerId,
    required this.title,
    required this.description,
    //required this.datePosted,
    required this.winningBid,
    required this.askingPrice,
    required this.category,
    required this.condition,
    required this.brand,
    required this.endDate,
    required this.images,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['item_id'] as String,
      sellerId: json['seller_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      askingPrice: double.parse('${json['asking_price']}'),
      category: List<String>.from(json['category'] ?? []),
      //datePosted: json['date_posted'] as Timestamp,
      condition: json['condition'] as String,
      brand: json['brand'] as String,
      endDate: json['end_date'] as Timestamp,
      images: List<String>.from(json['images'] ?? []),
      winningBid: json['winning_bid'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'item_id': itemId,
        'seller_id': sellerId,
        'title': title,
        'description': description,
        'asking_price': askingPrice,
        //'date_posted': datePosted,
        'category': category,
        'condition': condition,
        'brand': brand,
        'end_date': endDate,
        'images': images,
      };

  @override
  String toString() {
    return '{itemId: $itemId\nsellerId: $sellerId\ntitle: $title\ndescription: $description'
        '\naskingPrice: $askingPrice\ncategory: $category\ncondition: $condition'
        '\nbrand: $brand\nendDate: $endDate\nimages: $images}';
  }

  //Fetch Additional Data
  Future<void> getSellerInfo() async {
    sellerInfo = await firestore
        .collection('users')
        .doc(sellerId)
        .get()
        .then((doc) => UserModel.fromJson(doc.data()!));
  }

  Future<void> getBids() async {
    bids.addAll(await firestore
        .collection('bids')
        .orderBy('amount', descending: true)
        .where('item_id', isEqualTo: itemId)
        .where('is_approved', isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((item) {
        return Bid.fromJson(item.data() as Map<String, dynamic>);
      }).toList();
    }));
  }
}
