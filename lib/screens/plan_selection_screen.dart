import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relax_doc/theme/app_theme.dart';
import 'package:relax_doc/services/dashboard_service.dart';
import 'package:relax_doc/screens/vendor_dashboard_screen.dart';

class PlanSelectionScreen extends StatefulWidget {
  const PlanSelectionScreen({super.key});

  @override
  State<PlanSelectionScreen> createState() => _PlanSelectionScreenState();
}

class _PlanSelectionScreenState extends State<PlanSelectionScreen> {
  bool annual = false;
  int? selectedIndex;

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
                    ),
                    Expanded(
                      child: Text(
                        'Choose Your Plan',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _ToggleBar(
                  annual: annual,
                  onChanged: (v) => setState(() => annual = v),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    _PlanCard(
                      title: 'Pathlab',
                      price: annual ? '₹ 999/year' : '₹ 99/month',
                      subtitle: annual ? '₹83/month billed annually' : null,
                      benefits: [
                        'Get Pathlab Verified Seller Badge.',
                        'Showcase products in Pathlab Network.',
                        if (annual) ...['Basic analytics and reporting.', 'Email support (24–48 hours).'],
                      ],
                      selected: selectedIndex == 0,
                      onTap: () => setState(() => selectedIndex = 0),
                    ),
                    const SizedBox(height: 12),
                    _PlanCard(
                      title: 'Clinic',
                      price: annual ? '₹ 1999/year' : '₹ 199/month',
                      subtitle: annual ? '₹166/month billed annually' : null,
                      benefits: [
                        'Get Clinic Verified Seller Badge.',
                        'Direct connect with nearby clinics.',
                        if (annual) ...[
                          'Advanced analytics dashboard.',
                          'Priority email & chat support.',
                          'Featured product listings.',
                        ],
                      ],
                      selected: selectedIndex == 1,
                      onTap: () => setState(() => selectedIndex = 1),
                    ),
                    const SizedBox(height: 12),
                    _PlanCard(
                      title: 'Hospital',
                      price: annual ? '₹ 2999/year' : '₹ 299/month',
                      subtitle: annual ? '₹250/month billed annually' : null,
                      benefits: [
                        'Get Hospital Verified Seller Badge.',
                        'Connect with trusted hospitals easily.',
                        if (annual) ...[
                          'Premium analytics & insights.',
                          '24/7 priority phone support.',
                          'Dedicated account manager.',
                          'Custom branding options.',
                        ],
                      ],
                      selected: selectedIndex == 2,
                      onTap: () => setState(() => selectedIndex = 2),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: selectedIndex == null
                            ? null
                            : () async {
                                try {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => const Center(child: CircularProgressIndicator()),
                                  );
                                  final dashboard = await DashboardService.fetchVendorDashboard();
                                  final stats = await DashboardService.fetchVendorDashboardStats();
                                  if (!mounted) return;
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => VendorDashboardScreen(dashboard: dashboard, stats: stats),
                                    ),
                                  );
                                } catch (e) {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop();
                                  }
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to load dashboard: $e')),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: const Text('Select Plan and Continue'),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('Cancel Anytime. No Hidden Fee!', style: GoogleFonts.poppins(color: Colors.black54, fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleBar extends StatelessWidget {
  final bool annual;
  final ValueChanged<bool> onChanged;
  const _ToggleBar({required this.annual, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4EA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x22000000)),
      ),
      child: Row(
        children: [
          _ToggleChip(label: 'Monthly', selected: !annual, onTap: () => onChanged(false)),
          const SizedBox(width: 6),
          Expanded(child: _ToggleChip(label: 'Annual', selected: annual, onTap: () => onChanged(true), badge: '20% off')),
        ],
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;
  const _ToggleChip({required this.label, required this.selected, required this.onTap, this.badge});

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: GoogleFonts.poppins(color: selected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600)),
          if (badge != null) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFF28C76F), borderRadius: BorderRadius.circular(12)),
              child: Text(badge!, style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
            )
          ]
        ],
      ),
    );
    return Expanded(child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18), child: Center(child: child)));
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String? subtitle;
  final List<String> benefits;
  final bool selected;
  final VoidCallback onTap;
  const _PlanCard({required this.title, required this.price, this.subtitle, required this.benefits, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFE4DB), Color(0xFFFFFFFF)]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppColors.primary : const Color(0x33F06A48), width: selected ? 2 : 1),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_hospital_outlined, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 8),
            Text(price, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800)),
            if (subtitle != null) Text(subtitle!, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 8),
            ...benefits.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, size: 18, color: Color(0xFF28C76F)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(b, style: GoogleFonts.poppins(fontSize: 13))),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
