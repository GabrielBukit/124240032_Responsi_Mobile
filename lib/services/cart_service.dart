import 'package:hive/hive.dart';
import '../models/product_model.dart';

class CartService {
  static const String boxName = 'cartBox';

  static Box get _box => Hive.box(boxName);

  // Cek apakah suatu produk sudah ada di keranjang
  static bool isInCart(int productId) {
    return _box.containsKey(productId);
  }

  // Menambahkan produk ke keranjang Hive
  static Future<void> addToCart(Product product) async {
    await _box.put(product.id, product.toJson());
  }

  // Menghapus produk dari keranjang berdasarkan ID produk
  static Future<void> removeFromCart(int productId) async {
    await _box.delete(productId);
  }

  // Mengambil semua produk yang ada di dalam keranjang
  static List<Product> getCartItems() {
    final List<Product> items = [];
    for (var key in _box.keys) {
      final data = _box.get(key);
      if (data != null && data is Map) {
        items.add(Product.fromJson(Map<String, dynamic>.from(data)));
      }
    }
    return items;
  }

  // Mengambil jumlah produk unik di keranjang untuk Profile Page
  static int getCartCount() {
    return _box.length;
  }
}
