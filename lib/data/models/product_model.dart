class ProductModel {
  final int id;
  final String name;
  final String imageUrl;
  final String price;

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['images'] != null && json['images'].isNotEmpty
          ? json['images'][0]['src']
          : '',
      price: json['price'] ?? '0',
    );
  }
}
