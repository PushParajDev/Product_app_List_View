import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Sub_Category_Screen.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag,size: 30,color: Colors.white,),
            Text('PRODUCT APP',style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 23.0
            ),),
          ],
        ),
      ),
      body: CategoryList(),
    );
  }
}

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('http://154.26.130.251:302/Category/GetAll?OrganizationId=1'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['Status'] == true) {
        setState(() {
          categories = data['Data'];
        });
      }
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Center(
            child: Card(
              child: Container(
                height: 70,
                child: ListTile(
                  title: Text(
                    category['Name'],
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Get.to(SubcategoryScreen(categoryCode: category['Code']));
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
