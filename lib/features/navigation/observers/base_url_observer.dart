import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

Future<void> onBaseUrlDetected(String url, WebViewController controller) async {
    await controller.runJavaScript("""
    var style = document.createElement('style');
    style.innerHTML = 'section[data-id="18b51fad"], div[data-id="40600b23"], div[data-id="40600b23"] * { display: none !important; margin: 0 !important; padding: 0 !important; visibility: hidden !important; height: 0 !important; opacity: 0 !important;}';
    
    if(document.head) {
      document.head.appendChild(style);
    } else {
      document.addEventListener("DOMContentLoaded", function() {
        document.head.appendChild(style);
      });
    }
  """);
}
