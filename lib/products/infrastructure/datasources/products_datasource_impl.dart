
import 'package:dio/dio.dart';

import '../../domain/entities/product.dart';

import '../../domain/datasources/products_datasource.dart';
import '../mappers/product_mapper.dart';
class ProductsDatasourceImpl extends ProductsDatasource {

  late final Dio dio;

  ProductsDatasourceImpl()
    :dio = Dio(
      BaseOptions(
        baseUrl: 'https://8b39-157-100-108-8.ngrok-free.app/',
        )
        );
        
  @override
  Future<List<Product>> getProducts() async {

      // Realiza la solicitud HTTP
      final response = await dio.get<List<dynamic>>('products/');
      final List<Product> products = [];

      // Procesa los datos recibidos
      for (final product in response.data ?? []) {
        products.add(ProductMapper.jsonToEntity(product));
      }

      return products; // Retorna la lista de productos
  }

  @override
  Future<Product> getProductsById({String productCode}) {
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> searchProductByName(String name) {
    throw UnimplementedError();
  }
  
}