


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OrderController extends GetxController{
  final timeController=TextEditingController();
  final dateController=TextEditingController();
  DateTime? scheduledDate;

  void setDate(DateTime date) {
    scheduledDate = date;
  }





}