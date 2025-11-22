import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relax_doc/theme/app_theme.dart';
import 'package:relax_doc/services/product_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _stock = TextEditingController();
  final _reviews = TextEditingController();
  final _rating = TextEditingController(text: '0');
  final _discountedPrice = TextEditingController();
  final _commission = TextEditingController(text: '0');
  final _discount = TextEditingController(text: '0');
  final _originalPrice = TextEditingController();
  final _productType = ValueNotifier<String>('NEW');
  final _productCategory = ValueNotifier<String>('medical_equipment');
  final _images = TextEditingController();
  final _videoUrl = TextEditingController();
  final _docUrl = TextEditingController();
  final _vendorName = TextEditingController();

  bool _submitting = false;
  final _picker = ImagePicker();
  final List<String> _uploadedImages = [];

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _price.dispose();
    _stock.dispose();
    _reviews.dispose();
    _rating.dispose();
    _discountedPrice.dispose();
    _commission.dispose();
    _discount.dispose();
    _originalPrice.dispose();
    _images.dispose();
    _videoUrl.dispose();
    _docUrl.dispose();
    _vendorName.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      final imageUrls = _images.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      final payload = {
        "title": _title.text,
        "description": _description.text,
        "key_features": [],
        "reviews": _reviews.text,
        "rating": double.tryParse(_rating.text) ?? 0,
        "discounted_price": int.tryParse(_discountedPrice.text) ?? int.tryParse(_price.text) ?? 0,
        "commision": int.tryParse(_commission.text) ?? 0,
        "discount": int.tryParse(_discount.text) ?? 0,
        "original_price": int.tryParse(_originalPrice.text) ?? int.tryParse(_price.text) ?? 0,
        "status": "AVAILABLE",
        "quantity_available": int.tryParse(_stock.text) ?? 0,
        "product_type": _productType.value,
        "product_category": _productCategory.value,
        "images_url": imageUrls,
        "videos_url": _videoUrl.text,
        "product_documents": _docUrl.text,
        "sold_by_vendor_name": _vendorName.text,
      };

      await ProductService.createProduct(payload);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product created successfully')));
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Create failed: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  InputDecoration _input(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.black.withOpacity(.1))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.black.withOpacity(.1))),
        focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppColors.primary, width: 2)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Equipment',
          style: GoogleFonts.poppins(color: AppColors.primary, fontWeight: FontWeight.w700),
        ),
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Upload Product Image', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.black87)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                            if (picked == null) return;
                            final url = await ProductService.uploadToS3(File(picked.path));
                            _uploadedImages.add(url);
                            _images.text = _uploadedImages.join(',');
                            if (mounted) setState(() {});
                          },
                          icon: const Icon(Icons.cloud_upload_outlined),
                          label: const Text('Pick & Upload'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _images,
                            decoration: _input('Comma separated image URLs'),
                            validator: (v) => (v == null || v.isEmpty) ? 'Enter at least one image URL' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Equipment Name', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.black87)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _title,
                      decoration: _input('e.g. Electric ICU Hospital Bed'),
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    Text('Description', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.black87)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _description,
                      decoration: _input('Enter a detailed description'),
                      minLines: 3,
                      maxLines: 5,
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _price,
                            keyboardType: TextInputType.number,
                            decoration: _input('Price (₹)'),
                            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _stock,
                            keyboardType: TextInputType.number,
                            decoration: _input('Stock'),
                            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: TextFormField(controller: _originalPrice, keyboardType: TextInputType.number, decoration: _input('Original Price'))),
                        const SizedBox(width: 12),
                        Expanded(child: TextFormField(controller: _discountedPrice, keyboardType: TextInputType.number, decoration: _input('Discounted Price'))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: TextFormField(controller: _discount, keyboardType: TextInputType.number, decoration: _input('Discount %'))),
                        const SizedBox(width: 12),
                        Expanded(child: TextFormField(controller: _commission, keyboardType: TextInputType.number, decoration: _input('Commission %'))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: TextFormField(controller: _rating, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: _input('Rating (e.g. 4.7)'))),
                        const SizedBox(width: 12),
                        Expanded(child: TextFormField(controller: _reviews, decoration: _input('Short review'))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _productType.value,
                            items: const [
                              DropdownMenuItem(value: 'NEW', child: Text('NEW')),
                              DropdownMenuItem(value: 'USED', child: Text('USED')),
                            ],
                            onChanged: (v) => _productType.value = v ?? 'NEW',
                            decoration: _input('Product Type'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _productCategory.value,
                            items: const [DropdownMenuItem(value: 'medical_equipment', child: Text('medical_equipment'))],
                            onChanged: (v) => _productCategory.value = v ?? 'medical_equipment',
                            decoration: _input('Product Category'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final picked = await _picker.pickVideo(source: ImageSource.gallery);
                            if (picked == null) return;
                            final url = await ProductService.uploadToS3(File(picked.path));
                            _videoUrl.text = url;
                            if (mounted) setState(() {});
                          },
                          icon: const Icon(Icons.cloud_upload_outlined),
                          label: const Text('Upload Video'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: TextFormField(controller: _videoUrl, decoration: _input('Video URL'))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(controller: _docUrl, decoration: _input('Product document URL (PDF)')),
                    const SizedBox(height: 12),
                    TextFormField(controller: _vendorName, decoration: _input('Sold by vendor name')),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _save,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                        ),
                        child: Text(_submitting ? 'Saving...' : 'Save Product'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
