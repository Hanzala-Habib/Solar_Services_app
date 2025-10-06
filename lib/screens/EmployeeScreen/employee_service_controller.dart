import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeServiceController extends GetxController {
  final  _db = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  RxList<Map<String, dynamic>> requests = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  void fetchServices() {
    _db
        .collection("requests")
        .where("status", whereIn: ["pending", "claimed", "started"])
        .snapshots()
        .listen((snapshot) async {
      List<Map<String, dynamic>> tempRequests = [];

      for (var doc in snapshot.docs) {
        var data = doc.data();
        data["id"] = doc.id;

        // serviceId le kar services collection se details nikaal lo
        if (data["serviceId"] != null) {
          var serviceSnap =
          await _db.collection("services").doc(data["serviceId"]).get();
          if (serviceSnap.exists) {
            var serviceData = serviceSnap.data()!;
            data["title"] = serviceData["title"];
            data["price"] = serviceData["price"];
          }
        }

        // 🔹 Agar pending hai -> sabko dikhao
        // 🔹 Agar claimed hai -> sirf us employee ko dikhao jisne claim kiya
        if (data["status"] == "pending" ||
            (data["status"] != "pending" &&
                data["claimedBy"] == userId)) {
          tempRequests.add(data);
        }
      }

      requests.value = tempRequests;
    });
  }



  Future<void> claimService(String serviceId) async {
    await _db.collection("requests").doc(serviceId).update({
      "status": "claimed",
      "claimedBy": userId,
      "technicianId":userId
    });
  }

  Future<void> startService(String serviceId) async {
    await _db.collection("requests").doc(serviceId).update({
      "status": "started",
      "startTime": FieldValue.serverTimestamp(),
    });
  }

  Future<void> endService(String serviceId) async {
    await _db.collection("requests").doc(serviceId).update({
      "status": "completed",
      "endTime": FieldValue.serverTimestamp(),
    });
  }
}
