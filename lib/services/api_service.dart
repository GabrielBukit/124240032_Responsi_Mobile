import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com/products';

  // Mengambil daftar semua produk
  static Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat produk (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat data: $e');
    }
  }

  // Mengambil detail produk berdasarkan ID
  static Future<Product> getProductDetail(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Product.fromJson(data);
      } else {
        throw Exception('Gagal memuat detail produk (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat memuat detail produk: $e');
    }
  }
}
