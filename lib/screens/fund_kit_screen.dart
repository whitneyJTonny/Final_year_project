import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';
import 'payment_screen.dart';


class FundKitScreen extends StatefulWidget {
  const FundKitScreen({super.key});

  @override
  State<FundKitScreen> createState() => _FundKitScreenState();
}

class _FundKitScreenState extends State<FundKitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _customAmountController = TextEditingController();

  // Matches exactly what's on solarm7.com
  final List<Map<String, dynamic>> _presetAmounts = [
    {'amount': 60, 'label': 'USD 60', 'desc': 'Fund 1 Kit', 'icon': '🏠'},
    {'amount': 300, 'label': 'USD 300', 'desc': 'Fund 5 Kits', 'icon': '🏘️'},
    {'amount': 600, 'label': 'USD 600', 'desc': 'Fund 10 Kits', 'icon': '🌍'},
  ];

  int? _selectedAmount = 60;
  bool _isCustom = false;
  bool _isMonthly = false;
  String _selectedPayment = 'mtn';
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'mtn',
      'label': 'MTN MoMo',
      'icon': Icons.phone_android_rounded,
      'color': Color(0xFFFFCC00),
    },
    {
      'id': 'airtel',
      'label': 'Airtel Money',
      'icon': Icons.phone_android_rounded,
      'color': Color(0xFFE53935),
    },
    {
      'id': 'visa',
      'label': 'Visa',
      'icon': Icons.credit_card_rounded,
      'color': Color(0xFF1A1F71),
    },
    {
      'id': 'mastercard',
      'label': 'Mastercard',
      'icon': Icons.credit_card_rounded,
      'color': Color(0xFFEB001B),
    },
  ];

  int get _effectiveAmount {
    if (_isCustom) {
      return int.tryParse(_customAmountController.text) ?? 0;
    }
    return _selectedAmount ?? 60;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _customAmountController.dispose();
    super.dispose();
  }

  Future<void> _processDonation() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isCustom &&
        (int.tryParse(_customAmountController.text) ?? 0) < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Minimum donation is USD 10.'),
          backgroundColor: AppColors.warningOrange,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    // Replace with real payment API call
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() => _isProcessing = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          paymentMethod: _selectedPayment,
          amount: _effectiveAmount,
          isMonthly: _isMonthly,
          donorName: _nameController.text,
          donorEmail: _emailController.text,
          donorPhone: _phoneController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: CustomScrollView(
        slivers: [
          // ── Hero App Bar ────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primaryDark,
                child: Stack(
                  children: [
                    // Background pattern
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.06,
                        child: Image.network(
                          'https://solarm7.com/images/logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const SizedBox(),
                        ),
                      ),
                    ),
                    // Content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryYellow.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.wb_sunny_rounded,
                              color: AppColors.primaryYellow,
                              size: 36,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'LET THERE BE LIGHT',
                            style: TextStyle(
                              color: AppColors.primaryYellow,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Fund a Solar Kit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'USD 60 powers one home in Africa',
                            style: TextStyle(
                                color: Colors.white60, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Impact Stats ───────────────────────────────────────
                    _buildImpactStats(),
                    const SizedBox(height: 25),

                    // ── One-Time / Monthly Toggle ──────────────────────────
                    _buildSectionHeader('GIVING TYPE'),
                    _buildGivingToggle(),
                    const SizedBox(height: 25),

                    // ── Amount Selection ───────────────────────────────────
                    _buildSectionHeader('SELECT AMOUNT'),
                    _buildAmountSelector(),
                    const SizedBox(height: 25),

                    // ── Payment Method ─────────────────────────────────────
                    _buildSectionHeader('PAYMENT METHOD'),
                    _buildPaymentMethods(),
                    const SizedBox(height: 25),

                    // ── Donor Details ──────────────────────────────────────
                    _buildSectionHeader('YOUR DETAILS'),
                    _buildFormFields(),
                    const SizedBox(height: 25),

                    // ── Journey Steps ──────────────────────────────────────
                    _buildJourneySteps(),
                    const SizedBox(height: 25),

                    // ── Donate Button ──────────────────────────────────────
                    _buildDonateButton(),
                    const SizedBox(height: 16),

                    // ── Trust Note ─────────────────────────────────────────
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_rounded,
                              size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 5),
                          const Text(
                            'Secure payment · 100% goes to the project · Powered by HiPipo',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Impact Stats ──────────────────────────────────────────────────────────
  Widget _buildImpactStats() {
    final stats = [
      {'value': '5M', 'label': 'Homes Goal'},
      {'value': '21', 'label': 'Countries'},
      {'value': '100%', 'label': 'To Project'},
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats
            .map((s) => Column(
                  children: [
                    Text(
                      s['value']!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryYellow,
                      ),
                    ),
                    Text(
                      s['label']!,
                      style: const TextStyle(
                          fontSize: 11, color: Colors.white60),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }

  // ── Giving Toggle ─────────────────────────────────────────────────────────
  Widget _buildGivingToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isMonthly = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isMonthly ? AppColors.primaryDark : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Give Once',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: !_isMonthly ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isMonthly = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isMonthly ? AppColors.primaryDark : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Give Monthly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: _isMonthly ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Amount Selector ───────────────────────────────────────────────────────
  Widget _buildAmountSelector() {
    return Column(
      children: [
        // Preset amounts
        Row(
          children: _presetAmounts.map((item) {
            final isSelected =
                !_isCustom && _selectedAmount == item['amount'];
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() {
                  _selectedAmount = item['amount'] as int;
                  _isCustom = false;
                }),
                child: Container(
                  margin: EdgeInsets.only(
                    right: item == _presetAmounts.last ? 0 : 8,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryDark
                        : AppColors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryDark
                          : AppColors.bgLight,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primaryDark
                                  .withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : [],
                  ),
                  child: Column(
                    children: [
                      Text(item['icon'] as String,
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 6),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: isSelected
                              ? AppColors.primaryYellow
                              : AppColors.primaryDark,
                        ),
                      ),
                      Text(
                        item['desc'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected
                              ? Colors.white70
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        // Custom amount
        GestureDetector(
          onTap: () => setState(() => _isCustom = true),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _isCustom ? AppColors.primaryDark : AppColors.cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isCustom ? AppColors.primaryDark : AppColors.bgLight,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.edit_rounded,
                    size: 18,
                    color: _isCustom
                        ? AppColors.primaryYellow
                        : AppColors.textSecondary),
                const SizedBox(width: 10),
                Expanded(
                  child: _isCustom
                      ? TextField(
                          controller: _customAmountController,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter custom amount',
                            hintStyle: TextStyle(color: Colors.white38),
                            border: InputBorder.none,
                            prefixText: 'USD ',
                            prefixStyle: TextStyle(
                                color: AppColors.primaryYellow,
                                fontWeight: FontWeight.w700),
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        )
                      : Text(
                          'Custom Amount',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Payment Methods ───────────────────────────────────────────────────────
  Widget _buildPaymentMethods() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.8,
      children: _paymentMethods.map((method) {
        final isSelected = _selectedPayment == method['id'];
        final color = method['color'] as Color;
        return GestureDetector(
          onTap: () => setState(() => _selectedPayment = method['id']),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.12)
                  : AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? color : AppColors.bgLight,
                width: isSelected ? 2 : 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(method['icon'] as IconData,
                    color: isSelected ? color : AppColors.textSecondary,
                    size: 20),
                const SizedBox(width: 8),
                Text(
                  method['label'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isSelected ? color : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Form Fields ───────────────────────────────────────────────────────────
  Widget _buildFormFields() {
    return Column(
      children: [
        _buildField(
          controller: _nameController,
          label: 'Full Name',
          icon: Icons.person_outline_rounded,
          validator: (v) =>
              v == null || v.isEmpty ? 'Please enter your name' : null,
        ),
        const SizedBox(height: 12),
        _buildField(
          controller: _emailController,
          label: 'Email Address',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Please enter your email';
            if (!v.contains('@')) return 'Enter a valid email';
            return null;
          },
        ),
        const SizedBox(height: 12),
        _buildField(
          controller: _phoneController,
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
          color: AppColors.primaryDark, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.primaryDark, size: 20),
        filled: true,
        fillColor: AppColors.cardBg,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: AppColors.primaryYellow.withValues(alpha: 0.4),
              width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primaryYellow, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.warningRed, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  // ── Journey Steps ─────────────────────────────────────────────────────────
  Widget _buildJourneySteps() {
    final steps = [
      {'icon': '💳', 'title': 'You Fund a Kit', 'desc': 'Your USD 60 powers one home'},
      {'icon': '🚚', 'title': 'We Deploy', 'desc': 'Via trusted community partners'},
      {'icon': '✨', 'title': 'Lives Change', 'desc': 'Light, safety, education'},
      {'icon': '📸', 'title': 'You See Impact', 'desc': 'Real photos & updates'},
    ];

    return Card(
      color: AppColors.cardBg,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'From Your Hands to the Last Mile',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 14),
            ...steps.asMap().entries.map((entry) {
              final isLast = entry.key == steps.length - 1;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            AppColors.primaryYellow.withValues(alpha: 0.15),
                        child: Text(entry.value['icon']!,
                            style: const TextStyle(fontSize: 16)),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 28,
                          color: AppColors.primaryYellow
                              .withValues(alpha: 0.3),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.value['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          Text(
                            entry.value['desc']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  // ── Donate Button ─────────────────────────────────────────────────────────
  Widget _buildDonateButton() {
    final amount = _effectiveAmount;
    final label = _isMonthly
        ? 'GIVE USD $amount / MONTH'
        : 'FUND A KIT – USD $amount';

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isProcessing ? null : _processDonation,
        icon: _isProcessing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.primaryDark),
              )
            : const Icon(Icons.volunteer_activism_rounded,
                color: AppColors.primaryDark),
        label: Text(
          _isProcessing ? 'Processing...' : label,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 15,
            color: AppColors.primaryDark,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryYellow,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 4,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}