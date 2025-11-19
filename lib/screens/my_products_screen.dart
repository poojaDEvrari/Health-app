import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relax_doc/theme/app_theme.dart';
import 'package:relax_doc/services/product_service.dart';

class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({super.key});

  Future<void> _updateSampleProduct(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final payload = {
        "title": "AIIMS ICU Hospital Beds",
        "description": "5 function fully automatic ICU hospital bed with electric height & tilt controls.",
        "key_features": [
          "Electric height adjustable",
          "Backrest + Knee rest adjustment",
          "All side safety railing",
          "Remote control operations",
          "Medical grade stainless steel"
        ],
        "reviews": "Best quality ICU bed recommended for hospitals and home care.",
        "rating": 4.7,
        "discounted_price": 38000,
        "commision": 5,
        "discount": 12,
        "original_price": 43000,
        "status": "AVAILABLE",
        "quantity_available": 119,
        "product_type": "NEW",
        "product_category": "medical_equipment",
        "images_url": [
          "https://example.com/hospital-bed-1.jpg",
          "https://example.com/hospital-bed-2.jpg",
          "https://example.com/hospital-bed-3.jpg"
        ],
        "videos_url": "https://example.com/hospital-bed-demo.mp4",
        "product_documents": "https://example.com/hospital-bed-spec-sheet.pdf",
        "sold_by_vendor_name": "HealthCare Medical Supplies Pvt Ltd"
      };
      await ProductService.updateProduct(1, payload);
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully')),
      );
    } catch (e) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = const [
      {
        'title': 'Vitamin B Tablet',
        'image': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=400&q=60',
      },
      {
        'title': 'Thermometer',
        'image': 'https://images.unsplash.com/photo-1600959907703-125ba1374a12?auto=format&fit=crop&w=400&q=60',
      },
      {
        'title': 'Diabetes Care',
        'image': 'https://images.unsplash.com/photo-1582719508461-905c673771fd?auto=format&fit=crop&w=400&q=60',
      },
      {
        'title': 'Monitoring Device',
        'image': 'https://images.unsplash.com/photo-1581092160607-7e3c59d659cc?auto=format&fit=crop&w=400&q=60',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('My Products', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Your Products',
                    hintStyle: GoogleFonts.poppins(color: Colors.black54),
                    prefixIcon: const Icon(Icons.search, color: Colors.black87),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.black.withOpacity(.1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.black.withOpacity(.1)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Products', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 20)),
                      const SizedBox(height: 2),
                      Text('Manage and update your listed items', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 12)),
                      const SizedBox(height: 12),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: .9,
                        ),
                        itemCount: products.length,
                        itemBuilder: (_, i) {
                          final p = products[i];
                          return Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFFFE4DB), Color(0xFFFFFFFF)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8, offset: const Offset(0, 4))],
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                        child: Image.network(p['image']!, fit: BoxFit.cover),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                        border: const Border(
                                          top: BorderSide(color: Color(0x11000000)),
                                        ),
                                      ),
                                      child: Text(p['title']!, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => _updateSampleProduct(context),
                                      customBorder: const CircleBorder(),
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(14),
                                          boxShadow: [
                                            BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 6, offset: const Offset(0, 3)),
                                          ],
                                          border: Border.all(color: const Color(0x22F44336)),
                                        ),
                                        child: const Icon(Icons.edit, color: Color(0xFFF44336), size: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add, color: AppColors.primary),
                          label: Text('+ List Your Products', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppColors.primary)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            backgroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
