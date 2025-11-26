import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relax_doc/models/cart_item.dart';
import 'package:relax_doc/services/cart_service.dart';
import 'package:relax_doc/services/product_service.dart';
import 'package:relax_doc/theme/app_theme.dart';
import 'package:relax_doc/services/location_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = CartService.getItems();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = CartService.getItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: const [SizedBox(width: 12)],
      ),
      body: FutureBuilder<List<CartItem>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final items = snap.data ?? [];
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              children: [
                FutureBuilder<String?>(
                  future: LocationService.loadSaved(),
                  builder: (context, snap) {
                    final city = snap.data ?? '';
                    return Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Delivering to ${city.isEmpty ? 'Your location' : city}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                              Text('India', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 12)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final c = await LocationService.fetchCurrentCity();
                            if (!mounted) return;
                            setState(() {});
                          },
                          child: const Text('Change'),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(12)),
                  child: Text('₹ 172 Saved on this Order', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.green.shade900)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.local_shipping_outlined, color: Colors.black87),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Delivering by 7-10 November', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
                  ],
                ),
                const Divider(height: 24),

                ...items.map((e) => _CartItemTile(item: e, onChanged: _refresh)).toList(),

                const Divider(height: 24),
                Row(children: [
                  const Icon(Icons.percent, color: Colors.black87),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Apply Coupon', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
                  const Icon(Icons.chevron_right),
                ]),

                const Divider(height: 24),
                Row(children: [
                  const Icon(Icons.shopping_cart_checkout_outlined, color: Colors.black87),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Before you checkout', style: GoogleFonts.poppins(fontWeight: FontWeight.w700))),
                ]),
                const SizedBox(height: 8),
                _Recommendations(),

                const SizedBox(height: 12),
                Text('Bill Summary', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                FutureBuilder<num>(
                  future: CartService.subtotalMrp(),
                  builder: (context, mrpSnap) {
                    final mrp = mrpSnap.data ?? 0;
                    return FutureBuilder<num>(
                      future: CartService.subtotalPayable(),
                      builder: (context, paySnap) {
                        final pay = paySnap.data ?? 0;
                        final discount = (mrp - pay).clamp(0, double.infinity);
                        const handling = 10;
                        const delivery = 0;
                        final total = pay + handling + delivery;
                        return Column(
                          children: [
                            _row('Item Total (MRP)', '₹ ${mrp.toStringAsFixed(0)}'),
                            _row('Handling Charges', '₹ $handling'),
                            _row('Total Discount', '-₹ ${discount.toStringAsFixed(0)}', color: Colors.green),
                            _row('Delivery Fee', delivery == 0 ? 'FREE' : '₹ $delivery', color: Colors.green),
                            const Divider(),
                            _row('Total amount', '₹ ${total.toStringAsFixed(0)}', isBold: true),
                          ],
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),
                Text('Payment Method', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
                  child: Row(children: [
                    Expanded(child: Text('Pay With RazorPay', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.primary))),
                    const Icon(Icons.chevron_right, color: AppColors.primary),
                  ]),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Confirm and Pay'),
          ),
        ),
      ),
    );
  }

  Widget _row(String a, String b, {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Expanded(child: Text(a, style: GoogleFonts.poppins(color: Colors.black87, fontWeight: isBold ? FontWeight.w700 : FontWeight.w500))),
        Text(b, style: GoogleFonts.poppins(color: color ?? Colors.black87, fontWeight: isBold ? FontWeight.w700 : FontWeight.w600)),
      ]),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final Future<void> Function() onChanged;
  const _CartItemTile({required this.item, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 56,
              height: 56,
              color: Colors.grey.shade200,
              child: item.imageUrl.isEmpty
                  ? const Icon(Icons.image_not_supported_outlined)
                  : Image.network(item.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Row(children: [
                _QtyButton(icon: Icons.remove, onTap: () async {
                  final q = item.quantity - 1;
                  await CartService.setQuantity(item.productId, q);
                  await onChanged();
                }),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('${item.quantity}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700))),
                _QtyButton(icon: Icons.add, onTap: () async {
                  final q = item.quantity + 1;
                  await CartService.setQuantity(item.productId, q);
                  await onChanged();
                }),
                const Spacer(),
                Text('₹ ${item.price}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                if (item.mrp != null)
                  Text('₹ ${item.mrp}', style: GoogleFonts.poppins(color: Colors.black54, decoration: TextDecoration.lineThrough, fontSize: 12)),
              ]),
            ]),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              await CartService.remove(item.productId);
              await onChanged();
            },
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final Future<void> Function() onTap;
  const _QtyButton({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(border: Border.all(color: AppColors.primary), borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}

class _Recommendations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ProductService.getBestSellingProducts(),
      builder: (context, snap) {
        final list = snap.data ?? [];
        return SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, i) {
              final p = list[i];
              return Container(
                width: 170,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)),
                padding: const EdgeInsets.all(8),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        color: Colors.grey.shade200,
                        child: p.imagesUrl.isEmpty
                            ? const Icon(Icons.image_not_supported_outlined)
                            : Image.network(p.imagesUrl.first, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(p.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 12)),
                  const SizedBox(height: 6),
                  Row(children: [
                    Text('₹${p.discountedPrice}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                    const SizedBox(width: 6),
                    if (p.originalPrice != null)
                      Text('₹${p.originalPrice}', style: GoogleFonts.poppins(decoration: TextDecoration.lineThrough, color: Colors.black54, fontSize: 12)),
                  ]),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        await CartService.addOrIncrement(CartItem(
                          productId: p.id,
                          title: p.title,
                          imageUrl: p.imagesUrl.isNotEmpty ? p.imagesUrl.first : '',
                          price: p.discountedPrice,
                          mrp: p.originalPrice,
                          quantity: 1,
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
                      },
                      child: const Text('ADD'),
                    ),
                  )
                ]),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: list.length,
          ),
        );
      },
    );
  }
}
