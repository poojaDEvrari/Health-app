import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relax_doc/theme/app_theme.dart';
import 'package:relax_doc/services/auth_guard.dart';
import 'package:relax_doc/screens/add_new_product_screen.dart';
import 'package:relax_doc/screens/my_products_screen.dart';

class VendorDashboardScreen extends StatelessWidget {
  final Map<String, dynamic> dashboard;
  final Map<String, dynamic> stats;
  const VendorDashboardScreen({super.key, required this.dashboard, required this.stats});

  Widget _metric(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0x11000000)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 6),
          Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Seller Dashboard', style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => AuthGuard.logout(context),
          ),
        ],
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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.4,
                  ),
                  children: [
                    _metric('This Week Revenue', '₹ ${dashboard['todaysSales'] ?? 0}'),
                    _metric('Total Orders', '${dashboard['ordersCount'] ?? 0}'),
                    _metric('Total Active Products', '${dashboard['totalSales'] ?? 0}'),
                    _metric('Overall Rating', '${dashboard['averageOrderValue'] ?? 0}'),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Stats (Selected Range)', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.primary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _metric('Sales in Range', '₹ ${stats['salesInRange'] ?? 0}')),
                    const SizedBox(width: 12),
                    Expanded(child: _metric('Orders in Range', '${stats['ordersInRange'] ?? 0}')),
                  ],
                ),
                const SizedBox(height: 12),
                _metric('Average Order Value', '₹ ${stats['averageOrderValue'] ?? 0}'),
                const SizedBox(height: 20),
                Text('Revenue Graph', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.primary)),
                const SizedBox(height: 8),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x11000000)),
                  ),
                  alignment: Alignment.center,
                  child: Text('Monthly revenue points: ${(dashboard['monthlyRevenue'] ?? []).length}', style: GoogleFonts.poppins()),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const MyProductsScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          foregroundColor: AppColors.primary,
                          backgroundColor: Colors.white,
                          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                        ),
                        child: const Text('Manage Inventory'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const AddNewProductScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                        ),
                        child: const Text('Add New Product'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
