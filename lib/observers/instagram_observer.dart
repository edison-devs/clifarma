import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Future<NavigationDecision> onInstagramNavigation(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  return NavigationDecision.prevent;
}
