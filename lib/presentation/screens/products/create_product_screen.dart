import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({Key? key}) : super(key: key);

  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final Dio dio =
      Dio(BaseOptions(baseUrl: dotenv.env['API_URL'] ?? 'localhost:8000/'));

  final TextEditingController productCodeController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  List<Map<String, dynamic>> categories = [];
  String? selectedCategory;
  File? selectedImage;

  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await dio.get<List<dynamic>>('categories/');
      setState(() {
        categories = List<Map<String, dynamic>>.from(response.data ?? []);
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading categories: $e';
      });
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<String?> uploadImage(File image, String productCode) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path),
      });

      final response = await dio.post<Map<String, dynamic>>(
        '/image/create/$productCode',
        data: formData,
      );

      final imageUrl = response.data?['image_url'];
      return imageUrl;
    } catch (e) {
      setState(() {
        errorMessage = 'Error uploading image: $e';
      });
      return null;
    }
  }

  Future<void> createProduct() async {
    if (productCodeController.text.isEmpty ||
        productNameController.text.isEmpty ||
        priceController.text.isEmpty ||
        quantityController.text.isEmpty ||
        selectedCategory == null) {
      setState(() {
        errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    String? imageUrl;
    if (selectedImage != null) {
      imageUrl = await uploadImage(selectedImage!, productCodeController.text);
      if (imageUrl == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    final productData = {
      'product_code': productCodeController.text,
      'product_name': productNameController.text,
      'price': double.parse(priceController.text),
      'quantity': int.parse(quantityController.text),
      'category': int.parse(selectedCategory!),
      'image_url': imageUrl,
    };

    try {
      await dio.post('products/create/', data: productData);
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        errorMessage = 'Error creating product: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              TextField(
                controller: productCodeController,
                decoration: const InputDecoration(labelText: 'Product Code'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: productNameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['category_id'].toString(),
                    child: Text(category['category_name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Pick Image'),
              ),
              if (selectedImage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.file(
                    selectedImage!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: createProduct,
                      child: const Text('Create Product'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
