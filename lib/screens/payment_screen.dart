import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'funded_kit_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String paymentMethod;
  final int amount;
  final bool isMonthly;
  final String donorName;
  final String donorEmail;
  final String donorPhone;

  const PaymentScreen({
    super.key,
    required this.paymentMethod,
    required this.amount,
    required this.isMonthly,
    required this.donorName,
    required this.donorEmail,
    required this.donorPhone,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  final _mobileNumberController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _mobileNumberController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  bool get _isMobileMoney =>
      widget.paymentMethod == 'mtn' || widget.paymentMethod == 'airtel';

  Map<String, dynamic> get _methodInfo {
    switch (widget.paymentMethod) {
      case 'mtn':
        return {
          'label': 'MTN MoMo',
          'color': const Color(0xFFFFCC00),
          'textColor': Colors.black,
          'icon': Icons.phone_android_rounded,
          'hint': '077XXXXXXX',
        };
      case 'airtel':
        return {
          'label': 'Airtel Money',
          'color': const Color(0xFFE53935),
          'textColor': Colors.white,
          'icon': Icons.phone_android_rounded,
          'hint': '075XXXXXXX',
        };
      case 'visa':
        return {
          'label': 'Visa',
          'color': const Color(0xFF1A1F71),
          'textColor': Colors.white,
          'icon': Icons.credit_card_rounded,
          'hint': '',
        };
      default:
        return {
          'label': 'Mastercard',
          'color': const Color(0xFFEB001B),
          'textColor': Colors.white,
          'icon': Icons.credit_card_rounded,
          'hint': '',
        };
    }
  }

  Future<void> _confirmPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) {
      return;
    }

    setState(() {
      _isProcessing = false;
    });

    final kit = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': 'Solar M7 Home Kit',
      'donor': widget.donorName,
      'email': widget.donorEmail,
      'phone': widget.donorPhone,
      'amount': widget.amount,
      'isMonthly': widget.isMonthly,
      'paymentMethod': _methodInfo['label'],
      'status': 'Active',
      'date': DateTime.now().toString().substring(0, 10),
      'location': 'Uganda',
      'battery': 100,
      'energy': 10,
      'systemStatus': 'Running',
      'kitsCount': widget.amount ~/ 60,
    };

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => FundedKitScreen(newKit: kit)),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = _methodInfo;
    final color = info['color'] as Color;
    final textColor = info['textColor'] as Color;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primaryDark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Payment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(info['icon'] as IconData, color: textColor),
                    const SizedBox(width: 10),
                    Text(
                      info['label'],
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (_isMobileMoney)
                TextFormField(
                  controller: _mobileNumberController,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Enter phone number';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                )
              else
                Column(
                  children: [
                    TextFormField(
                      controller: _cardNumberController,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Enter card number';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Card Number'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _cardHolderController,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Enter card holder';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Card Holder'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _expiryController,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Enter expiry date';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Expiry (MM/YY)'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _cvvController,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Enter CVV';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: 'CVV'),
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isProcessing ? null : _confirmPayment,
                child: _isProcessing
                    ? const CircularProgressIndicator()
                    : const Text('Confirm Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}