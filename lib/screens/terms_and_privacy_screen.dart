import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class TermsAndPrivacyScreen extends StatefulWidget {
  final int initialTab; // 0 = Terms, 1 = Privacy
  const TermsAndPrivacyScreen({super.key, this.initialTab = 0});

  @override
  State<TermsAndPrivacyScreen> createState() => _TermsAndPrivacyScreenState();
}

class _TermsAndPrivacyScreenState extends State<TermsAndPrivacyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Which sections are expanded
  final Map<String, bool> _expanded = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─── TERMS OF SERVICE DATA ───────────────────────────────────────────────
  final List<Map<String, String>> _terms = [
    {
      'title': '1. Acceptance of Terms',
      'content':
          'By downloading, installing, or using the Solar M7 application, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our application.\n\nThese terms apply to all users of the Solar M7 platform, including individuals, households, schools, and healthcare facilities across Africa.',
    },
    {
      'title': '2. Use of the Application',
      'content':
          'The Solar M7 app is designed to help you monitor and manage your Solar M7 home energy kit. You agree to use the app only for lawful purposes and in accordance with these terms.\n\nYou must not:\n• Use the app in any way that violates applicable local, national, or international laws\n• Attempt to gain unauthorised access to any part of the app or its related systems\n• Transmit any unsolicited or unauthorised advertising material\n• Interfere with the proper working of the app',
    },
    {
      'title': '3. Account Responsibility',
      'content':
          'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.\n\nYou agree to notify Solar M7 immediately if you become aware of any unauthorised use of your account or any other breach of security.\n\nSolar M7 will not be liable for any loss or damage arising from your failure to comply with this provision.',
    },
    {
      'title': '4. Solar Kit & Device Data',
      'content':
          'The Solar M7 app collects real-time data from your solar kit, including battery levels, power output, solar input, and usage patterns. This data is used to:\n\n• Provide you with accurate system monitoring\n• Send you alerts and maintenance reminders\n• Improve our services and product performance\n• Generate impact reports for our partner organisations\n\nYou retain ownership of your device data. We will never sell your personal device data to third parties.',
    },
    {
      'title': '5. Intellectual Property',
      'content':
          'The Solar M7 app, including all content, features, and functionality, is owned by Solar M7 / HiPipo and is protected by international copyright, trademark, and other intellectual property laws.\n\nYou may not reproduce, distribute, modify, or create derivative works of any part of the app without our express written permission.',
    },
    {
      'title': '6. Limitation of Liability',
      'content':
          'Solar M7 shall not be liable for any indirect, incidental, special, or consequential damages resulting from your use or inability to use the app or solar kit.\n\nOur total liability to you for any claim arising from your use of the app shall not exceed the amount you paid for the Solar M7 kit in the preceding 12 months.',
    },
    {
      'title': '7. Changes to Terms',
      'content':
          'We reserve the right to modify these terms at any time. We will notify you of significant changes through the app or via email. Your continued use of the app after changes are posted constitutes your acceptance of the new terms.\n\nWe encourage you to review these terms periodically.',
    },
    {
      'title': '8. Contact Us',
      'content':
          'If you have any questions about these Terms of Service, please contact us:\n\nEmail: info@solarm7.com\nPhone: +256 779 345331\nWebsite: https://solarm7.com\n\nSolar M7 is powered by HiPipo — 20 years of digital transformation across Africa.',
    },
  ];

  // ─── PRIVACY POLICY DATA ─────────────────────────────────────────────────
  final List<Map<String, String>> _privacy = [
    {
      'title': '1. Information We Collect',
      'content':
          'We collect the following types of information when you use the Solar M7 app:\n\n• Profile Information: Name, email address, phone number, and location\n• Device Data: Battery level, solar input, power output, and system status from your Solar M7 kit\n• Usage Data: How you interact with the app, features you use, and time spent\n• Technical Data: Device type, operating system, and app version\n• Location Data: General location to map your solar kit installation (only if you permit this)',
    },
    {
      'title': '2. How We Use Your Information',
      'content':
          'We use the information we collect to:\n\n• Operate and maintain the Solar M7 app\n• Monitor and display your solar kit performance\n• Send you system alerts, low battery warnings, and maintenance reminders\n• Improve our products and services\n• Generate anonymised impact reports (e.g., total CO₂ avoided across all kits)\n• Comply with legal obligations\n• Communicate with you about your account and our services',
    },
    {
      'title': '3. Data Sharing',
      'content':
          'We do not sell your personal data. We may share your information with:\n\n• Service Providers: Trusted partners who help us operate our platform (e.g., cloud hosting, analytics)\n• Partner Organisations: COMESA Business Council and regional partners, in anonymised/aggregated form only\n• Legal Authorities: When required by law or to protect our rights\n\nAll third parties are contractually required to protect your data and use it only for the purposes we specify.',
    },
    {
      'title': '4. Data Security',
      'content':
          'We take the security of your data seriously. We implement appropriate technical and organisational measures to protect your personal information against unauthorised access, alteration, disclosure, or destruction.\n\nThese measures include:\n• Encrypted data transmission (HTTPS/TLS)\n• Secure cloud storage with access controls\n• Regular security audits\n• Staff training on data protection\n\nHowever, no method of transmission over the internet is 100% secure, and we cannot guarantee absolute security.',
    },
    {
      'title': '5. Your Rights',
      'content':
          'Depending on your location, you may have the following rights regarding your personal data:\n\n• Access: Request a copy of the personal data we hold about you\n• Correction: Ask us to correct inaccurate or incomplete data\n• Deletion: Request deletion of your personal data\n• Portability: Receive your data in a portable format\n• Objection: Object to certain types of processing\n\nTo exercise any of these rights, contact us at info@solarm7.com. We will respond within 30 days.',
    },
    {
      'title': '6. Cookies & Tracking',
      'content':
          'The Solar M7 app may use cookies and similar tracking technologies to enhance your experience and collect usage analytics.\n\nYou can control cookie settings through your device or browser settings. Disabling cookies may affect certain features of the app.',
    },
    {
      'title': '7. Children\'s Privacy',
      'content':
          'The Solar M7 app is not directed at children under the age of 13. We do not knowingly collect personal information from children under 13.\n\nIf we become aware that a child under 13 has provided us with personal information, we will take steps to delete such information promptly.',
    },
    {
      'title': '8. Changes to This Policy',
      'content':
          'We may update this Privacy Policy from time to time. We will notify you of any significant changes via the app or email. The date at the top of this policy indicates when it was last updated.\n\nYour continued use of the app after changes are posted means you accept the updated policy.',
    },
    {
      'title': '9. Contact & Data Controller',
      'content':
          'Solar M7 / HiPipo is the data controller responsible for your personal information.\n\nEmail: info@solarm7.com\nPhone: +256 779 345331\nWebsite: https://solarm7.com\n\nFor data protection enquiries, please include "Privacy" in your subject line.',
    },
  ];

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Legal',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDark,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Terms of Service'),
                  Tab(text: 'Privacy Policy'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildContent(_terms, 'terms', 'Last updated: January 2025'),
          _buildContent(_privacy, 'privacy', 'Last updated: January 2025'),
        ],
      ),
    );
  }

  Widget _buildContent(
    List<Map<String, String>> sections,
    String prefix,
    String lastUpdated,
  ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Header card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryYellow.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primaryYellow.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.primaryDark,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  lastUpdated,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Expandable sections
        ...sections.map((section) {
          final key = '$prefix-${section['title']}';
          final isOpen = _expanded[key] ?? false;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              color: AppColors.cardBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => _expanded[key] = !isOpen),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              section['title']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                          AnimatedRotation(
                            turns: isOpen ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            section['content']!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        ),
                        crossFadeState: isOpen
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 250),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 80),
      ],
    );
  }
}
