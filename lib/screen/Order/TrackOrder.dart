import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapfood_v2/l10n/gen_l10n/app_localizations.dart';
import 'package:tapfood_v2/services/PusherServices.dart';
import 'package:tapfood_v2/widgets/LoadingScreen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrackOrder extends StatefulWidget {
  final String orderId;
  final String trackingUrl;
  const TrackOrder({Key? key, required this.orderId, required this.trackingUrl})
      : super(key: key);

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  bool isLoading = true;
  late WebViewController _webViewController;

  @override
  void initState() {
    
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${AppLocalizations.of(context)!.track}${widget.orderId}"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => _webViewController.reload(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: WebView(
                    onPageFinished: (finish) {
                      setState(() {
                        isLoading = false;
                      });
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _webViewController = webViewController;
                    },
                    initialUrl: widget.trackingUrl),
              ),
            ),
          ),
          isLoading ? const LoadingScreen() : Container()
        ],
      ),
    );
  }
}
