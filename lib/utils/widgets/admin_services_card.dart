import 'package:flutter/material.dart';

class AdminServicesCard extends StatelessWidget {
  final VoidCallback onPressed;
  final String cardtext;
 AdminServicesCard({super.key, required this.onPressed,
   required this.cardtext});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onPressed ,
      child: Container(

        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow:[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,

            ),
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(cardtext,style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500
              ),),
                IconButton(
                  onPressed: onPressed,
                  icon: const Icon(Icons.arrow_forward_ios_sharp, size: 20,fontWeight:FontWeight.bold,),
                ),

            ],
          ),
        ),
      ),
    );
  }
}
