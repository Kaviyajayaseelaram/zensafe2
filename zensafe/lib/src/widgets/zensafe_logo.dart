import 'package:flutter/material.dart';

class ZenSafeLogo extends StatelessWidget {
  const ZenSafeLogo({
    super.key,
    this.size = 120,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF5AD0FF),
      const Color(0xFF3EB2FF),
    ];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              width: size * 0.12,
              height: size * 0.12,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 18,
            child: Container(
              width: size * 0.16,
              height: size * 0.16,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.28),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(size * 0.18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.14),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.shield_outlined, size: size * 0.7, color: Colors.white),
                Icon(Icons.eco, size: size * 0.4, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



