import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final int loadingProgress;
  final Color backgroundColor;

  const Loader({
    super.key,
    required this.loadingProgress,
    this.backgroundColor = const Color(0xFF1C2C4C),
  });

  @override
  Widget build(BuildContext context) {
    if (loadingProgress < 100) {
      return Container(
        color: backgroundColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/Interiorisma.png',
                  width: 200,
                ),
                const SizedBox(height: 32),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: loadingProgress > 0 ? loadingProgress / 100.0 : null,
                    color: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
