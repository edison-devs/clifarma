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
    this.backgroundColor = AppColors.white,
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
                color: AppColors.primary,
                size: 64,
              ),
              const SizedBox(height: 24),
              const Text(
                'Tu Privacidad es Importante',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Para continuar usando la aplicación de Clifarma, debes aceptar nuestras políticas de privacidad y términos de servicio.',
                style: TextStyle(
                  color: AppColors.primary,
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
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Checkbox para aceptar condiciones
              Theme(
                data: ThemeData(
                  unselectedWidgetColor: AppColors.primary,
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
                    style: TextStyle(color: AppColors.primary, fontSize: 14),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.primary,
                  checkColor: AppColors.white,
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
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.accent.withOpacity(0.3),
                    disabledForegroundColor: AppColors.white.withOpacity(0.5),
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
