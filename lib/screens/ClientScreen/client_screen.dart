import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crmproject/screens/AdminScreen/admin_screen_controller.dart';
import 'package:crmproject/screens/ClientScreen/client_profile_screen.dart';
import 'package:crmproject/screens/LoginScreen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import '../Service Details Screen/service_details_screen.dart';
import '../UserSubscriptionScreen/user_subscription_controller.dart';
import 'client_screen_controller.dart';

class ClientScreen extends StatelessWidget {
  final String title;
  final AdminController controller = Get.put(AdminController());
  final email = FirebaseAuth.instance.currentUser?.email;
  final name = FirebaseAuth.instance.currentUser?.displayName;
  final subController = Get.put(SubscriptionController());
  final clientController = Get.put(ClientProfileController());

  ClientScreen({super.key, this.title = 'SNM Services'});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            onSelected: (value) async {
              if (value == 'logout') {
                await FirebaseAuth.instance.signOut();

                Get.to(() => LoginScreen());
              } else if (value == 'reset') {
                controller.resetPassword(email!);
              } else if (value == 'address') {
                Get.to(() => ClientProfileScreen(name: name!));
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
        child:  FirebaseAuth.instance.currentUser == null
            ? const Center(child: CircularProgressIndicator())
            :StreamBuilder<QuerySnapshot>(
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

                CarouselSlider(
                  options: CarouselOptions(
                    height: 150,
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    viewportFraction: 0.8,
                  ),
                  items: services.asMap().entries.map((entry){
                    final index=entry.key;
                    final service=entry.value;
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {

                            Get.to(
                              () => ServiceDetailsScreen(
                                serviceData: clientController.services[index].toMap(),

                              ),
                            );
                          },
                          child: Card(
                            color: Colors.blueGrey[100],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 110,

                                    decoration: BoxDecoration(
                                      color: Colors.brown,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(

                                        service['title'],
                                        style: TextStyle(

                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                        softWrap: true,
                                      ),
                                      Text(
                                        'Rs. ${service['price'].toString()}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                            color: Colors.pink
                                        ),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
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
                      final name = service['title'] ?? 'Unnamed Service';

                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => ServiceDetailsScreen(
                              serviceData:clientController.services[index].toMap(),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.blueGrey[100],
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),

                                    ),
                                  ),
                                  height: 70,

                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                        ' Rs. ${service['price'].toString()}',
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pink
                                          ),
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomSheet:Obx(() {
        if (subController.hasActiveSubscription.value==false &&
            subController.showBottomSheet.value==true && clientController.services.isNotEmpty) {

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final firestore = FirebaseFirestore.instance;
      Future<Map<String, dynamic>?> loadPackageWithServiceNames() async {
        final snap = await firestore.collection('packages').limit(1).get();
        if (snap.docs.isEmpty) return null;
        final doc = snap.docs.first;
        final Map<String, dynamic> data = Map<String, dynamic>.from(doc.data() as Map);

        // Normalize services -> try to convert ids to names if needed
        final servicesField = data['services'];
        final List<String> serviceNames = [];

        if (servicesField is List) {
          for (var item in servicesField) {
            if (item is String) {
              // item might be a serviceId, attempt to fetch the service doc
              try {
                final serviceDoc = await firestore.collection('services').doc(item).get();
                if (serviceDoc.exists) {
                  final sdata = serviceDoc.data() as Map<String, dynamic>;
                  serviceNames.add(sdata['title']?.toString() ?? item);
                } else {
                  // if no doc, treat the string as a human-friendly name
                  serviceNames.add(item);
                }
              } catch (e) {
                serviceNames.add(item);
              }
            } else if (item is Map) {
              // if you stored full objects in array
              serviceNames.add(item['name']?.toString() ?? item.toString());
            } else {
              serviceNames.add(item.toString());
            }
          }
        }

        data['serviceNames'] = serviceNames;
        data['id'] = doc.id;
        return data;
      }

      return FutureBuilder<Map<String, dynamic>?>(
        future: loadPackageWithServiceNames(), // CHANGED: actually load package doc & service names
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Container(
              height: 120,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }

          if (!snap.hasData || snap.data == null) {
            return Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.deepPurple.shade50
              ),
              padding: const EdgeInsets.all(16),
              child: const Center(child: Text("No package available")),
            );
          }

          final packageData = snap.data!;
          final packageId = packageData['id'] as String? ?? '';
          final serviceNames = List<String>.from(packageData['serviceNames'] ?? []);
          final pkgName = packageData['name'] ?? 'Package';
          final pkgPrice = packageData['price']?.toString() ?? '-';
          final pkgDuration = packageData['durationMonths']?.toString() ?? '-';

          return Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  pkgName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Duration: $pkgDuration months",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: 12),

                // show service list
                if (serviceNames.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Services included:",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 90,
                    child: ListView(
                      shrinkWrap: true,
                      children: serviceNames
                          .map((s) => Text("• $s", style: const TextStyle(fontSize: 14)))
                          .toList(),
                    ),
                  ),
                ] else
                  const Text("No services listed"),

                const Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.close, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.withValues(alpha: 0.8), // CHANGED: valid opacity
                      ),
                      onPressed: () {
                        // CHANGED: hide the persistent bottom sheet using controller flag
                        subController.showBottomSheet.value = false;
                      },
                      label: const Text("Close", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      onPressed: () async {
                        // CHANGED: pass the real packageId (string) to createSubscription
                        await subController.createSubscription(
                          userId: uid,
                          packageId: packageId,
                          serviceId:packageData['services'],
                          type: "package",
                          durationMonths: packageData['durationMonths'],
                        );
                        subController.hasActiveSubscription.value = true;
                        subController.showBottomSheet.value = false;
                        Get.snackbar("Subscribed", "$pkgName subscribed successfully");
                      },
                      child: Text("Buy : $pkgPrice", style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }
        return SizedBox.shrink();
      }
      ),

    );
  }
}
