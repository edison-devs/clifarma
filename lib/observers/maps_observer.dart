import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Future<NavigationDecision> onMapsNavigation(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
  return NavigationDecision.prevent;
}
