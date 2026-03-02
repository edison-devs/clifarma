import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'observers/base_url_observer.dart';
import 'observers/agendar_cita_observer.dart';
import 'observers/instagram_observer.dart';
import 'observers/tiktok_observer.dart';

Future<void> handleUrlChange(UrlChange change, WebViewController controller) async {
  final url = change.url;
  if (url == null) return;
  await _checkUrlAndExecute(url, controller, isFinished: false);
}

Future<void> handlePageFinished(String url, WebViewController controller) async {
  await _checkUrlAndExecute(url, controller, isFinished: true);
}

Future<void> _checkUrlAndExecute(String url, WebViewController controller, {required bool isFinished}) async {
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  final String cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

  if (url == cleanBaseUrl || url == baseUrl) {
    if (!isFinished) await onBaseUrlDetected(url, controller);
  } else if (url.contains('agendar-cita')) {
    if (!isFinished) {
      await onAgendarCitaStarted(url, controller);
    }
  }
}

Future<NavigationDecision> handleNavigationRequest(NavigationRequest request) async {
  final url = request.url;
  
  final instagramHost = Uri.tryParse(dotenv.env['INSTAGRAM_URL'] ?? '')?.host ?? 'instagram.com';
  final tiktokHost = Uri.tryParse(dotenv.env['TIKTOK_URL'] ?? '')?.host ?? 'tiktok.com';

  if (url.contains(instagramHost)) {
    return await onInstagramNavigation(url);
  } else if (url.contains(tiktokHost)) {
    return await onTikTokNavigation(url);
  }
  
  return NavigationDecision.navigate;
}
