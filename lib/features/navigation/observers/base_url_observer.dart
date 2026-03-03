import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/config.dart';

/// Detecta si la URL es la base y decide si permitir o prevenir la navegación.
Future<NavigationDecision> onBaseUrlDetected(String url, WebViewController controller) async {
  if (url == AppConfig.baseUrl || url == AppConfig.cleanBaseUrl) {
    // Redirigir inmediatamente a START_URL
    await controller.loadRequest(Uri.parse(AppConfig.startUrl));
    return NavigationDecision.prevent;
  }
  return NavigationDecision.navigate;
}

/// Versión simplificada para eventos de cambio de URL donde no se decide (ya ocurrió).
Future<void> onBaseUrlChanged(String url, WebViewController controller) async {
  if (url == AppConfig.baseUrl || url == AppConfig.cleanBaseUrl) {
    await controller.loadRequest(Uri.parse(AppConfig.startUrl));
  }
}
