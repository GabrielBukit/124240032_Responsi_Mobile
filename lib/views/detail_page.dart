import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';
import 'cart_page.dart';

class DetailPage extends StatefulWidget {
  final int productId;

  const DetailPage({super.key, required this.productId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Product> _productFuture;
  bool _isInCart = false;

  @override
  void initState() {
    super.initState();
    _loadDetail();
    _checkCartStatus();
  }

  void _loadDetail() {
    setState(() {
      _productFuture = ApiService.getProductDetail(widget.productId);
    });
  }

  void _checkCartStatus() {
    setState(() {
      _isInCart = CartService.isInCart(widget.productId);
    });
  }

  void _addToCart(Product product) async {
    await CartService.addToCart(product);
    _checkCartStatus();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Produk berhasil dimasukkan ke keranjang!'),
        backgroundColor: Color(0xFF2E7D32),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const brandColor = Color.fromARGB(255, 78, 180, 83);
    const inCartColor = Color(0xFF5A5A5A); // Warna abu-abu gelap saat sudah di keranjang

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
          'Detail',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
            tooltip: 'Keranjang',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              ).then((_) {
                // Perbarui status keranjang saat kembali dari CartPage
                _checkCartStatus();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          // d. Ada loading indicator untuk saat load data detail produk
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color.fromARGB(255, 78, 180, 83)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 54, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      'Gagal memuat detail produk: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 78, 180, 83)),
                      onPressed: _loadDetail,
                      child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          final product = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // i. Gambar, sebagai hero image (paling atas & besar)
                      Container(
                        width: double.infinity,
                        height: 320,
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: Hero(
                          tag: 'product-${product.id}',
                          child: Image.network(
                            product.image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                          ),
                        ),
                      ),
                      const Divider(height: 1, thickness: 1),

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ii. Nama produk
                            Text(
                              product.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // iii. Harga
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // iv. Rating, serta jumlah reviewnya (misal: ★ 2.1 (430))
                            Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  '${product.rating.rate.toStringAsFixed(1)} (${product.rating.count})',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // v. Deskripsi Produk
                            const Text(
                              'Deskripsi Produk',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              product.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // vi. Serta button untuk user memasukkan produk ke keranjang
              // Button ini memiliki UI yang berbeda berdasarkan user memiliki produk tersebut di keranjang atau tidak
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isInCart ? null : () => _addToCart(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isInCart ? inCartColor : brandColor,
                        disabledBackgroundColor: inCartColor,
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isInCart ? 'Sudah di Keranjang' : 'Masukkan ke Keranjang',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
