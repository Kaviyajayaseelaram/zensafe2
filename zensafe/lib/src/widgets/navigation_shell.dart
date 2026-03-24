import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigationShell extends StatelessWidget {
  const MainNavigationShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  void _onTap(int index) {
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = shell.currentIndex;

    return Scaffold(
      // Let each screen handle its own gradient/background
      body: SafeArea(child: shell),

      // Cute, colourful bottom bar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.home_rounded,
                label: 'Home',
                activeColor: const Color(0xFF4C6FFF),
                onTap: _onTap,
              ),
              _NavItem(
                index: 1,
                currentIndex: currentIndex,
                icon: Icons.menu_book_rounded,
                label: 'Learn',
                activeColor: const Color(0xFF22C55E),
                onTap: _onTap,
              ),
              _NavItem(
                index: 2,
                currentIndex: currentIndex,
                icon: Icons.chat_bubble_rounded,
                label: 'Chat',
                activeColor: const Color(0xFF7C5CFF),
                onTap: _onTap,
              ),
              _NavItem(
                index: 3,
                currentIndex: currentIndex,
                icon: Icons.health_and_safety_rounded,
                label: 'Tools',
                activeColor: const Color(0xFFEC4899),
                onTap: _onTap,
              ),
              _NavItem(
                index: 4,
                currentIndex: currentIndex,
                icon: Icons.person_rounded,
                label: 'Profile',
                activeColor: const Color(0xFFF97316),
                onTap: _onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.label,
    required this.activeColor,
    required this.onTap,
  });

  final int index;
  final int currentIndex;
  final IconData icon;
  final String label;
  final Color activeColor;
  final void Function(int) onTap;

  bool get _isActive => index == currentIndex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: _isActive ? activeColor.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: _isActive ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  icon,
                  size: 22,
                  color: _isActive ? activeColor : const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: _isActive ? FontWeight.w600 : FontWeight.w400,
                  color: _isActive ? activeColor : const Color(0xFF9CA3AF),
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
