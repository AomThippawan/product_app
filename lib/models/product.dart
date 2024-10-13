// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String productName;
  String productType;
  int price;
  String unit;
  String id;

  ProductModel({
    required this.productName,
    required this.productType,
    required this.price,
    required this.unit,
    required this.id,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        productName: json["product_name"],
        productType: json["product_type"],
        price: json["price"],
        unit: json["unit"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "product_type": productType,
        "price": price,
        "unit": unit,
        "_id": id,
      };
}
