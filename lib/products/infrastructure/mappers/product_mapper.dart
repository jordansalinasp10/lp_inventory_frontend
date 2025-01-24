import '../../domain/domain.dart';

class ProductMapper {
  static jsonToEntity(Map<String, dynamic> json) => Product(
      productCode: json['productCode'],
      productName: json['productName'],
      price: double.parse( json['price'].toString()),
      quantity: json['quantity'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt']);
}
