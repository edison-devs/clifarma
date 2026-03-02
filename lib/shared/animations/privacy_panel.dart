import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants.dart';

class PrivacyPanel extends StatefulWidget {
  final VoidCallback onAccept;
  final String policyUrl;
  final Color backgroundColor;

  const PrivacyPanel({
    super.key,
    required this.onAccept,
    required this.policyUrl,
    this.backgroundColor = AppColors.primary,
  });

  @override
  State<PrivacyPanel> createState() => _PrivacyPanelState();
}

class _PrivacyPanelState extends State<PrivacyPanel> {
  bool _isChecked = false;

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(widget.policyUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/clifarma.png',
                width: 180,
              ),
              const SizedBox(height: 48),
              const Icon(
                Icons.privacy_tip_rounded,
                color: Colors.white,
                size: 64,
              ),
              const SizedBox(height: 24),
              const Text(
                'Tu Privacidad es Importante',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Para continuar usando la aplicación de Clifarma, debes aceptar nuestras políticas de privacidad y términos de servicio.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _launchUrl,
                child: const Text(
                  'Leer Políticas de Privacidad',
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Checkbox para aceptar condiciones
              Theme(
                data: ThemeData(
                  unselectedWidgetColor: Colors.white70,
                ),
                child: CheckboxListTile(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                  title: const Text(
                    'He leído y acepto los términos y condiciones',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.white,
                  checkColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isChecked ? widget.onAccept : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.white.withValues(alpha: 0.3),
                    disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'CONTINUAR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
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
