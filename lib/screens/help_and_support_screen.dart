import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_colors.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  final Map<String, bool> _expanded = {};

  // Ticket form controllers
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _subjectFocus = FocusNode();
  final _messageFocus = FocusNode();
  bool _isSendingTicket = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    _subjectFocus.dispose();
    _messageFocus.dispose();
    super.dispose();
  }

  // ─── TROUBLESHOOTING DATA ────────────────────────────────────────────────
  final List<Map<String, dynamic>> _troubleshooting = [
    {
      'icon': '🔋',
      'title': 'Battery is not charging',
      'steps': [
        'Check that the solar panel is placed in direct sunlight — avoid shade from trees or buildings.',
        'Make sure the panel cable is firmly plugged into the kit box.',
        'Check the LED indicator on the kit — a blinking red light means low charge.',
        'Clean the solar panel surface with a dry cloth. Dust reduces charging.',
        'If it still does not charge after 2 hours of direct sun, contact support.',
      ],
    },
    {
      'icon': '💡',
      'title': 'Lights are not turning on',
      'steps': [
        'Press and hold the power button on the kit for 3 seconds.',
        'Check that the battery level is above 10% in the app.',
        'Make sure the light cable is properly connected to the kit.',
        'Try a different light port on the kit box.',
        'If the battery is full but lights still won\'t come on, restart the kit by holding the power button for 10 seconds.',
      ],
    },
    {
      'icon': '📱',
      'title': 'App is not connecting to my kit',
      'steps': [
        'Make sure your phone\'s internet connection is working.',
        'Close the app completely and reopen it.',
        'Check that your kit is powered on — the LED should be green.',
        'Try logging out and logging back in to the app.',
        'If still not connecting, check that your Kit ID in System Details matches the ID on your kit box.',
      ],
    },
    {
      'icon': '⚡',
      'title': 'Phone is charging slowly',
      'steps': [
        'Make sure you are using the USB cable that came with the kit.',
        'Check the battery level — charging speed slows below 20%.',
        'Only charge one device at a time for fastest speed.',
        'Avoid using lights and charging a phone at the same time if battery is low.',
        'Place the solar panel in direct sunlight to top up the battery faster.',
      ],
    },
    {
      'icon': '📻',
      'title': 'Radio is not working',
      'steps': [
        'Make sure the kit battery is above 15%.',
        'Check the antenna is fully extended for better signal.',
        'Try scanning for stations again using the tuner button.',
        'Move to an open area away from walls or metal objects.',
        'If there is no sound at all, check the volume is not set to zero.',
      ],
    },
    {
      'icon': '🔔',
      'title': 'I am not receiving notifications',
      'steps': [
        'Go to your phone Settings → Apps → Solar M7 → Notifications and make sure they are enabled.',
        'In the Solar M7 app, go to Settings and check that System Alerts are turned on.',
        'Make sure your phone is connected to the internet.',
        'Try toggling the notification switches off and on again in Settings.',
        'Restart your phone and check again.',
      ],
    },
  ];

  // ─── FAQ DATA ────────────────────────────────────────────────────────────
  final List<Map<String, String>> _faqs = [
    {
      'q': 'How long does the battery last on a full charge?',
      'a':
          'A fully charged Solar M7 battery can power 4 LED lights for up to 8 hours, or charge a smartphone up to 3 times. Actual performance depends on usage.',
    },
    {
      'q': 'How many hours of sunlight do I need to fully charge the kit?',
      'a':
          'You need approximately 6–8 hours of direct sunlight to fully charge the Solar M7 kit from empty. Partial charging is possible in fewer hours.',
    },
    {
      'q': 'Can I use the kit during rainy or cloudy weather?',
      'a':
          'Yes! The kit runs on its stored battery, so you can use it any time. However, charging will be slower on cloudy days. We recommend keeping the battery topped up on sunny days.',
    },
    {
      'q': 'Is the Solar M7 kit waterproof?',
      'a':
          'The solar panel is weather-resistant and safe to leave outdoors. However, the kit box should be kept indoors or in a dry place away from direct rain.',
    },
    {
      'q': 'How do I update my kit\'s firmware?',
      'a':
          'Firmware updates happen automatically when your kit is connected and online. You can check your current firmware version in Settings → App Version.',
    },
    {
      'q': 'What happens if I lose my Kit ID?',
      'a':
          'Your Kit ID is printed on a sticker on the bottom of the kit box. It is also visible in Settings → System Details inside the app.',
    },
  ];

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not open. Please try again.'),
          backgroundColor: AppColors.warningRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Future<void> _submitTicket() async {
    if (_subjectController.text.trim().isEmpty ||
        _messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in both subject and message.'),
          backgroundColor: AppColors.warningOrange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _isSendingTicket = true);
    // Simulate API call — replace with real ticket submission
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() => _isSendingTicket = false);
    _subjectController.clear();
    _messageController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          '✅ Ticket submitted! We\'ll get back to you within 24 hours.',
        ),
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

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
          'Help & Support',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDark,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Hero Banner ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryYellow,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    color: AppColors.primaryDark,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'We\'re here for you',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Mon – Sat, 8am – 6pm EAT',
                        style: TextStyle(fontSize: 12, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // ── Contact Options ──────────────────────────────────────────────
          _buildSectionHeader('CONTACT SUPPORT'),
          Row(
            children: [
              Expanded(
                child: _buildContactCard(
                  icon: Icons.phone_rounded,
                  label: 'Call Us',
                  subtitle: '+256 779 345331',
                  color: AppColors.infoBlue,
                  onTap: () => _launchUrl('tel:+256779345331'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildContactCard(
                  icon: Icons.chat_rounded,
                  label: 'WhatsApp',
                  subtitle: 'Chat with us',
                  color: AppColors.successGreen,
                  onTap: () => _launchUrl(
                    'https://wa.me/256779345331?text=Hello%20Solar%20M7%20Support',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildContactCard(
            icon: Icons.email_rounded,
            label: 'Email Support',
            subtitle: 'info@solarm7.com',
            color: AppColors.secondaryOrange,
            onTap: () => _launchUrl(
              'mailto:info@solarm7.com?subject=Solar%20M7%20Support',
            ),
            fullWidth: true,
          ),
          const SizedBox(height: 25),

          // ── Troubleshooting ──────────────────────────────────────────────
          _buildSectionHeader('FIX IT YOURSELF 🔧'),
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Tap a problem below for simple step-by-step fixes.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ),
          ..._troubleshooting.map((item) {
            final key = 'trouble-${item['title']}';
            final isOpen = _expanded[key] ?? false;
            final steps = item['steps'] as List<String>;
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
                            Text(
                              item['icon'] as String,
                              style: const TextStyle(fontSize: 22),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item['title'] as String,
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
                          secondChild: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 14),
                              const Divider(
                                color: AppColors.bgLight,
                                height: 1,
                              ),
                              const SizedBox(height: 12),
                              ...steps.asMap().entries.map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: AppColors.primaryYellow
                                            .withValues(alpha: 0.2),
                                        child: Text(
                                          '${entry.key + 1}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.primaryDark,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          entry.value,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
          const SizedBox(height: 25),

          // ── FAQs ─────────────────────────────────────────────────────────
          _buildSectionHeader('FREQUENTLY ASKED QUESTIONS'),
          ..._faqs.map((faq) {
            final key = 'faq-${faq['q']}';
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
                            const Icon(
                              Icons.help_outline_rounded,
                              color: AppColors.primaryYellow,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                faq['q']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
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
                              faq['a']!,
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
          const SizedBox(height: 25),

          // ── Submit a Ticket ──────────────────────────────────────────────
          _buildSectionHeader('SUBMIT A SUPPORT TICKET'),
          Card(
            color: AppColors.cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Can\'t find what you need? Send us a message and we\'ll get back to you within 24 hours.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTicketField(
                    controller: _subjectController,
                    focusNode: _subjectFocus,
                    label: 'Subject',
                    icon: Icons.subject_rounded,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () =>
                        FocusScope.of(context).requestFocus(_messageFocus),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () =>
                        FocusScope.of(context).requestFocus(_messageFocus),
                    child: TextFormField(
                      controller: _messageController,
                      focusNode: _messageFocus,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      autofocus: false,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Describe your issue',
                        labelStyle: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        filled: true,
                        fillColor: AppColors.bgLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryYellow,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isSendingTicket ? null : _submitTicket,
                      icon: _isSendingTicket
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                      label: Text(
                        _isSendingTicket ? 'Sending...' : 'Send Ticket',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return Card(
      color: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: fullWidth
              ? Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: color.withValues(alpha: 0.15),
                      child: Icon(icon, color: color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: color.withValues(alpha: 0.15),
                      child: Icon(icon, color: color, size: 22),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildTicketField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    VoidCallback? onEditingComplete,
  }) {
    return GestureDetector(
      onTap: () {
        if (focusNode != null) {
          FocusScope.of(context).requestFocus(focusNode);
        }
      },
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
        style: const TextStyle(color: AppColors.primaryDark, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          prefixIcon: Icon(icon, color: AppColors.primaryDark, size: 20),
          filled: true,
          fillColor: AppColors.bgLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryYellow,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
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
