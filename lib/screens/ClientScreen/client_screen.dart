import 'package:crmproject/data/models/category_model.dart';
import 'package:crmproject/screens/LoginScreen/login_screen.dart';
import 'package:crmproject/screens/Product_list_screen/product_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class ClientScreen extends StatelessWidget {
  final String title;
  const ClientScreen({super.key,this.title='SNM Products'});

  @override
  Widget build(BuildContext context) {
    final List<Category> categories = [
      Category(name: "Electronics", image: "assets/images/electronics.png"),
      Category(name: "Clothing", image: "assets/images/clothing.png"),
      Category(name: "Shoes", image: "assets/images/shoes.png"),
      Category(name: "Beauty", image: "assets/images/beauty.png"),
      Category(name: "Books", image: "assets/images/books.png"),
      Category(name: "Sports", image: "assets/images/sports.png"),
    ];

    return Scaffold(
      appBar: AppBar(
        title:Text(title,style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold

        ),),
        actions: [
          IconButton(onPressed: ()async{
            await FirebaseAuth.instance.signOut();
            Get.to(()=>LoginScreen());
          }, icon: Icon(Icons.logout,color: Colors.white,))
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 150,
                autoPlay: true,
                enableInfiniteScroll: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                viewportFraction: 0.8,
              ),
              items: categories.map((cat) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Clicked $cat")),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            cat.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => ProductListScreen(category:categories[index]));
                    },
                    child: Card(
                      color: Colors.blueGrey[100],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.category, size: 40, color: Colors.deepPurple),
                          SizedBox(height: 8),
                          Text( categories[index].name,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
            ),
            )
          ],
        ),
      ),
    );
  }
}
