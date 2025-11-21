import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relax_doc/models/product.dart';
import 'package:relax_doc/services/product_service.dart';
import 'package:relax_doc/theme/app_theme.dart';
import 'package:relax_doc/services/auth_guard.dart';
import 'package:relax_doc/screens/product_detail_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryTitle;
  final List<String> categories; // left side list
  const CategoryProductsScreen({super.key, required this.categoryTitle, required this.categories});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.categoryTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(selectedCategory, style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        actions: const [
          Icon(Icons.search_outlined),
          SizedBox(width: 8),
          Icon(Icons.shopping_bag_outlined),
          SizedBox(width: 12),
        ],
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.lightBgGradient,
          ),
        ),
        child: Row(
          children: [
            // Left categories vertically
            Container(
              width: 110,
              decoration: const BoxDecoration(color: Colors.white),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (_, i) {
                  final cat = widget.categories[i];
                  final isSel = cat == selectedCategory;
                  return InkWell(
                    onTap: () => setState(() => selectedCategory = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: isSel ? AppColors.primary : Colors.transparent, width: 4),
                        ),
                        color: isSel ? AppColors.primary.withOpacity(.06) : Colors.transparent,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: widget.categories.length,
              ),
            ),
            // Right products list
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: ProductService.getAllProducts(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }
                  if (snap.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Failed to load products\n${snap.error}', textAlign: TextAlign.center),
                      ),
                    );
                  }
                  final products = (snap.data ?? [])
                      .where((p) => selectedCategory.isEmpty || (p.productCategory ?? '').toLowerCase() == selectedCategory.toLowerCase())
                      .toList();

                  if (products.isEmpty) {
                    return const Center(child: Text('No products found'));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                    itemBuilder: (_, i) => _ProductRow(product: products[i]),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: products.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final Product product;
  const _ProductRow({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final ok = await AuthGuard.ensureLoggedIn(context);
        if (!ok) return;
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
        );
      },
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 92,
              height: 92,
              color: Colors.grey.shade200,
              child: product.imagesUrl.isNotEmpty
                  ? Image.network(product.imagesUrl.first, fit: BoxFit.cover)
                  : const Icon(Icons.image_not_supported_outlined),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                if (product.rating != null)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.green, size: 16),
                      const SizedBox(width: 4),
                      Text('${product.rating}', style: GoogleFonts.poppins(fontSize: 12)),
                    ],
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('₹${product.discountedPrice}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    if (product.originalPrice != null)
                      Text('₹${product.originalPrice}', style: GoogleFonts.poppins(decoration: TextDecoration.lineThrough, color: Colors.black54, fontSize: 12)),
                    if (product.discount != null) ...[
                      const SizedBox(width: 6),
                      Text('${product.discount}% off', style: GoogleFonts.poppins(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        final ok = await AuthGuard.ensureLoggedIn(context);
                        if (!ok) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart (to be implemented)')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('ADD'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () async {
                        final ok = await AuthGuard.ensureLoggedIn(context);
                        if (!ok) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Proceed to buy (to be implemented)')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('BUY NOW'),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
