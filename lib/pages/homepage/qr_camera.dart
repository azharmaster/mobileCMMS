import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../asset_detail.dart';


class QRcamera extends StatefulWidget {
  const QRcamera({super.key});

  @override
  State<QRcamera> createState() => _QRcameraState();
}

class _QRcameraState extends State<QRcamera> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;

  @override
  void reassemble() async{
    // TODO: implement reassemble
    super.reassemble();
    controller!.resumeCamera();
  }

    void onQRViewCreated(QRViewController controller){
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((barcode) {
      setState(() {
        this.barcode = barcode;
      });
      controller.pauseCamera();
      Navigator.push(context, 
       MaterialPageRoute(
         builder: (context)=> AssetDetail(
           assetNo: barcode.code
           )));
     });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        QRView(
          key: qrKey, 
          onQRViewCreated: onQRViewCreated,
          overlay: QrScannerOverlayShape()),
          Positioned(bottom: 10, child: buildResult())
      ],
    );
  }

    // display qr result
  Widget buildResult() {
    return Text(
      barcode != null ? 'Result : ${barcode!.code}' : 'Scan a code',
      style: const TextStyle(color: Colors.white),
    );
  }
}