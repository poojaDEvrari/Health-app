import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relax_doc/services/auth_guard.dart';
import 'package:relax_doc/theme/app_theme.dart';
import 'package:relax_doc/screens/category_products_screen.dart';
import 'package:relax_doc/screens/equipment_products_screen.dart';
import 'package:relax_doc/services/product_service.dart';
import 'package:relax_doc/models/product.dart';
import 'package:relax_doc/services/auth_guard.dart';
import 'package:relax_doc/screens/product_detail_screen.dart';
import 'package:relax_doc/models/cart_item.dart';
import 'package:relax_doc/services/cart_service.dart';
import 'package:relax_doc/services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _ServicesBanner extends StatelessWidget {
  const _ServicesBanner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: null,
      ),
    );
  }
}

class _ServicePill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ServicePill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Text(text, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

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
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  image: product.imagesUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(product.imagesUrl.first),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: product.imagesUrl.isEmpty
                    ? const Icon(Icons.image_not_supported_outlined, size: 32, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              '₹${product.discountedPrice?.toStringAsFixed(2) ?? 'N/A'}',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            if (product.discount != null && product.discount! > 0) ...[
              const SizedBox(height: 4),
              Text(
                'Save ${product.discount}%',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
// Add this class to your home_screen.dart file
// Place it near the other widget classes (like _ProductCard, _CategoryTile, etc.)

class _SmallProductCard extends StatelessWidget {
  final Product product;
  const _SmallProductCard({Key? key, required this.product}) : super(key: key);

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
        width: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  image: product.imagesUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(product.imagesUrl.first),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: product.imagesUrl.isEmpty
                    ? const Center(
                        child: Icon(Icons.image_not_supported_outlined,
                            size: 28, color: Colors.grey),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '₹${product.discountedPrice?.toStringAsFixed(0) ?? 'N/A'}',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            if (product.discount != null && product.discount! > 0)
              Text(
                '${product.discount}% OFF',
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  final ok = await AuthGuard.ensureLoggedIn(context);
                  if (!ok) return;
                  await CartService.addOrIncrement(CartItem(
                    productId: product.id,
                    title: product.title,
                    imageUrl: product.imagesUrl.isNotEmpty ? product.imagesUrl.first : '',
                    price: product.discountedPrice,
                    mrp: product.originalPrice,
                    quantity: 1,
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
                },
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 6)),
                child: const Text('ADD', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _IconTile extends StatelessWidget {
  final String label;
  const _IconTile({required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromRGBO(231, 134, 96, 0.6), Color.fromRGBO(255, 255, 250, 2)],
              stops: [0.6, 1.0],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.medical_services_outlined, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _GradientPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final double height;
  final Widget child;
  const _GradientPanel({
    required this.title,
    required this.subtitle,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.fromRGBO(233, 136, 98, 0.6), Color.fromRGBO(255, 255, 250, 0.6)],
          stops: [0.6, 1.0],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.primary)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _PartnerBadge extends StatelessWidget {
  const _PartnerBadge();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: const Icon(Icons.local_hospital_outlined, color: AppColors.primary),
        ),
        const SizedBox(height: 6),
        Text('Partner', style: GoogleFonts.poppins(fontSize: 12)),
      ],
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _cities = const ['Use current location', 'Mumbai', 'Pune', 'Delhi', 'Bengaluru'];
  String _selectedCity = '';
  
  // State variables for API data
  List<Product> _newEquipment = [];
  List<Product> _usedEquipment = [];
  List<Product> _bestSellingProducts = [];
  List<String> _categories = [];
  List<Map<String, dynamic>> _featuredPartners = [];
  bool _isLoading = true;
  String _error = '';

  // Demo popular categories with images (used while backend is offline)
  final List<Map<String, String>> _popularCatsDemo = const [
    {
      'label': 'Ayurvedic',
      'image': 'https://images.unsplash.com/photo-1505575967455-40e256f73376?w=400'
    },
    {
      'label': 'Wellness',
      'image': 'https://images.unsplash.com/photo-1576092768242-2a903fd2bb35?w=400'
    },
    {
      'label': 'Cardio Care',
      'image': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=400'
    },
    {
      'label': 'Skin Care',
      'image': 'https://images.unsplash.com/photo-1585238342028-4bbc2be9d9f5?w=400'
    },
    {
      'label': 'Women Care',
      'image': 'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?w=400'
    },
    {
      'label': 'Oxygen Mask',
      'image': 'https://images.unsplash.com/photo-1584988299603-ec3c5b0bdb2d?w=400'
    },
    {
      'label': 'Diabetic Care',
      'image': 'https://images.unsplash.com/photo-1582719478250-9ff3f0c0b454?w=400'
    },
    {
      'label': 'Monitoring Devices',
      'image': 'https://images.unsplash.com/photo-1516549655169-df83a077451f?w=400'
    },
  ];

  @override
  void initState() {
    super.initState();
    _initLocation();
    _fetchData();
  }

  Future<void> _initLocation() async {
    final saved = await LocationService.loadSaved();
    if (!mounted) return;
    if (saved != null && saved.isNotEmpty) {
      setState(() => _selectedCity = saved);
    } else {
      final city = await LocationService.fetchCurrentCity();
      if (!mounted) return;
      if (city != null && city.isNotEmpty) setState(() => _selectedCity = city);
    }
  }

  Future<void> _fetchData() async {
    try {
      setState(() => _isLoading = true);
      
      // Fetch data in parallel
      final results = await Future.wait([
        ProductService.getNewEquipment(),
        ProductService.getUsedEquipment(),
        ProductService.getBestSellingProducts(),
        ProductService.getCategories(),
        ProductService.getFeaturedPartners(),
      ]);

      setState(() {
        _newEquipment = results[0] as List<Product>;
        _usedEquipment = results[1] as List<Product>;
        _bestSellingProducts = results[2] as List<Product>;
        _categories = results[3] as List<String>;
        _featuredPartners = (results[4] as List).cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (e) {
      _seedDummyData();
    }
  }

  void _seedDummyData() {
    final demoImages = [
      'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800',
      'https://images.unsplash.com/photo-1580281657527-47e59f6b9c79?w=800',
      'https://images.unsplash.com/photo-1580281780460-82d2167f8c08?w=800',
    ];

    Product p({
      required int id,
      required String title,
      required String category,
      required bool isNew,
    }) => Product(
          id: id,
          title: title,
          description: 'High quality medical product for daily use.',
          keyFeatures: ['Durable', 'Reliable', 'Certified'],
          discountedPrice: 9999.0,
          originalPrice: 12999.0,
          productType: isNew ? 'equipment_new' : 'equipment_used',
          productCategory: category,
          imagesUrl: demoImages,
          vendorId: 1,
          soldByVendorName: 'Demo Vendor',
          // discount: 20, // Uncomment if your Product model supports this
        );

    final demoNew = [
      p(id: 1, title: 'ECG Machine', category: 'New Equipment', isNew: true),
      p(id: 2, title: 'Syringe Pump', category: 'New Equipment', isNew: true),
    ];
    final demoUsed = [
      p(id: 3, title: 'Ventilator', category: 'Used Equipment', isNew: false),
      p(id: 4, title: 'X-Ray Unit', category: 'Used Equipment', isNew: false),
    ];
    final demoBest = [
      p(id: 5, title: 'BP Monitor', category: 'Monitors', isNew: true),
      p(id: 6, title: 'Nebulizer', category: 'Home Care', isNew: true),
      p(id: 7, title: 'Pulse Oximeter', category: 'Diagnostics', isNew: true),
    ];
    final demoCats = [
      'New Equipment',
      'Used Equipment',
      'Diagnostics',
      'Monitors',
      'Home Care',
      'Surgical',
      'Orthopedic',
      'Dental',
    ];

    setState(() {
      _newEquipment = demoNew;
      _usedEquipment = demoUsed;
      _bestSellingProducts = demoBest;
      _categories = demoCats;
      _featuredPartners = [
        {'name': 'Partner A', 'logo': ''},
        {'name': 'Partner B', 'logo': ''},
      ];
      _isLoading = false;
      _error = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.lightBgGradient,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error.isNotEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(_error, style: const TextStyle(color: Colors.red)),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Location and search bar
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on_outlined, color: AppColors.primary),
                                const SizedBox(width: 6),
                                DropdownButton<String>(
                                  value: _selectedCity.isEmpty ? null : _selectedCity,
                                  underline: const SizedBox.shrink(),
                                  style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
                                  hint: Text('Select location', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                  items: _cities.map((c) => DropdownMenuItem<String>(value: c, child: Text(c))).toList(),
                                  onChanged: (v) async {
                                    if (v == null) return;
                                    if (v == 'Use current location') {
                                      final city = await LocationService.fetchCurrentCity();
                                      if (!mounted) return;
                                      if (city != null && city.isNotEmpty) {
                                        setState(() => _selectedCity = city);
                                      }
                                    } else {
                                      await LocationService.save(v);
                                      if (!mounted) return;
                                      setState(() => _selectedCity = v);
                                    }
                                  },
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.notifications_none, color: Colors.black),
                                ),
                                IconButton(
                                  tooltip: 'Logout',
                                  onPressed: () => AuthGuard.logout(context),
                                  icon: const Icon(Icons.logout, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search for "Medicine"',
                                hintStyle: GoogleFonts.poppins(color: Colors.black),
                                prefixIcon: const Icon(Icons.search, color: Colors.black),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.black.withOpacity(.1)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.black.withOpacity(.1)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Services Banner moved below Equipment section

                          // New & Used Equipment Section
                          const SizedBox(height: 16),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Equipment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 130,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              children: [
                                _EquipmentCard(
                                  title: 'New Equipment',
                                  count: _newEquipment.length,
                                  icon: Icons.medical_services,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const EquipmentProductsScreen(
                                          categoryTitle: 'New Equipment',
                                          isNewEquipment: true,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                _EquipmentCard(
                                  title: 'Used Equipment',
                                  count: _usedEquipment.length,
                                  icon: Icons.medical_information,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const EquipmentProductsScreen(
                                          categoryTitle: 'Used Equipment',
                                          isNewEquipment: false,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                _EquipmentCard(
                                  title: 'Rent Equipment',
                                  count: 8,
                                  icon: Icons.shopping_cart_outlined,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Rent Equipment coming soon')),
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                _EquipmentCard(
                                  title: 'Loan Assistance',
                                  count: 4,
                                  icon: Icons.volunteer_activism_outlined,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Loan Assistance coming soon')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Banner now appears here after Equipment
                          const SizedBox(height: 16),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: _ServicesBanner(),
                          ),
                          const SizedBox(height: 16),


                          // Gradient Best Selling panel (as per mock)
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: _GradientPanel(
                              title: 'Best Selling Product',
                              subtitle: 'Now at Special Discount',
                              height: 330,
                              child: SizedBox(
                                height: 210,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  itemBuilder: (context, i) => _SmallProductCard(
                                    product: _bestSellingProducts[i % _bestSellingProducts.length],
                                  ),
                                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                                  itemCount: _bestSellingProducts.isEmpty ? 0 : _bestSellingProducts.length.clamp(0, 10),
                                ),
                              ),
                            ),
                          ),
                          // (duplicate Best Selling panel removed)

                const SizedBox(height: 16),

                // Savings grid panel
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _GradientPanel(
                    title: 'Popular Categories',
                    subtitle: 'Now with Bigger Savings',
                    height: 280,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _popularCatsDemo.length,
                      itemBuilder: (_, i) {
                        final label = _popularCatsDemo[i]['label']!;
                        final image = _popularCatsDemo[i]['image']!;
                        return _PopularCategoryCard(
                          label: label,
                          imageUrl: image,
                          onTap: () {
                            final allCats = <String>{
                              ..._categories,
                              ..._popularCatsDemo.map((e) => e['label']!),
                            }.toList();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryProductsScreen(
                                  categoryTitle: label,
                                  categories: allCats,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Featured partners footer
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Featured Partners',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.primary),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 100, // Increased height to accommodate the badge and text
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, i) => const _PartnerBadge(),
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemCount: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _CategoryTile({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4), // Add small bottom margin
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8, // Slightly reduced blur
              offset: const Offset(0, 2), // Reduced shadow offset
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8), // Adjusted padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.medical_services_outlined, 
                color: AppColors.primary,
                size: 18, // Slightly smaller icon
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label.replaceAll('_', ' ').toUpperCase(),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: AppColors.textMuted, 
                fontWeight: FontWeight.w600, 
                fontSize: 9, // Slightly smaller font
                height: 1.1, // Tighter line height
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _EquipmentCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final VoidCallback onTap;

  const _EquipmentCard({
    Key? key,
    required this.title,
    required this.count,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '$count items',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularCategoryCard extends StatelessWidget {
  final String label;
  final String imageUrl;
  final VoidCallback onTap;

  const _PopularCategoryCard({
    Key? key,
    required this.label,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600),
      ),
    );
  }
}
