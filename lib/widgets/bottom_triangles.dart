import 'package:flutter/material.dart';

class BottomTriangles extends StatelessWidget {
  const BottomTriangles({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TriangleClipper(),
      child: Container(
        height: 150,
        color: const Color(0xFF800020),
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // 3 büyük üçgen (ekranı yatay 3'e bölerek çiziliyor)
    path.moveTo(0, size.height);
    path.lineTo(size.width * 1 / 6, 0);
    path.lineTo(size.width * 2 / 6, size.height);
    path.lineTo(size.width * 3 / 6, 0);
    path.lineTo(size.width * 4 / 6, size.height);
    path.lineTo(size.width * 5 / 6, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
