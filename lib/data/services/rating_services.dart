import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crmproject/screens/ClientScreen/client_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RatingService {

  static Future<void> checkAndShowRatingDialog(BuildContext context, String userId) async {
    final requests = await FirebaseFirestore.instance
        .collection('requests')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'completed')
        .where('rating', isEqualTo: null)
        .get();

    if (requests.docs.isEmpty) return;
    final doc = requests.docs.first;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(

        title: const Text("Rate our Service"),
        content:Container(
          height: 200,
          width: 400,
          child:  Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              _RatingStars(onRated: (rating) async {
                await doc.reference.update({'rating': rating});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Thanks for your feedback!")),
                );
              }),
            ],
          ),
        )
      ),
    );
  }
}

class _RatingStars extends StatefulWidget {
  final Function(int) onRated;

  _RatingStars({required this.onRated});

  @override
  State<_RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<_RatingStars> {


  @override
  Widget build(BuildContext context) {
    final controller=Get.put(ClientProfileController());
    return Container(
      width: 380,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
                (index) => IconButton(
              icon: Icon(
                index < controller.selected.value ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 30,
              ),
              onPressed: () {
                controller.selected.value=index+1;
                widget.onRated(controller.selected.value);
              },
            ),
          ),

      ),
    );
  }
}
