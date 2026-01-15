import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gs140okspine/gs140okspine.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'ms_extension_help.dart';

class MSwebkitview extends StatefulWidget {
  final String url;
  final String title;

  const MSwebkitview({super.key, required this.url, required this.title});

  @override
  State<MSwebkitview> createState() => _MSwebkitviewState();
}

class _MSwebkitviewState extends State<MSwebkitview> {
  late final WebViewController _controller;
  final String TAG = "SJwebkitview";

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            final url = request.url;
            "$TAG intercept: $url".log();

            if (navRedirect(url)) {
              urlJump(url);
              return NavigationDecision.prevent; // 拦截特殊 scheme，不加载
            }

            return NavigationDecision.navigate; // 正常加载
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  urlJump(String url) async {
    "$TAG==_jumpNext=canJump:$url=".log();
    if (url.startsWith("intent://")) {
      try {
        Gs140okspine().openBrowser(url.toString());
      } catch (e) {
        //
      }
    } else {
      try {
        String u_go = url;
        if (u_go.startsWith("market://details?id=")) {
          u_go = u_go.replaceAll(
            "market://details",
            "https://play.google.com/store/apps/details",
          );
        }
        launchUrl(Uri.parse(u_go), mode: LaunchMode.externalApplication);
      } catch (e) {
        //
      }
    }
  }

  bool navRedirect(String uuuu) {
    if (uuuu.startsWith("market:") ||
        uuuu.startsWith("http://play.google.com/store/") ||
        uuuu.contains("lz_open_browser=1") ||
        uuuu.startsWith("https://play.google.com/store/") ||
        (uuuu.startsWith("intent://") && Platform.isAndroid) ||
        uuuu.endsWith(".apk")) {
      return true;
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        )
            : null,
      ),
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}