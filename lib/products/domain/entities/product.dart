
class Product {
  String productCode;
  String productName;
  double price;
  int quantity;
  int category;
  String? imageUrl;
  DateTime createdAt;

  Product({
    required this.productCode,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.category,
    required this.imageUrl,
    required this.createdAt,
  });

}
