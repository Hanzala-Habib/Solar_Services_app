import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  final Map<String, dynamic> serviceData;
  const OrderScreen({super.key, required this.serviceData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order ${serviceData['name']}"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text(
          "Order form for ${serviceData['name']} goes here",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
