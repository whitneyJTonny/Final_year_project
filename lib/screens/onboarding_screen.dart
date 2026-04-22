import 'package:flutter/material.dart';
import 'dart:async';
import 'auth_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<Map<String, String>> _pages = [
    {
      "title": "Power Your Home Anywhere",
      "description":
          "Complete solar kit with panel, lights and control system.",
      "image": "demo1.jpg",
    },
    {
      "title": "Smart Energy Control",
      "description": "Monitor and manage your power with ease.",
      "image": "demo2.jpg",
    },
    {
      "title": "Reliable Lighting Anytime",
      "description": "Bright, efficient lighting powered by solar energy.",
      "image": "demo3.jpg",
    },
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < _pages.length - 1) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 🔥 brand color
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          final page = _pages[index];

          return Stack(
            children: [
              // 🔥 BACKGROUND IMAGE
              Positioned.fill(
                child: Image.asset(
                  page["image"]!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text(
                        "Image not found",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),

              // 🔥 DARK OVERLAY
              Positioned.fill(
                child: Container(color: Colors.black.withValues(alpha: 0.6)),
              ),

              // 🔥 CONTENT
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),

                    Text(
                      page["title"]!,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      page["description"]!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 🔘 INDICATORS
                    Row(
                      children: List.generate(_pages.length, (i) {
                        return Container(
                          margin: const EdgeInsets.only(right: 6),
                          width: _currentPage == i ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == i
                                ? Colors.orange
                                : Colors.white38,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 30),

                    // 🔥 BUTTON
                    if (index == _pages.length - 1)
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AuthSelectionScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "GET STARTED",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
