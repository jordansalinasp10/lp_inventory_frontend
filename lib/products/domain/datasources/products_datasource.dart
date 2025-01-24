
import '../entities/product.dart';

abstract class ProductsDatasource {

  Future<Product> getProductsById({String productCode });

  Future<List<Product>> getProducts();

  Future<List<Product>> searchProductByName (String name);
  
} 