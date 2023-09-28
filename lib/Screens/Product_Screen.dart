import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductScreen extends StatelessWidget {
  final String categoryCode;
  final String subcategoryCode;

  ProductScreen({required this.categoryCode, required this.subcategoryCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Products',style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 25
          ),),
        ),
      ),
      body: ProductList(
        categoryCode: categoryCode,
        subcategoryCode: subcategoryCode,
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  final String categoryCode;
  final String subcategoryCode;

  ProductList({required this.categoryCode, required this.subcategoryCode});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(
        Uri.parse('http://154.26.130.251:302/Product/GetAllWithImage?OrganizationId=1&CategoryCode=${widget.categoryCode}&SubCategory=${widget.subcategoryCode}')
        );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['Status'] == true) {
        setState(() {
          products = data['Result'];
        });
      }
    } else {
      throw Exception('Failed to load products');
    }

  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          child: ListTile(
            title: Text(product['Name'],style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),),
            subtitle: Text('Price: \$${product['SellingCost']}'),
            // Add more product details as needed
          ),
        );
      },
    );
  }
}
