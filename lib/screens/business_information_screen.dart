import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relax_doc/theme/app_theme.dart';
import 'package:relax_doc/services/kyc_service.dart';
import 'package:relax_doc/screens/plan_selection_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BusinessInformationScreen extends StatefulWidget {
  const BusinessInformationScreen({super.key});

  @override
  State<BusinessInformationScreen> createState() => _BusinessInformationScreenState();
}


class _StepHeader extends StatelessWidget {
  final int current;
  const _StepHeader({required this.current});

  @override
  Widget build(BuildContext context) {
    Widget step(int index, String title) {
      final isDone = current > index;
      final isActive = current == index;
      final Color fill = isDone || isActive ? AppColors.primary : const Color(0xFFE0E0E0);
      final Color text = isDone || isActive ? Colors.white : Colors.black54;
      return Expanded(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: isDone
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : Text('${index + 1}', style: GoogleFonts.poppins(color: text, fontWeight: FontWeight.w700)),
                ),
                if (index < 2)
                  Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: current > index ? AppColors.primary : const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(title, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(color: const Color(0xFFF7F4EA), border: Border.all(color: const Color(0x22000000)), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          step(0, 'Personal Details'),
          step(1, 'Identity Verification'),
          step(2, 'Review & Submit'),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final String? filename;
  const _UploadTile({required this.label, this.onTap, this.filename});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 84,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_upload_outlined, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  if (filename != null)
                    Text(filename!, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String title;
  final VoidCallback onEdit;
  const _ReviewCard({required this.title, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700))),
          OutlinedButton(
            onPressed: onEdit,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Edit'),
          )
        ],
      ),
    );
  }
}

class _BusinessInformationScreenState extends State<BusinessInformationScreen> {
  int _step = 0; // 0,1,2
  bool _agreePrivacy = false;
  bool _agreeTerms = false;
  bool _submitting = false;

  // Controllers
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _streetAddress = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _pin = TextEditingController();
  final _country = TextEditingController();
  final _businessType = TextEditingController();
  final _yearsExp = TextEditingController();
  final _emergencyName = TextEditingController();
  final _emergencyPhone = TextEditingController();

  // Step 2
  final _documentType = TextEditingController();
  final _idType = TextEditingController();
  final _documentNumber = TextEditingController();
  final _vendorAddress = TextEditingController();
  final _hospitalAddress = TextEditingController();
  final _bankName = TextEditingController();
  final _accountNumber = TextEditingController();
  final _ifsc = TextEditingController();
  final _businessName = TextEditingController();
  final _gstNumber = TextEditingController();
  final _licenseNumber = TextEditingController();
  final _registrationDate = TextEditingController();

  // Upload files
  File? _fileAadhar;
  File? _filePan;
  File? _fileGst;
  File? _fileMedical;

  @override
  void dispose() {
    for (final c in [
      _fullName,
      _phone,
      _email,
      _streetAddress,
      _city,
      _state,
      _pin,
      _country,
      _businessType,
      _yearsExp,
      _emergencyName,
      _emergencyPhone,
      _documentType,
      _idType,
      _documentNumber,
      _vendorAddress,
      _hospitalAddress,
      _bankName,
      _accountNumber,
      _ifsc,
      _businessName,
      _gstNumber,
      _licenseNumber,
      _registrationDate,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['Personal Details', 'Identity Verification', 'Review & Submit'];
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
                        ),
                        Expanded(
                          child: Text(
                            titles[_step],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _StepHeader(current: _step),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: _buildStepContent(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Row(
                  children: [
                    if (_step > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _step -= 1),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: const BorderSide(color: AppColors.primary),
                            foregroundColor: AppColors.primary,
                            minimumSize: const Size.fromHeight(48),
                          ),
                          child: const Text('Back'),
                        ),
                      ),
                    if (_step > 0) const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: (_step == 0 && !_agreePrivacy)
                            ? null
                            : (_step == 1 && !_agreeTerms)
                                ? null
                                : () async {
                                    if (_step < 2) {
                                      setState(() => _step += 1);
                                      return;
                                    }
                                    if (_submitting) return;
                                    try {
                                      setState(() => _submitting = true);
                                      // Validate and normalize fields required by backend
                                      final phoneDigits = _phone.text.replaceAll(RegExp(r'\D'), '');
                                      if (phoneDigits.length != 10) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phone must be exactly 10 digits')));
                                        setState(() => _submitting = false);
                                        return;
                                      }
                                      final ifscNorm = _ifsc.text.trim().toUpperCase();
                                      final ifscOk = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(ifscNorm);
                                      if (!ifscOk) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid IFSC format')));
                                        setState(() => _submitting = false);
                                        return;
                                      }
                                      _phone.text = phoneDigits;
                                      _ifsc.text = ifscNorm;

                                      final payload = _buildKycPayload();
                                      await KycService.submitVendorKyc(
                                        payload,
                                        adharCard: _fileAadhar,
                                        panCard: _filePan,
                                        gstCertificate: _fileGst,
                                        medicalCertificate: _fileMedical,
                                      );
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('KYC submitted successfully')));
                                      if (!mounted) return;
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (_) => const PlanSelectionScreen()),
                                      );
                                    } catch (e) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Submit failed: $e')));
                                    } finally {
                                      if (mounted) setState(() => _submitting = false);
                                    }
                                  },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          minimumSize: const Size.fromHeight(52),
                        ),
                        child: _submitting
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : Text(_step < 2 ? (_step == 0 ? 'Continue to Verification' : 'Submit & Continue') : 'Submit Application'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    if (_step == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Enter your personal details', subtitle: 'Please provide accurate information to verify your vendor profile.'),
          SizedBox(height: 12),
          _PhotoPlaceholder(),
          SizedBox(height: 16),
          _GradientField(hint: 'Full Name *', controller: _fullName),
          SizedBox(height: 12),
          _GradientField(hint: 'Phone Number *', keyboardType: TextInputType.phone, controller: _phone),
          SizedBox(height: 12),
          _GradientField(hint: 'Email Address *', keyboardType: TextInputType.emailAddress, controller: _email),
          SizedBox(height: 12),
          _GradientField(hint: 'Street Address *', controller: _streetAddress),
          SizedBox(height: 12),
          _GradientField(hint: 'City *', controller: _city),
          SizedBox(height: 12),
          _GradientField(hint: 'State *', controller: _state),
          SizedBox(height: 12),
          _GradientField(hint: 'PIN Code *', keyboardType: TextInputType.number, controller: _pin),
          SizedBox(height: 12),
          _GradientField(hint: 'Country *', controller: _country),
          SizedBox(height: 12),
          _GradientField(hint: 'Type of Business', controller: _businessType),
          SizedBox(height: 12),
          _GradientField(hint: 'Years of Experience', controller: _yearsExp),
          SizedBox(height: 12),
          _GradientField(hint: 'Emergency Contact Name', controller: _emergencyName),
          SizedBox(height: 12),
          _GradientField(hint: 'Emergency Contact Number', keyboardType: TextInputType.phone, controller: _emergencyPhone),
          const SizedBox(height: 16),
          const _PrivacyNoticeCard(),
          const SizedBox(height: 8),
          _AgreementCheckboxTile(
            value: _agreePrivacy,
            onChanged: (v) => setState(() => _agreePrivacy = v ?? false),
            text:
                'I confirm that all the information provided is accurate and true to the best of my knowledge. I agree to the terms of service and privacy policy.',
          ),
          const SizedBox(height: 8),
        ],
      );
    }
    if (_step == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: 'Upload a proof of your identity', subtitle: 'Please provide valid identity documents to verify your account.'),
          SizedBox(height: 12),
          _GradientField(hint: 'Document Type', controller: _documentType),
          SizedBox(height: 12),
          _GradientField(hint: 'ID Type', controller: _idType),
          SizedBox(height: 12),
          _UploadTile(
            label: 'Upload Aadhar Card',
            onTap: () async {
              final picker = ImagePicker();
              final x = await picker.pickImage(source: ImageSource.gallery);
              if (x != null) setState(() => _fileAadhar = File(x.path));
            },
            filename: _fileAadhar?.path.split('/').last,
          ),
          SizedBox(height: 12),
          _UploadTile(
            label: 'Upload PAN Card',
            onTap: () async {
              final picker = ImagePicker();
              final x = await picker.pickImage(source: ImageSource.gallery);
              if (x != null) setState(() => _filePan = File(x.path));
            },
            filename: _filePan?.path.split('/').last,
          ),
          SizedBox(height: 16),
          _GradientField(hint: 'Document Number', controller: _documentNumber),
          SizedBox(height: 12),
          _GradientField(hint: 'Vendor Address', controller: _vendorAddress),
          SizedBox(height: 12),
          _GradientField(hint: 'Hospital Address', controller: _hospitalAddress),
          SizedBox(height: 12),
          _GradientField(hint: 'Bank Name', controller: _bankName),
          SizedBox(height: 12),
          _GradientField(hint: 'Account Number', controller: _accountNumber),
          SizedBox(height: 12),
          _GradientField(hint: 'IFSC Code', controller: _ifsc),
          SizedBox(height: 12),
          _GradientField(hint: 'Business Name', controller: _businessName),
          SizedBox(height: 12),
          _GradientField(hint: 'GST Number', controller: _gstNumber),
          SizedBox(height: 12),
          _GradientField(hint: 'Medical License Number', controller: _licenseNumber),
          SizedBox(height: 12),
          _GradientField(hint: 'Registration Date', controller: _registrationDate),
          SizedBox(height: 12),
          _UploadTile(
            label: 'GST Certificate',
            onTap: () async {
              final picker = ImagePicker();
              final x = await picker.pickImage(source: ImageSource.gallery);
              if (x != null) setState(() => _fileGst = File(x.path));
            },
            filename: _fileGst?.path.split('/').last,
          ),
          SizedBox(height: 12),
          _UploadTile(
            label: 'Medical Certificate',
            onTap: () async {
              final picker = ImagePicker();
              final x = await picker.pickImage(source: ImageSource.gallery);
              if (x != null) setState(() => _fileMedical = File(x.path));
            },
            filename: _fileMedical?.path.split('/').last,
          ),
          const SizedBox(height: 12),
          _AgreementCheckboxTile(
            value: _agreeTerms,
            onChanged: (v) => setState(() => _agreeTerms = v ?? false),
            text:
                'I agree to the terms and conditions and confirm that all the information provided is accurate and complete. I understand that false information may result in account suspension.',
          ),
          const SizedBox(height: 8),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: 'Review your Information', subtitle: 'Please review the details below. You can edit any section before submission.'),
        const SizedBox(height: 12),
        _ReviewCard(title: 'Personal Information', onEdit: () => setState(() => _step = 0)),
        const SizedBox(height: 12),
        _ReviewCard(title: 'Address Information', onEdit: () => setState(() => _step = 0)),
        const SizedBox(height: 12),
        _ReviewCard(title: 'Business Information', onEdit: () => setState(() => _step = 1)),
        const SizedBox(height: 12),
        _ReviewCard(title: 'Identity Documents', onEdit: () => setState(() => _step = 1)),
        const SizedBox(height: 12),
        _ReviewCard(title: 'Emergency Contact', onEdit: () => setState(() => _step = 0)),
        const SizedBox(height: 12),
        const _DeclarationCard(),
        const SizedBox(height: 12),
        const _NoteCard(),
        const SizedBox(height: 8),
      ],
    );
  }

  Map<String, dynamic> _buildKycPayload() {
    DateTime? regDate;
    final regText = _registrationDate.text.trim();
    if (regText.isNotEmpty) {
      regDate = DateTime.tryParse(regText);
    }

    String? orNull(String t) => t.trim().isEmpty ? null : t.trim();

    return {
      // Personal
      'fullName': _fullName.text.trim(),
      'email': _email.text.trim(),
      'phone': _phone.text.trim(), // 10 digits normalized
      'phoneNumber': _phone.text.trim(),
      // Address
      'streetAddress': _streetAddress.text.trim(),
      'city': _city.text.trim(),
      'state': _state.text.trim(),
      'pinCode': _pin.text.trim(),
      'country': _country.text.trim(),
      // Business
      'businessType': _businessType.text.trim(),
      'yearsOfExperience': _yearsExp.text.trim(),
      'businessName': _businessName.text.trim(),
      'gstNumber': orNull(_gstNumber.text),
      // Identity
      'documentType': _documentType.text.trim(),
      'idType': _idType.text.trim(),
      'documentNumber': _documentNumber.text.trim(),
      // Vendor + hospital addresses
      'vendorAddress': orNull(_vendorAddress.text),
      'hospitalAddress': orNull(_hospitalAddress.text),
      // Banking
      'bankName': _bankName.text.trim(),
      'accountNumber': _accountNumber.text.trim(),
      'ifscCode': _ifsc.text.trim().toUpperCase(),
      'accountHolderName': _fullName.text.trim(),
      // Optional business registry fields
      'licenseNumber': orNull(_licenseNumber.text),
      'registrationDate': regDate?.toIso8601String(),
      // Files (multipart picks up actual files; for JSON we keep as paths for reference)
      'adharCard': _fileAadhar?.path,
      'panCard': _filePan?.path,
      'gstCertificate': _fileGst?.path,
      'medicalCertificate': _fileMedical?.path,
      'status': 'PENDING',
    };
  }
}

class _PrivacyNoticeCard extends StatelessWidget {
  const _PrivacyNoticeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(.1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              Text('Privacy Notice', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Your personal information will be securely stored and used only for verification and communication purposes. We comply with data protection regulations.',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _AgreementCheckboxTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;
  const _AgreementCheckboxTile({required this.value, required this.onChanged, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(value: value, onChanged: onChanged, activeColor: AppColors.primary),
        const SizedBox(width: 6),
        Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black))),
      ],
    );
  }
}

class _DeclarationCard extends StatelessWidget {
  const _DeclarationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(.1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.assignment_outlined, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              Text('Declaration', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          Text('By submitting this application, you declare that:', style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87)),
          const SizedBox(height: 6),
          _Bullet(text: 'All information provided is accurate and complete'),
          _Bullet(text: 'You have the legal authority to represent the business'),
          _Bullet(text: 'You agree to comply with all platform policies'),
          _Bullet(text: 'You understand that false information may result in account suspension'),
          const SizedBox(height: 10),
          Text(
            'I have reviewed all the information and confirm that it is accurate and complete. I agree to the terms and conditions and authorize RelaxDoc to verify the submitted documents.',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x22000000)),
      ),
      child: Text(
        'Note: Your application will be reviewed within 2-3 business days. You will receive a confirmation email once your account is verified and activated.',
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 6, height: 6, margin: const EdgeInsets.only(top: 6, right: 8), decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87))),
        ],
      ),
    );
  }
}

class _GradientField extends StatelessWidget {
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final TextEditingController? controller;
  const _GradientField({required this.hint, this.keyboardType, this.maxLines = 1, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFfacdbb),
            Color(0xFFFFFFFA),
          ],
          stops: [0.6, 1.0],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.black54, fontWeight: FontWeight.w600),
          filled: false,
          border: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0x33000000))),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0x33000000))),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black87, width: 1.2)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        ),
      ),
    );
  }
}

class _PhotoPlaceholder extends StatefulWidget {
  const _PhotoPlaceholder();

  @override
  State<_PhotoPlaceholder> createState() => _PhotoPlaceholderState();
}

class _PhotoPlaceholderState extends State<_PhotoPlaceholder> {
  XFile? _image;
  bool _picking = false;

  Future<void> _openCamera() async {
    if (_picking) return;
    setState(() => _picking = true);
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? img = await picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
      if (!mounted) return;
      setState(() => _image = img);
    } catch (_) {
      // swallow errors silently for now
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Take Your Photo Here',
          style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _openCamera,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFfacdbb), Color(0xFFFFFFFA)],
                stops: [0.6, 1.0],
              ),
              borderRadius: borderRadius,
            ),
            clipBehavior: Clip.antiAlias,
            child: _image == null
                ? Center(
                    child: _picking
                        ? const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.camera_alt_outlined, size: 48, color: Colors.black45),
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(File(_image!.path), fit: BoxFit.cover),
                      Container(
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: const Text('Retake', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
