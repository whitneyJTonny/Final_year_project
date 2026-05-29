import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

// ==========================================
// TERMS AND PRIVACY SCREEN
// ==========================================
class TermsAndPrivacyScreen extends StatefulWidget {
  final int initialTab; // 0 = Terms, 1 = Privacy
  const TermsAndPrivacyScreen({super.key, this.initialTab = 0});

  @override
  State<TermsAndPrivacyScreen> createState() => _TermsAndPrivacyScreenState();
}

class _TermsAndPrivacyScreenState extends State<TermsAndPrivacyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, bool> _expanded = {};

  final List<Map<String, String>> _terms = [
    {
      'title': '1. Acceptance of Terms',
      'content': 'By downloading, installing, or using the Solar M7 application, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our application.\n\nThese terms apply to all users of the Solar M7 platform, including individuals, households, schools, and healthcare facilities across Africa.',
    },
    {
      'title': '2. Use of the Application',
      'content': 'The Solar M7 app is designed to help you monitor and manage your Solar M7 home energy kit. You agree to use the app only for lawful purposes and in accordance with these terms.\n\nYou must not:\n• Use the app in any way that violates applicable local, national, or international laws\n• Attempt to gain unauthorised access to any part of the app or its related systems\n• Transmit any unsolicited or unauthorised advertising material\n• Interfere with the proper working of the app',
    },
    {
      'title': '3. Account Responsibility',
      'content': 'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.\n\nYou agree to notify Solar M7 immediately if you become aware of any unauthorised use of your account or any other breach of security.\n\nSolar M7 will not be liable for any loss or damage arising from your failure to comply with this provision.',
    },
    {
      'title': '4. Solar Kit & Device Data',
      'content': 'The Solar M7 app collects real-time data from your solar kit, including battery levels, power output, solar input, and usage patterns. This data is used to:\n\n• Provide you with accurate system monitoring\n• Send you alerts and maintenance reminders\n• Improve our services and product performance\n• Generate impact reports for our partner organisations\n\nYou retain ownership of your device data. We will never sell your personal device data to third parties.',
    },
    {
      'title': '5. Intellectual Property',
      'content': 'The Solar M7 app, including all content, features, and functionality, is owned by Solar M7 / HiPipo and is protected by international copyright, trademark, and other intellectual property laws.\n\nYou may not reproduce, distribute, modify, or create derivative works of any part of the app without our express written permission.',
    },
    {
      'title': '6. Limitation of Liability',
      'content': 'Solar M7 shall not be liable for any indirect, incidental, special, or consequential damages resulting from your use or inability to use the app or solar kit.\n\nOur total liability to you for any claim arising from your use of the app shall not exceed the amount you paid for the Solar M7 kit in the preceding 12 months.',
    },
    {
      'title': '7. Changes to Terms',
      'content': 'We reserve the right to modify these terms at any time. We will notify you of significant changes through the app or via email. Your continued use of the app after changes are posted constitutes your acceptance of the new terms.\n\nWe encourage you to review these terms periodically.',
    },
  ];

  final List<Map<String, String>> _privacy = [
    {
      'title': '1. Information We Collect',
      'content': 'We collect the following types of information when you use the Solar M7 app:\n\n• Profile Information: Name, email address, phone number, and location\n• Device Data: Battery level, solar input, power output, and system status from your Solar M7 kit\n• Usage Data: How you interact with the app, features you use, and time spent\n• Technical Data: Device type, operating system, and app version\n• Location Data: General location to map your solar kit installation (only if you permit this)',
    },
    {
      'title': '2. How We Use Your Information',
      'content': 'We use the information we collect to:\n\n• Operate and maintain the Solar M7 app\n• Monitor and display your solar kit performance\n• Send you system alerts, low battery warnings, and maintenance reminders\n• Improve our products and services\n• Generate anonymised impact reports (e.g., total CO₂ avoided across all kits)\n• Comply with legal obligations\n• Communicate with you about your account and our services',
    },
    {
      'title': '3. Data Sharing',
      'content': 'We do not sell your personal data. We may share your information with:\n\n• Service Providers: Trusted partners who help us operate our platform (e.g., cloud hosting, analytics)\n• Partner Organisations: COMESA Business Council and regional partners, in anonymised/aggregated form only\n• Legal Authorities: When required by law or to protect our rights\n\nAll third parties are contractually required to protect your data and use it only for the purposes we specify.',
    },
    {
      'title': '4. Data Security',
      'content': 'We take the security of your data seriously. We implement appropriate technical and organisational measures to protect your personal information against unauthorised access, alteration, disclosure, or destruction.\n\nThese measures include:\n• Encrypted data transmission (HTTPS/TLS)\n• Secure cloud storage with access controls\n• Regular security audits\n• Staff training on data protection\n\nHowever, no method of transmission over the internet is 100% secure, and we cannot guarantee absolute security.',
    },
    {
      'title': '5. Your Rights',
      'content': 'Depending on your location, you may have the following rights regarding your personal data:\n\n• Access: Request a copy of the personal data we hold about you\n• Correction: Ask us to correct inaccurate or incomplete data\n• Deletion: Request deletion of your personal data\n• Portability: Receive your data in a portable format\n• Objection: Object to certain types of processing\n\nTo exercise any of these rights, contact us at info@solarm7.com. We will respond within 30 days.',
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.titleLarge?.color;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Legal',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(66),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: isDark ? Colors.black.withValues(alpha: 0.3) : AppColors.inputBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primaryYellow,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryYellow.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
          _buildContent(_terms, 'terms', 'Last updated: January 2025', isDark),
          _buildContent(_privacy, 'privacy', 'Last updated: January 2025', isDark),
        ],
      ),
    );
  }

  Widget _buildContent(List<Map<String, String>> sections, String prefix, String lastUpdated, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryYellow.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.info, color: AppColors.primaryYellow, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  lastUpdated,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        ...sections.map((section) {
          final key = '$prefix-${section['title']}';
          final isOpen = _expanded[key] ?? false;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isOpen ? AppColors.primaryYellow.withValues(alpha: 0.5) : Colors.transparent,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => setState(() => _expanded[key] = !isOpen),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                section['title']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Theme.of(context).textTheme.titleLarge?.color,
                                ),
                              ),
                            ),
                            AnimatedRotation(
                              turns: isOpen ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: const Icon(LucideIcons.chevronDown, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              section['content']!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                          ),
                          crossFadeState: isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 250),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 40),
      ],
    );
  }
}

// ==========================================
// HELP AND SUPPORT SCREEN
// ==========================================
class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  void _launchURL(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not complete action.'),
          backgroundColor: AppColors.warningRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.titleLarge?.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Cards
            const Text(
              'GET IN TOUCH',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildContactCard(
              context: context,
              icon: LucideIcons.mail,
              title: 'Email Us',
              subtitle: 'support@solarm7.com',
              onTap: () => _launchURL('mailto:support@solarm7.com', context),
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              context: context,
              icon: LucideIcons.phone,
              title: 'Call Us',
              subtitle: '+256 779 345331',
              onTap: () => _launchURL('tel:+256779345331', context),
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              context: context,
              icon: LucideIcons.messageCircle,
              title: 'WhatsApp',
              subtitle: 'Chat with our support team',
              onTap: () => _launchURL('https://wa.me/256779345331', context),
            ),
            
            const SizedBox(height: 40),
            
            // FAQ Section
            const Text(
              'FREQUENTLY ASKED QUESTIONS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildFaqItem(context, isDark, 'How do I fund a solar kit?', 'Navigate to the Home screen and tap "Fund a Kit". You can view pending kits in rural communities and contribute directly via mobile money or card.'),
            _buildFaqItem(context, isDark, 'How is my impact calculated?', 'Impact is calculated based on the capacity of the kits you have funded. We track real-time solar generation and multiply it by standard carbon offset metrics to calculate your CO₂ avoided.'),
            _buildFaqItem(context, isDark, 'Can I update my profile details?', 'Yes! Go to the Settings tab, tap your profile picture at the top, and edit your name, email, or location.'),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryYellow.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryYellow),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textTheme.titleLarge?.color),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        trailing: const Icon(LucideIcons.chevronRight, color: AppColors.textSecondary, size: 20),
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, bool isDark, String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            iconColor: AppColors.primaryYellow,
            collapsedIconColor: AppColors.textSecondary,
            title: Text(
              question,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            children: [
              Text(
                answer,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
