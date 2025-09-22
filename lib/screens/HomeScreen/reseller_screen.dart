import 'package:flutter/material.dart';

class ResellerScreen extends StatelessWidget {
  const ResellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reseller Screen",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Text("Manager Screen"),
      ),
    );
  }
}