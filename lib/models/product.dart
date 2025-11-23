import 'dart:convert';

class Product {
  final int id;
  final String title;
  final String description;
  final List<String> keyFeatures;
  final String? reviews;
  final double? rating;
  final num discountedPrice;
  final num? originalPrice;
  final num? discount;
  final int? vendorId;
  final String? productType;
  final double? lat;
  final double? lng;
  final String? productCategory;
  final List<String> imagesUrl;
  final String? videosUrl;
  final String? productDocuments;
  final String? soldByVendorName;
  final String? status;
  final int? quantityAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;


  final String? deliveryTime;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.keyFeatures,
    this.reviews,
    this.rating,
    required this.discountedPrice,
    this.originalPrice,
    this.discount,
    this.vendorId,
    this.productType,
    this.lat,
    this.lng,
    this.productCategory,
    required this.imagesUrl,
    this.videosUrl,
    this.productDocuments,
    this.soldByVendorName,
    this.status,
    this.quantityAvailable,
    this.createdAt,
    this.updatedAt,

    /// ⭐ NEW FIELD
    this.deliveryTime,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      keyFeatures: (json['key_features'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      reviews: json['reviews']?.toString(),
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating'] as num?)?.toDouble(),
      discountedPrice: json['discounted_price'] ?? 0,
      originalPrice: json['original_price'],
      discount: json['discount'],
      vendorId: json['vendorId'] as int?,
      productType: json['product_type']?.toString(),
      lat: (json['product_lat'] as num?)?.toDouble(),
      lng: (json['product_lng'] as num?)?.toDouble(),
      productCategory: json['product_category']?.toString(),
      imagesUrl: (json['images_url'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      videosUrl: json['videos_url']?.toString(),
      productDocuments: json['product_documents']?.toString(),
      soldByVendorName: json['sold_by_vendor_name']?.toString(),
      status: json['status']?.toString(),
      quantityAvailable: json['quantity_available'] as int?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,

      /// ⭐ NEW FIELD
      deliveryTime: json['delivery_time']?.toString(),
    );
  }

  static List<Product> listFromResponse(String body) {
    final decoded = json.decode(body) as Map<String, dynamic>;
    final data = decoded['data'] as List? ?? [];
    return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }
}
