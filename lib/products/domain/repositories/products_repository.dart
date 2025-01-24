
import '../entities/product.dart';

abstract class ProductsRepository {
  Future<Product> getProductsById({String productCode });
  Future<List<Product>> getProducts();

  Future<List<Product>> searchProductByName (String name);
  
}