// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

class ProductModel {
  ProductModel({
    this.id,
    this.name,
    this.image,
    this.isVisible,
    this.isAvailable,
    this.foodItemCategory,
    this.price,
    this.stockItems,
  });

  final int? id;
  final String? name;
  final String? image;
  final int? isVisible;
  final int? isAvailable;
  final List<dynamic>? foodItemCategory;
  final List<Price>? price;
  final List<StockItem>? stockItems;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        isVisible: json["is_visible"],
        isAvailable: json["is_available"],
        foodItemCategory:
            List<dynamic>.from(json["food_item_category"].map((x) => x)),
        price: List<Price>.from(json["price"].map((x) => Price.fromJson(x))),
        stockItems: List<StockItem>.from(
            json["stock_items"].map((x) => StockItem.fromJson(x))),
      );
}

class Price {
  Price({
    this.originalPrice,
    this.discountedPrice,
    this.discountType,
    this.fixedValue,
    this.percentOf,
  });

  final int? originalPrice;
  final int? discountedPrice;
  final String? discountType;
  final int? fixedValue;
  final dynamic percentOf;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        originalPrice: json["original_price"],
        discountedPrice: json["discounted_price"],
        discountType: json["discount_type"],
        fixedValue: json["fixed_value"],
        percentOf: json["percent_of"],
      );
}

class StockItem {
  StockItem({
    this.quantity,
  });

  final int? quantity;

  factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
        quantity: json["quantity"],
      );
}
