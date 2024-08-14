import 'package:android_smartscholl/helper/constant.dart';
import 'package:flutter/material.dart';

class PanduanPembayaran extends StatelessWidget {
  const PanduanPembayaran({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kPrimaryColor),
        title: const Text(
          'Lihat Pembayaran SPP',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: kPrimaryColor),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
            panEnabled: true, // Set to false to prevent panning.
            boundaryMargin: EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 4,
            child: Image.asset(
              'assets/images/panduanPembayaran.png',
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}
