import 'package:flutter/material.dart';
import '../../core/constants.dart';

class Loader extends StatelessWidget {
  final int loadingProgress;
  final Color backgroundColor;

  const Loader({
    super.key,
    required this.loadingProgress,
    this.backgroundColor = AppColors.white,
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
                  'assets/images/clifarma.png',
                  width: 200,
                ),
                const SizedBox(height: 32),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: loadingProgress > 0 ? loadingProgress / 100.0 : null,
                    color: AppColors.primary,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
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
