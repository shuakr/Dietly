import 'package:flutter/material.dart';

class ProgressCard extends StatefulWidget {
  const ProgressCard({super.key});

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFD6A7B1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (isHovered)
              BoxShadow(
                color: Colors.black,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(
              'assets/goal.png',
              height: 110,
              width: 110,
            ),
            const SizedBox(width: 20),
            const Text(
              'Progress',
              style: TextStyle(
                fontSize: 35,
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
    );
  }
}
