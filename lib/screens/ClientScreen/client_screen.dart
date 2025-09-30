import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crmproject/screens/AdminScreen/admin_screen_controller.dart';
import 'package:crmproject/screens/ClientScreen/client_profile_screen.dart';
import 'package:crmproject/screens/LoginScreen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

import '../Service Details Screen/service_details_screen.dart';
import '../Subscribe Servcice/subscribe_service_screen.dart';

class ClientScreen extends StatelessWidget {
  final String title;
final AdminController controller=Get.put(AdminController());
final email=FirebaseAuth.instance.currentUser?.email;
  final name=FirebaseAuth.instance.currentUser?.displayName;
 ClientScreen({super.key, this.title = 'SNM Products'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      actions: [
      PopupMenuButton<String>(
      icon: const Icon(Icons.settings, color: Colors.white),
      onSelected: (value) async{
        if (value == 'logout') {
         await FirebaseAuth.instance.signOut();
         Get.to(()=>LoginScreen());
        } else if (value == 'reset') {
          controller.resetPassword(email!);
        } else if (value == 'address') {
          Get.to(()=>ClientProfileScreen(name:name!));

        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: const [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text("Logout"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'reset',
          child: Row(
            children: const [
              Icon(Icons.lock_reset, color: Colors.blue),
              SizedBox(width: 8),
              Text("Reset Password"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'address',
          child: Row(
            children: const [
              Icon(Icons.home, color: Colors.green),
              SizedBox(width: 8),
              Text("Update Address"),
            ],
          ),
        ),
      ],
    ),
    ],
    backgroundColor: Colors.deepPurple,
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('services').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Error fetching services"));
            }

            final services = snapshot.data!.docs;

            if (services.isEmpty) {
              return const Center(child: Text("No services available"));
            }

            return Column(
              children: [
                // Carousel Section
                CarouselSlider(

                  options: CarouselOptions(
                    height: 150,
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    viewportFraction: 0.8,
                  ),
                  items: services.map((service) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap:(){ Get.to(()=>ServiceDetailsScreen(serviceData:  service.data() as Map<String, dynamic>));},
                          child: Card(
                            color: Colors.blueGrey[100],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.category, size: 40, color: Colors.deepPurple),
                                SizedBox(height: 8),
                                Text(
                                  service['name'],
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.to(() => OrderScreen(serviceData: service.data() as Map<String, dynamic>));
                                  },
                                  child: Text("Subscribe"),
                                )
                              ],
                             ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Grid Section
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: services.length,
                    itemBuilder: (BuildContext context, int index) {
                      final service = services[index];
                      final name = service['name'] ?? 'Unnamed Service';

                      return GestureDetector(
                        onTap: () {
                          Get.to(() =>ServiceDetailsScreen(serviceData: service.data() as Map<String,dynamic>,));
                        },
                        child: Card(
                          color: Colors.blueGrey[100],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.category,
                                  size: 40, color: Colors.deepPurple),
                              const SizedBox(height: 8),
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
