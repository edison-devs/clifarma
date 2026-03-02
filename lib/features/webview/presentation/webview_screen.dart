import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/config.dart';
import '../../../core/constants.dart';
import '../../navigation/domain/navigation_handler.dart';
import '../../../shared/animations/loader.dart';
import '../../../shared/animations/no_connection.dart';
import '../../../shared/animations/privacy_panel.dart';
import '../../../shared/widgets/speed_dial_fab.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;
  int loadingProgress = 0;
  bool hasConnectionError = false;
  bool isOnHomePage = false;
  bool hasAcceptedPrivacy = false;

  Offset _fabPosition = const Offset(24, -1);

  @override
  void initState() {
    super.initState();
    _initializeController();
    _checkPrivacyConsent();
  }

  void _initializeController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: NavigationHandler.handleNavigationRequest,
          onUrlChange: (change) {
            NavigationHandler.handleUrlChange(change, controller, (isHome) {
              if (mounted) setState(() => isOnHomePage = isHome);
            });
          },
          onPageStarted: (url) {
            if (mounted) {
              setState(() {
                loadingProgress = 0;
                hasConnectionError = false;
              });
            }
          },
          onProgress: (progress) {
            if (mounted) setState(() => loadingProgress = progress);
          },
          onPageFinished: (url) async {
            await NavigationHandler.handlePageFinished(url, controller);
            if (mounted) setState(() => loadingProgress = 100);
          },
          onWebResourceError: (WebResourceError error) {
            if (error.isForMainFrame ?? false) {
              if (mounted) {
                setState(() {
                  hasConnectionError = true;
                  loadingProgress = 100;
                });
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(AppConfig.baseUrl));
  }

  Future<void> _checkPrivacyConsent() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        hasAcceptedPrivacy = prefs.getBool('accepted_privacy') ?? false;
      });
    }
  }

  Future<void> _acceptPrivacy() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('accepted_privacy', true);
    if (mounted) {
      setState(() {
        hasAcceptedPrivacy = true;
      });
    }
  }

  void _retry() {
    if (mounted) {
      setState(() {
        hasConnectionError = false;
        loadingProgress = 0;
      });
    }
    controller.loadRequest(Uri.parse(AppConfig.baseUrl));
  }

  void _loadInWebView(String url) {
    controller.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final canGoBack = await controller.canGoBack();
        if (canGoBack) {
          await controller.goBack();
        } else {
          if (mounted) Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: Container(
            color: AppColors.primary,
            child: Stack(
              children: [
                WebViewWidget(controller: controller),
                if (hasConnectionError)
                  NoConnection(
                    onRetry: _retry,
                    backgroundColor: AppColors.primary,
                  )
                else
                  Loader(
                    loadingProgress: loadingProgress,
                    backgroundColor: AppColors.primary,
                  ),
                if (isOnHomePage && loadingProgress == 100 && !hasConnectionError)
                  SpeedDialFab(
                    initialPosition: _fabPosition,
                    onPositionChanged: (offset) =>
                        if (mounted) setState(() => _fabPosition = offset),
                    agendarUrl: AppConfig.agendaUrl,
                    whatsappNumber: AppConfig.whatsappNumber,
                    mapsUrl: AppConfig.googleMapsUrl,
                    onLoadUrl: _loadInWebView,
                  ),
                if (!hasAcceptedPrivacy)
                  PrivacyPanel(
                    onAccept: _acceptPrivacy,
                    policyUrl: AppConfig.privacyPolicyUrl,
                    backgroundColor: AppColors.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
