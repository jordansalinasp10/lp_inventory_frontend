import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://dd26-157-100-108-8.ngrok-free.app/',
  ));

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    searchController.addListener(_filterProducts);
  }

  Future<void> fetchProducts() async {
    try {
      final response = await dio.get<List<dynamic>>('products/');
      setState(() {
        products = List<Map<String, dynamic>>.from(response.data ?? []);
        filteredProducts = products; // Inicialmente muestra todos
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching products: $e';
        isLoading = false;
      });
    }
  }

  void _filterProducts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products
          .where((product) =>
              (product['product_name'] ?? '')
                  .toString()
                  .toLowerCase()
                  .contains(query))
          .toList();
    });
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

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            child: ListTile(
                              leading: FutureBuilder<String>(
                                future: getSignedImageUrl(
                                    product['product_code']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError ||
                                      !snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const CircleAvatar(
                                      radius: 25,
                                      child: Icon(
                                          Icons.image_not_supported),
                                    );
                                  } else {
                                    return ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(8.0),
                                      child: Image.network(
                                        snapshot.data!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }
                                },
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
                                    style:
                                        TextStyle(color: Colors.grey[600]),
                                  ),
                                  Text(
                                    'Quantity: ${product['quantity'] ?? 'N/A'}',
                                    style:
                                        TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                // Acción al tocar el producto
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