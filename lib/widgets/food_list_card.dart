
import 'package:dietly/screens/food_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class FoodListCard extends StatefulWidget {
  const FoodListCard({super.key});

  @override
  State<FoodListCard> createState() => _FoodListCardState();
}

class _FoodListCardState extends State<FoodListCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;

  void _navigateWithPageTransition(Widget page) {
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 400),
        child: page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _isHovered ? 1.0 : 1.05,
        child: GestureDetector(
          onTap: () {
            debugPrint("🍽️ Food List card tapped");
            _navigateWithPageTransition(const FoodSelectionScreen());
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFD6A7B1),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/foodlist.png',
                  height: 48,
                  width: 48,
                ),
                const SizedBox(width: 16),
                const Text(
                  'Food List',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B0010),
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        color: Colors.black26,
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
