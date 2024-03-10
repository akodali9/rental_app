import 'dart:convert';
import 'dart:typed_data';

class Offer {
  final String id;
  final Uint8List image;

  Offer({
    required this.id,
    required this.image,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['_id'],
      image: _base64ToUint8List(json['image']['data']),
    );
  }

  static Uint8List _base64ToUint8List(List<dynamic> bsonData) {
    // Ensure that bsonData is a List<int>
    List<int> data = bsonData.cast<int>().toList();

    // Convert the BSON binary data to a base64-encoded string
    String base64String = base64Encode(data);

    // Decode the base64-encoded string into a Uint8List
    List<int> bytes = base64.decode(base64String);
    return Uint8List.fromList(bytes);
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'image': {'data': image.toList()},
    };
  }
}
