import 'package:flutter/material.dart';

class NoConnection extends StatelessWidget {
  final VoidCallback onRetry;
  final Color backgroundColor;

  const NoConnection({
    super.key,
    required this.onRetry,
    this.backgroundColor = const Color(0xFF1C2C4C),
  });

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 40),
              const Icon(
                Icons.wifi_off_rounded,
                color: Colors.white54,
                size: 56,
              ),
              const SizedBox(height: 16),
              const Text(
                'Sin conexión a internet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Verifica tu conexión y vuelve a intentarlo.',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1C2C4C),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
