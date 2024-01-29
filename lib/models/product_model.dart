import 'dart:convert';
import 'dart:typed_data';

class Product {
  final String productId;
  final String name;
  final String brand;
  final String description;
  final List<ProductImage> images;
  final String color;
  final double price;
  final int itemCount;
  final String category;
  final String model;
  final String size;
  final String material;

  Product({
    required this.productId,
    required this.name,
    required this.brand,
    required this.description,
    required this.images,
    required this.color,
    required this.price,
    required this.itemCount,
    required this.category,
    required this.model,
    required this.size,
    required this.material,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      name: json['name'],
      brand: json['brand'],
      description: json['description'],
      images: (json['images'] as List<dynamic>).map((imageJson) {
        return ProductImage.fromJson(imageJson);
      }).toList(),
      color: json['color'],
      price: json['price'].toDouble(),
      itemCount: json['itemcount'],
      category: json['category'],
      model: json['model'] ?? '',
      size: json['size'] ?? '',
      material: json['material'] ?? '',
    );
  }
}

class ProductImage {
  final String id;
  final Uint8List data;
  final String contentType;

  ProductImage({
    required this.id,
    required this.data,
    required this.contentType,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['_id'],
      data: _base64ToUint8List(json['data']),
      contentType: json['contentType'],
    );
  }

  static Uint8List _base64ToUint8List(String base64String) {
    List<int> bytes = List<int>.from(base64.decode(base64String));
    return Uint8List.fromList(bytes);
  }
}
