import 'package:flutter/material.dart';

class BottomShape extends StatelessWidget {
  const BottomShape({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: LeftTriangle()),
        Expanded(child: MiddlePentagon()),
        Expanded(child: RightTriangle()),
      ],
    );
  }
}

// Sol üçgen
class LeftTriangle extends StatelessWidget {
  const LeftTriangle({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: LeftTriangleClipper(),
      child: Container(
        height: 100,
        color: const Color(0xFF800020),
      ),
    );
  }
}

class LeftTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width, 0); // sağ üst
    path.lineTo(0, size.height); // sol alt
    path.lineTo(size.width, size.height); // sağ alt
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Sağ üçgen
class RightTriangle extends StatelessWidget {
  const RightTriangle({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: RightTriangleClipper(),
      child: Container(
        height: 100,
        color: const Color(0xFF800020),
      ),
    );
  }
}

class RightTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0); // sol üst
    path.lineTo(size.width, size.height); // sağ alt
    path.lineTo(0, size.height); // sol alt
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Orta beşgen
class MiddlePentagon extends StatelessWidget {
  const MiddlePentagon({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PentagonPainter(),
      child: Container(
        height: 100,
        color: Colors.transparent,
      ),
    );
  }
}

class PentagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF800020)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.25, 0);
    path.lineTo(size.width * 0.5, size.height * 0.6);
    path.lineTo(size.width * 0.75, 0);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
