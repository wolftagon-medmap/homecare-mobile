import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MedicalStoreDetailPageParams {
  final int productId;
  final String title;

  MedicalStoreDetailPageParams({required this.productId, required this.title});
}

class MedicalStoreDetailPage extends StatelessWidget {
  final MedicalStoreDetailPageParams params;

  const MedicalStoreDetailPage({super.key, required this.params});

  @override
  Widget build(BuildContext context) {
    final String url =
        'https://www.med-map.org/product-detail/${params.productId}';
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          params.title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
