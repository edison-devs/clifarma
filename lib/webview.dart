import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'animations/loader.dart';
import 'animations/no_connection.dart';
import 'animations/privacy_panel.dart';
import 'url_observer.dart';
import 'widgets/speed_dial_fab.dart';

class WPWebView extends StatefulWidget {
  const WPWebView({super.key});

  @override
  State<WPWebView> createState() => _WPWebViewState();
}

class _WPWebViewState extends State<WPWebView> {
  late final WebViewController controller;
  int loadingProgress = 0;
  bool hasConnectionError = false;
  bool isOnHomePage = false;
  bool hasAcceptedPrivacy = false;

  // Posición arrastrable del FAB
  Offset _fabPosition = const Offset(24, -1); // -1 = inicializar en build()

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            return await handleNavigationRequest(request);
          },
          onUrlChange: (change) {
            final url = change.url ?? '';
            final baseUrl = dotenv.env['BASE_URL'] ?? '';
            final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

            setState(() {
              isOnHomePage = (url == baseUrl || url == cleanBaseUrl);
            });

            handleUrlChange(change, controller);
          },
          onPageStarted: (url) {
            setState(() {
              loadingProgress = 0;
              hasConnectionError = false;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingProgress = progress;
            });
          },
          onPageFinished: (url) async {
            await handlePageFinished(url, controller);
            setState(() {
              loadingProgress = 100;
            });
          },
          onWebResourceError: (WebResourceError error) {
            if (error.isForMainFrame ?? false) {
              setState(() {
                hasConnectionError = true;
                loadingProgress = 100;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(dotenv.env['BASE_URL']!));
    _checkPrivacyConsent();
  }

  Future<void> _checkPrivacyConsent() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hasAcceptedPrivacy = prefs.getBool('accepted_privacy') ?? false;
    });
  }

  Future<void> _acceptPrivacy() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('accepted_privacy', true);
    setState(() {
      hasAcceptedPrivacy = true;
    });
  }

  void _retry() {
    setState(() {
      hasConnectionError = false;
      loadingProgress = 0;
    });
    controller.loadRequest(Uri.parse(dotenv.env['BASE_URL']!));
  }

  /// Carga cualquier URL en el WebView — el Loader existente cubre la carga.
  void _loadInWebView(String url) {
    controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1C2C4C);

    final agendarUrl = dotenv.env['AGENDA_URL'] ??
        '${dotenv.env['BASE_URL']}agendar-cita/';
    final mapsUrl = dotenv.env['GOOGLE_MAPS_URL'] ?? 'https://maps.app.goo.gl/Q9TG27dRxv8aTXbC8';
    final whatsappNumber = dotenv.env['WHATSAPP_NUMBER'] ?? '50768984998';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final canGoBack = await controller.canGoBack();
        if (canGoBack) {
          await controller.goBack();
        } else {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Container(
            color: backgroundColor,
            child: Stack(
              children: [
                WebViewWidget(controller: controller),

                // Pantalla de error o de carga
                if (hasConnectionError)
                  NoConnection(
                    onRetry: _retry,
                    backgroundColor: backgroundColor,
                  )
                else
                  Loader(
                    loadingProgress: loadingProgress,
                    backgroundColor: backgroundColor,
                  ),

                // Speed-dial arrastrable — solo visible en la home
                if (isOnHomePage && loadingProgress == 100 && !hasConnectionError)
                  SpeedDialFab(
                    initialPosition: _fabPosition,
                    onPositionChanged: (offset) =>
                        setState(() => _fabPosition = offset),
                    agendarUrl: agendarUrl,
                    whatsappNumber: whatsappNumber,
                    mapsUrl: mapsUrl,
                    onLoadUrl: _loadInWebView,
                  ),

                // Panel de Privacidad (Primera carga)
                if (!hasAcceptedPrivacy)
                  PrivacyPanel(
                    onAccept: _acceptPrivacy,
                    policyUrl: dotenv.env['PRIVACY_POLICY_URL'] ?? '',
                    backgroundColor: backgroundColor,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
