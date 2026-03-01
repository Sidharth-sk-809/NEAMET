import 'package:flutter/services.dart';

class ProductImageHelper {

  static Future<String> getProductImage(String productName) async {
    final normalizedName = productName.trim();

    final imagePath = "assets/products/$normalizedName.png";

    try {
      // Check if image exists
      await rootBundle.load(imagePath);
      return imagePath;
    } catch (e) {
      // If image not found → return General image
      return "assets/products/General.png";
    }
  }
}