import 'dart:convert';
import 'package:crmproject/data/models/product_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  var products = <ProductModel>[].obs;
  var isLoading = true.obs;

  final String baseUrl = "https://yourstore.com/wp-json/wc/v3";
  final String consumerKey = "ck_xxxxxxxxxxxxx";  // replace with your key
  final String consumerSecret = "cs_xxxxxxxxxxxxx";

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(
          "$baseUrl/products?consumer_key=$consumerKey&consumer_secret=$consumerSecret"));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        products.value =
            data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        Get.snackbar("Error", "Failed to fetch products");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
