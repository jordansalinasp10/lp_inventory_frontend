import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lp_inventory_frontend/presentation/screens/products/product_details_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final Dio dio =
      Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] ?? 'localhost:8000/'));

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> filteredProducts = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(_filterProducts);
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
        filteredProducts = products;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data: $e';
        isLoading = false;
      });
    }
  }

  void _filterProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products
          .where((product) => (product['product_name'] ?? '')
              .toString()
              .toLowerCase()
              .contains(query))
          .toList();
    });
  }

  String getCategoryNameById(int categoryId) {
    final category = categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {'category_name': 'Unknown'}, // Default value if not found
    );
    return category['category_name'] ?? 'Unknown';
  }

  Future<String> getSignedImageUrl(String productCode) async {
    try {
      final response =
          await dio.get<Map<String, dynamic>>('image/$productCode');
      return response.data?['signed_image_url'] ?? '';
    } catch (e) {
      return '';
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Products',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(child: Text(errorMessage!))
                    : ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          final categoryId = product['category'];
                          final categoryName = getCategoryNameById(categoryId);

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            child: ListTile(
                              leading: product['image_url'] != null &&
                                      product['image_url'] != ''
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        product[
                                            'image_url'], // Usamos directamente el URL de la imagen
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const CircleAvatar(
                                      radius: 25,
                                      child: Icon(Icons
                                          .image_not_supported), // Icono en caso de no tener imagen
                                    ),
                              title: Text(
                                product['product_name'] ?? 'No name',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SKU: ${product['product_code']}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  Text(
                                    'Quantity: ${product['quantity'] ?? 'N/A'}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  Text(
                                    'Categoria: $categoryName',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailScreen(product: product),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
