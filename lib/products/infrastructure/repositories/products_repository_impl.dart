
import '../../domain/domain.dart';

class ProductsRepositoryImpl extends ProductsRepository{

  final ProductsDatasource datasource;

  ProductsRepositoryImpl(this.datasource);
  
  @override
  Future<List<Product>> getProducts() {
    return datasource.getProducts();
  }

  @override
  Future<Product> getProductsById({String productCode}) {
    return datasource.getProductsById(productCode: productCode);
  }

  @override
  Future<List<Product>> searchProductByName(String name) {
    return datasource.searchProductByName(name);
  }

} 