import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  _ProductsListScreenState createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final Dio dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? 'localhost:8000/'));

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> categories = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final responses = await Future.wait([
        dio.get<List<dynamic>>('products/'),
        dio.get<List<dynamic>>('categories/'),
      ]);

      setState(() {
        products = List<Map<String, dynamic>>.from(responses[0].data ?? []);
        categories = List<Map<String, dynamic>>.from(responses[1].data ?? []);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data: $e';
        isLoading = false;
      });
    }
  }

  String getCategoryNameById(int categoryId) {
    final category = categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {'name': 'Unknown'}, 
    );
    return category['name'] ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Indicador de carga
          : errorMessage != null
              ? Center(child: Text(errorMessage!)) 
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final categoryId = product['category'];
                    final categoryName = getCategoryNameById(categoryId);

                    return ListTile(
                      title: Text(product['product_name'] ?? 'No name'),
                      subtitle: Text(
                          'Category: $categoryName\nPrice: \$${product['price']?.toStringAsFixed(2) ?? 'N/A'}'),
                      isThreeLine: true,
                    );
                  },
                ),
    );
  }
}