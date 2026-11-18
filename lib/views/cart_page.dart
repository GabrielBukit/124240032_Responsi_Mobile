import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/cart_service.dart';
import 'detail_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Product> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() {
    setState(() {
      _cartItems = CartService.getCartItems();
    });
  }

  void _deleteItem(Product product) async {
    await CartService.removeFromCart(product.id);
    _loadCart();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} dihapus dari keranjang'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Keranjang',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 72,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Keranjang belanja Anda masih kosong',
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _cartItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final product = _cartItems[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    // b. Ketika produk di klik, akan menuju Detail Page dari produk tersebut
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(productId: product.id),
                      ),
                    ).then((_) {
                      _loadCart();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[200]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // i. Gambar
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Image.network(
                            product.image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 30, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Nama, harga & rating
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama
                              Text(
                                product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Harga
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),

                              // Rating
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 12, color: Colors.amber),
                                  const SizedBox(width: 3),
                                  Text(
                                    product.rating.rate.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // ii. Tombol delete untuk menghapus produk dari daftar keranjang
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 22),
                          onPressed: () => _deleteItem(product),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
