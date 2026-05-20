import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class DefaultPage extends StatelessWidget {
  const DefaultPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dev Page'),
      ),
      body: Center(
        // Navigator.pop(context);
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or Image
            // SvgPicture.asset(
            //   'lib/assets/icons/m2health_logo.svg',
            //   semanticsLabel: 'm2health_logo',
            //   placeholderBuilder: (BuildContext context) =>
            //       CircularProgressIndicator(),
            // ),
            Image.asset('assets/icons/m2health_banner.png',
                // width: 100,
                height:
                    50), // Replace 'assets/logo.png' with your logo image path
            const Text(
              'Coming Soon ...',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 18.0, // You can also set other text styles as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
