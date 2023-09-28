import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Product_Screen.dart';

class SubcategoryScreen extends StatelessWidget {
  final String categoryCode;

  SubcategoryScreen({required this.categoryCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subcategories',style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 25
        ),),
      ),
      body: SubcategoryList(categoryCode: categoryCode),
    );
  }
}

class SubcategoryList extends StatefulWidget {
  final String categoryCode;

  SubcategoryList({required this.categoryCode});

  @override
  _SubcategoryListState createState() => _SubcategoryListState();
}

class _SubcategoryListState extends State<SubcategoryList> {
  List<dynamic> subcategories = [];

  @override
  void initState() {
    super.initState();
    fetchSubcategories();
  }

  Future<void> fetchSubcategories() async {
    final response = await http.get(Uri.parse('http://154.26.130.251:302/SubCategory/GetbyCategoryCode?OrganizationId=1&CategoryCode=${widget.categoryCode}'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['Status'] == true) {
        setState(() {
          subcategories = data['Data'];
        });
      }
    } else {
      throw Exception('Failed to load subcategories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return subcategories.isEmpty
        ? Center(
      child: Center(
          child: Column(
            children: [
              Icon(Icons.not_interested,size: 30,),
              Text('No data found',style: TextStyle(fontSize: 25),),
            ],
          )),
    )
        : ListView.builder(
      itemCount: subcategories.length,
      itemBuilder: (context, index) {
        final subcategory = subcategories[index];
        return Card(
          child: ListTile(
            title: Text(subcategory['Name'],style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),),
            onTap: () {
              Get.to(ProductScreen(
                categoryCode: widget.categoryCode,
                subcategoryCode: subcategory['Code'],
              ));
            },
          ),
        );
      },
    );
  }
}
