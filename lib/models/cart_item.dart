import 'dart:convert';

class CartItem {
  final int productId;
  final String title;
  final String imageUrl;
  final num price; // discounted price at the time of adding
  final num? mrp; // original price (optional)
  final int quantity;

  const CartItem({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.mrp,
    required this.quantity,
  });

  CartItem copyWith({int? quantity}) => CartItem(
        productId: productId,
        title: title,
        imageUrl: imageUrl,
        price: price,
        mrp: mrp,
        quantity: quantity ?? this.quantity,
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'title': title,
        'imageUrl': imageUrl,
        'price': price,
        'mrp': mrp,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId'] as int,
        title: json['title']?.toString() ?? '',
        imageUrl: json['imageUrl']?.toString() ?? '',
        price: json['price'] ?? 0,
        mrp: json['mrp'],
        quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      );

  static String encodeList(List<CartItem> items) => jsonEncode(items.map((e) => e.toJson()).toList());
  static List<CartItem> decodeList(String raw) {
    final list = jsonDecode(raw) as List? ?? [];
    return list.map((e) => CartItem.fromJson(e as Map<String, dynamic>)).toList();
  }
}
