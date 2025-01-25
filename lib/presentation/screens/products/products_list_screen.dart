import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  _ProductsListScreenState createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://dd26-157-100-108-8.ngrok-free.app/',

  ));

  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await dio.get<List<dynamic>>('products/');
      setState(() {
        products = List<Map<String, dynamic>>.from(response.data ?? []);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching products: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Indicador de carga
          : errorMessage != null
              ? Center(child: Text(errorMessage!)) // Mensaje de error
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      title: Text(product['product_name'] ?? 'No name'),
                      subtitle: Text(
                          'Price: \$${product['price']?.toStringAsFixed(2) ?? 'N/A'}'),
                    );
                  },
                ),
    );
  }
}