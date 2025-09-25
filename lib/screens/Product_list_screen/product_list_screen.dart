import 'package:crmproject/data/models/category_model.dart';
import 'package:crmproject/screens/ClientScreen/client_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ProductListScreen extends StatelessWidget {
  final Category category;
  ProductListScreen({super.key,required this.category});

  final List<String> _items = List.generate(50, (index) => 'Item $index');

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('${category.name} Products',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
              onPressed: (){
                Get.to(()=>ClientProfileScreen());

              },
              icon: const Icon(Icons.settings,color: Colors.white,))
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 8.0, // Spacing between columns
            mainAxisSpacing: 8.0, // Spacing between rows
            childAspectRatio: 1.0, // Aspect ratio of each grid item (width/height)
          ),
          itemCount: _items.length, // Total number of items in the grid
          itemBuilder: (BuildContext context, int index) {
            // Build each grid item based on the data and index
            return Card(
              color: Colors.blueGrey[100],
              child: Center(
                child: Text(
                  _items[index],
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
