import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relax_doc/models/product.dart';
import 'package:relax_doc/theme/app_theme.dart';
import 'package:relax_doc/services/auth_guard.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final images = p.imagesUrl.isNotEmpty
        ? p.imagesUrl
        : [
            'https://via.placeholder.com/800x600.png?text=No+Image',
          ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        leading: BackButton(
          onPressed: () async {
            final nav = Navigator.of(context);
            if (nav.canPop()) {
              nav.pop();
            } else {
              await nav.maybePop();
            }
          },
        ),
        actions: const [
          Icon(Icons.share_outlined),
          SizedBox(width: 8),
          Icon(Icons.favorite_border),
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Offer tag
                if (p.discount != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE4DB),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('${p.discount!.toStringAsFixed(0)}% OFF', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ),
                  ),
                const SizedBox(height: 10),

                // Image carousel
                Container(
                  height: 220,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (i) => setState(() => _page = i),
                        itemCount: images.length,
                        itemBuilder: (_, i) => Image.network(
                          images[i],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(images.length, (i) {
                            final active = i == _page;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              height: 6,
                              width: active ? 16 : 6,
                              decoration: BoxDecoration(
                                color: active ? AppColors.primary : Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Title + rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 18)),
                          const SizedBox(height: 4),
                          Text(p.soldByVendorName ?? 'Sold by vendor', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 12)),
                        ],
                      ),
                    ),
                    if (p.rating != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.green, size: 18),
                          const SizedBox(width: 4),
                          Text('${p.rating}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        ],
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // Feature chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if ((p.productType ?? '').isNotEmpty)
                      _chip(Icons.verified_outlined, p.productType!),
                    if ((p.productCategory ?? '').isNotEmpty)
                      _chip(Icons.category_outlined, p.productCategory!),
                    if (p.quantityAvailable != null)
                      _chip(Icons.inventory_2_outlined, '${p.quantityAvailable} in stock'),
                  ],
                ),

                const SizedBox(height: 12),

                // Description card
                _card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product Description', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(
                        (p.description.isEmpty ? 'No description available' : p.description),
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87, height: 1.35),
                      ),
                      if (p.keyFeatures.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: p.keyFeatures.take(6).map((f) => _chip(Icons.check_circle_outline, f)).toList(),
                        )
                      ]
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Price row
                _card(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('₹${p.discountedPrice}', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 20)),
                                const SizedBox(width: 8),
                                if (p.originalPrice != null)
                                  Text('₹${p.originalPrice}', style: GoogleFonts.poppins(decoration: TextDecoration.lineThrough, color: Colors.black54)),
                              ],
                            ),
                            if (p.discount != null)
                              Text('${p.discount}% off', style: GoogleFonts.poppins(color: Colors.green, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final ok = await AuthGuard.ensureLoggedIn(context);
                          if (!ok) return;
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact vendor (demo)')));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        icon: const Icon(Icons.phone_outlined),
                        label: const Text('Call'),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final ok = await AuthGuard.ensureLoggedIn(context);
                          if (!ok) return;
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart (demo)')));
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          foregroundColor: AppColors.primary,
                          minimumSize: const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Add to Cart', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final ok = await AuthGuard.ensureLoggedIn(context);
                          if (!ok) return;
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Buy now (demo)')));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Buy Now', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Similar products header (placeholder)
                Text('Similar Products', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.primary)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, i) => _similarCard(),
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemCount: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, -2))]),
          child: ElevatedButton(
            onPressed: () async {
              final ok = await AuthGuard.ensureLoggedIn(context);
              if (!ok) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added (demo)')));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Add', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                Text('₹${p.discountedPrice}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16, color: AppColors.primary), const SizedBox(width: 6), Text(label, style: GoogleFonts.poppins(fontSize: 12))],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10, offset: const Offset(0, 4)),
      ]),
      child: child,
    );
  }

  Widget _similarCard() {
    return Container(
      width: 140,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8, offset: const Offset(0, 4)),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: Image.network('https://via.placeholder.com/300x220.png', fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sample', maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('₹799', style: GoogleFonts.poppins()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
