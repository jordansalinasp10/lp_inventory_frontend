import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatelessWidget {
  final Dio dio =
      Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] ?? 'localhost:8000/'));
  final Map<String, dynamic> product;

  ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  String formatDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }

  Future<Map<String, dynamic>> getCategoryDetails(int categoryId) async {
    try {
      final response =
          await dio.get<Map<String, dynamic>>('categories/$categoryId');
      return response.data ?? {};
    } catch (e) {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            product['image_url'] != null && product['image_url'].isNotEmpty
                ? AspectRatio(
                    aspectRatio: 1 / 1, // Square aspect ratio, adjust as needed
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(product['image_url']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 100,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product['product_name'],
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),

                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(context,
                              icon: Icons.code,
                              label: 'SKU',
                              value: product['product_code']),
                          const SizedBox(height: 8),
                          _buildDetailRow(context,
                              icon: Icons.inventory,
                              label: 'Quantity',
                              value: (product['quantity'] ?? 'N/A').toString()),
                          const SizedBox(height: 8),
                          _buildDetailRow(context,
                              icon: Icons.price_change_sharp,
                              label: 'Price',
                              value: (product['price'] ?? 'N/A').toString()),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'Category Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<Map<String, dynamic>>(
                    future: getCategoryDetails(product['category']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return const Center(
                          child: Text('Failed to load category data'),
                        );
                      } else {
                        final category = snapshot.data!;
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow(context,
                                    icon: Icons.category,
                                    label: 'Name',
                                    value: category['category_name'] ?? 'N/A'),
                                const SizedBox(height: 8),
                                Text(
                                  'Description:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  category['category_description'] ??
                                      'No description available',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.grey[700],
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context,
      {required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        const SizedBox(width: 12),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                text: '$label: ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      ],
    );
  }
}
