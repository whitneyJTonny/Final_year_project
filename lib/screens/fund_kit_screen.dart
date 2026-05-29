import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/impact_card.dart';
import 'monitoring_screen.dart';

class FundKitScreen extends StatefulWidget {
  const FundKitScreen({super.key});

  @override
  State<FundKitScreen> createState() => _FundKitScreenState();
}

class _FundKitScreenState extends State<FundKitScreen> {
  int _selectedKitIndex = 0;
  String _selectedPaymentMethod = 'mtn';
  int _pesapalSubTab = 0;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cardNumController = TextEditingController();
  final TextEditingController _cardExpiryController = TextEditingController();
  final TextEditingController _cardCvvController = TextEditingController();

  final List<Map<String, dynamic>> _kitOptions = [
    {
      'amount': 'Ush. 230,000',
      'impact': 'Powers 1 Home',
      'icon': LucideIcons.home,
    },
    {
      'amount': 'Ush. 1,150,000',
      'impact': 'Powers 5 Homes',
      'icon': LucideIcons.users,
    },
    {
      'amount': 'Ush. 2,300,000',
      'impact': 'Powers 10 Homes',
      'icon': LucideIcons.sun,
    },
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cardNumController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    super.dispose();
  }

  String _getUshAmount() {
    return _kitOptions[_selectedKitIndex]['amount'].replaceAll('Ush. ', '');
  }

  void _saveKitToOffline(Map<String, dynamic> kit) async {
    var box = Hive.box('offline_kits');
    final kitId =
        'KIT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    await box.put(kitId, {
      'id': kitId,
      'amount': kit['amount'],
      'impact': kit['impact'],
      'date': DateTime.now().toString().split(' ')[0],
      'status': 'Verified (Offline)',
    });
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.warningRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showPaymentProcessing(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).cardColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.secondaryOrange),
            const SizedBox(height: 20),
            Text(
              'Connecting to ${_selectedPaymentMethod.toUpperCase()}...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context);
      if (_selectedPaymentMethod == 'pesapal') {
        _saveKitToOffline(_kitOptions[_selectedKitIndex]);
        _showSuccessDialog(context);
      } else {
        _showPinConfirmationDialog(context);
      }
    });
  }

  void _showPinConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(ctx).cardColor,
        title: Row(
          children: [
            const Icon(
              Icons.vibration_rounded,
              color: AppColors.secondaryOrange,
            ),
            const SizedBox(width: 10),
            Text(
              '${_selectedPaymentMethod.toUpperCase()} PIN',
              style: TextStyle(
                color: Theme.of(ctx).textTheme.titleLarge?.color,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'A push notification has been sent to your device. Please enter your Mobile Money PIN to complete the Ush. ${_getUshAmount()} payment.',
              style: TextStyle(
                color: Theme.of(
                  ctx,
                ).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            const LinearProgressIndicator(color: AppColors.secondaryOrange),
            const SizedBox(height: 10),
            Text(
              'Waiting for provider confirmation...',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Theme.of(ctx).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.pop(context);
      _saveKitToOffline(_kitOptions[_selectedKitIndex]);
      _showSuccessDialog(context);
    });
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(ctx).cardColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.successGreen,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Funding Successful!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(ctx).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Thank you! Your contribution has been verified via PesaPal and saved for offline tracking.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(ctx).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Finish & Track',
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MonitoringScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Fund a Solar Kit'),
        backgroundColor: theme.cardColor,
        foregroundColor: theme.textTheme.titleLarge?.color,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Impact Level',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 16),

            ...List.generate(_kitOptions.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ImpactCard(
                  amount: _kitOptions[index]['amount'],
                  impactText: _kitOptions[index]['impact'],
                  icon: _kitOptions[index]['icon'],
                  isSelected: _selectedKitIndex == index,
                  onTap: () => setState(() => _selectedKitIndex = index),
                ),
              );
            }),

            const SizedBox(height: 32),
            Text(
              'Choose Payment Option',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildPaymentOption(
                    'mtn',
                    'MTN MoMo',
                    Icons.phone_android_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildPaymentOption(
                    'airtel',
                    'Airtel',
                    Icons.phone_android_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              'pesapal',
              'Pay via PESAPAL / VISA / CARD',
              LucideIcons.shieldCheck,
            ),

            const SizedBox(height: 24),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedPaymentMethod == 'pesapal'
                  ? _buildPesaPalPortal(isDark)
                  : _buildMobileMoneyForm(isDark),
            ),

            const SizedBox(height: 40),

            CustomButton(
              text: 'FUND A KIT',
              icon: LucideIcons.heart,
              onPressed: () {
                if (_selectedPaymentMethod == 'pesapal') {
                  if (_pesapalSubTab == 0 &&
                      _emailController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter your PesaPal login details',
                        ),
                      ),
                    );
                    return;
                  }
                } else {
                  String phone = _phoneController.text.replaceAll(
                    RegExp(r'\D'),
                    '',
                  );

                  if (phone.startsWith('256')) phone = phone.substring(3);
                  if (phone.startsWith('0')) phone = phone.substring(1);

                  if (phone.length != 9 || !phone.startsWith('7')) {
                    _showError(
                      context,
                      'Invalid format. Enter a 9-digit subscriber number (e.g. 770 000 000).',
                    );
                    return;
                  }

                  final carrierPrefix = phone.substring(0, 2);
                  if (_selectedPaymentMethod == 'mtn') {
                    final mtnPrefixes = ['77', '78', '76', '81', '82'];
                    if (!mtnPrefixes.contains(carrierPrefix)) {
                      _showError(
                        context,
                        'Invalid MTN MoMo subscriber prefix. Use 77, 78, 76, 81, or 82.',
                      );
                      return;
                    }
                  } else if (_selectedPaymentMethod == 'airtel') {
                    final airtelPrefixes = ['70', '75', '74', '79'];
                    if (!airtelPrefixes.contains(carrierPrefix)) {
                      _showError(
                        context,
                        'Invalid Airtel subscriber prefix. Use 70, 75, 74, or 79.',
                      );
                      return;
                    }
                  }

                  _phoneController.text = '0$phone';
                }

                _showPaymentProcessing(context);
              },
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileMoneyForm(bool isDark) {
    String provider = _selectedPaymentMethod.toUpperCase();
    String hint = _selectedPaymentMethod == 'mtn'
        ? '770 000 000'
        : '700 000 000';
    return Column(
      key: ValueKey(_selectedPaymentMethod),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$provider Account Number',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.secondaryOrange.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Text('🇺🇬', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      '+256',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPesaPalPortal(bool isDark) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

    return Container(
      key: const ValueKey('pesapal_portal'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PESAPAL SECURED',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                  letterSpacing: 1.1,
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  Icon(LucideIcons.lock, size: 14, color: accentColor),
                  const SizedBox(width: 8),
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/d/d6/Visa_2021.svg',
                    height: 10,
                    errorBuilder: (_, __, _) => Text(
                      'VISA',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            'Amount to pay: Ush. ${_getUshAmount()}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildSubTab(0, 'PesaPal Account', accentColor),
                _buildSubTab(1, 'Visa / Mastercard', accentColor),
              ],
            ),
          ),
          const SizedBox(height: 24),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _pesapalSubTab == 0
                ? _buildAccountFields()
                : _buildCardFields(),
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(
                Icons.verified_user_rounded,
                color: AppColors.successGreen,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '100% Secure Payment via PesaPal & SSL',
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubTab(int index, String label, Color accentColor) {
    bool isSelected = _pesapalSubTab == index;
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _pesapalSubTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? theme.cardColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? accentColor
                  : theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountFields() {
    return Column(
      key: const ValueKey('acc_fields'),
      children: [
        _buildPortalField(
          controller: _emailController,
          hint: 'Email / Username',
          icon: LucideIcons.user,
        ),
        const SizedBox(height: 12),
        _buildPortalField(
          controller: _passwordController,
          hint: 'Password',
          icon: LucideIcons.lock,
          obscure: true,
        ),
      ],
    );
  }

  Widget _buildCardFields() {
    return Column(
      key: const ValueKey('card_fields'),
      children: [
        _buildPortalField(
          controller: _cardNumController,
          hint: 'Visa Card Number',
          icon: LucideIcons.creditCard,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPortalField(
                controller: _cardExpiryController,
                hint: 'MM/YY',
                icon: LucideIcons.calendar,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPortalField(
                controller: _cardCvvController,
                hint: 'CVV',
                icon: LucideIcons.lock,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPortalField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.15)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 14),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 13,
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
          ),
          prefixIcon: Icon(
            icon,
            size: 18,
            color: theme.iconTheme.color?.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String id, String label, IconData icon) {
    bool isSelected = _selectedPaymentMethod == id;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondaryOrange : theme.cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? AppColors.secondaryOrange
                : theme.dividerColor.withValues(alpha: 0.15),
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.secondaryOrange.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : theme.iconTheme.color?.withValues(alpha: 0.6),
              size: 20,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : theme.textTheme.bodyLarge?.color,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
