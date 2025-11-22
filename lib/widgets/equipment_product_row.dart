import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relax_doc/models/product.dart';
import 'package:relax_doc/theme/app_theme.dart';
import 'package:relax_doc/services/auth_guard.dart';
import 'package:relax_doc/screens/product_detail_screen.dart';

class EquipmentProductRow extends StatelessWidget {
  final Product product;
  const EquipmentProductRow({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final ok = await AuthGuard.ensureLoggedIn(context);
        if (!ok) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image and basic info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 92,
                    height: 92,
                    color: Colors.grey.shade200,
                    child: product.imagesUrl.isNotEmpty
                        ? Image.network(
                            product.imagesUrl.first,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported_outlined),
                          )
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
                            Text(
                              '${product.rating}',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ],
                        ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            '₹${product.discountedPrice}',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 8),
                          if (product.originalPrice != null)
                            Text(
                              '₹${product.originalPrice}',
                              style: GoogleFonts.poppins(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          if (product.discount != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              '${product.discount}% off',
                              style: GoogleFonts.poppins(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.chat_bubble_outline,
                  label: 'Chat',
                  onPressed: () async {
                    final ok = await AuthGuard.ensureLoggedIn(context);
                    if (!ok) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Chat feature coming soon')),
                    );
                  },
                ),
                _buildActionButton(
                  context,
                  icon: Icons.shopping_cart_outlined,
                  label: 'Buy Now',
                  isFilled: true,
                  onPressed: () async {
                    final ok = await AuthGuard.ensureLoggedIn(context);
                    if (!ok) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Proceeding to checkout')),
                    );
                  },
                ),
                _buildActionButton(
                  context,
                  icon: Icons.calendar_today_outlined,
                  label: 'Rent',
                  onPressed: () async {
                    final ok = await AuthGuard.ensureLoggedIn(context);
                    if (!ok) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Rent feature coming soon')),
                    );
                  },
                ),
                _buildActionButton(
                  context,
                  icon: Icons.assignment_outlined,
                  label: 'Inspection',
                  onPressed: () async {
                    final ok = await AuthGuard.ensureLoggedIn(context);
                    if (!ok) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Inspection request sent')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isFilled = false,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 70,
      child: isFilled
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
