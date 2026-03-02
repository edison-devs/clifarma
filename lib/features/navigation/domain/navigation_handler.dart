import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/config.dart';
import '../observers/base_url_observer.dart';
import '../observers/instagram_observer.dart';
import '../observers/tiktok_observer.dart';

class NavigationHandler {
  static Future<NavigationDecision> handleNavigationRequest(NavigationRequest request) async {
    final url = request.url;
    
    if (url.contains(AppConfig.instagramHost)) {
      return await onInstagramNavigation(url);
    } else if (url.contains(AppConfig.tiktokHost)) {
      return await onTikTokNavigation(url);
    }
    
    return NavigationDecision.navigate;
  }

  static Future<void> handleUrlChange(UrlChange change, WebViewController controller, Function(bool) onHomePageChanged) async {
    final url = change.url;
    if (url == null) return;

    final bool isHome = (url == AppConfig.baseUrl || url == AppConfig.cleanBaseUrl);
    onHomePageChanged(isHome);

    await _checkUrlAndExecute(url, controller, isFinished: false);
  }

  static Future<void> handlePageFinished(String url, WebViewController controller) async {
    await _checkUrlAndExecute(url, controller, isFinished: true);
  }

  static Future<void> _checkUrlAndExecute(String url, WebViewController controller, {required bool isFinished}) async {
    // Logic for site-specific CSS or element hiding for gruppoclifarma.com goes here
    if (url == AppConfig.cleanBaseUrl || url == AppConfig.baseUrl) {
      if (!isFinished) await onBaseUrlDetected(url, controller);
    }
  }
}
