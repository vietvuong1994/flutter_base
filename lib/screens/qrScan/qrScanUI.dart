import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

const frontCamera = 'FRONT CAMERA';

class QRScanUI extends StatefulWidget {
  final dynamic argument;
  QRScanUI(this.argument);
  @override
  _QRScanUIState createState() => _QRScanUIState();
}

class _QRScanUIState extends State<QRScanUI> {
  Barcode result;
  var cameraState = frontCamera;
  QRViewController controller;
  double scanArea = 250.0;
  double cutOutBottomOffset = 100.0;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Expanded(child: _buildQrView(context)),
            Expanded(
              child: Center(
                child: Container(
                  child: Text(
                    'Quét mã QR của người giới thiệu',
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  height: scanArea + 80 + cutOutBottomOffset * 2,
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              child: Container(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      onPressed: () {},
                      color: Colors.white,
                      minWidth: 250,
                      height: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(99.0)),
                      child: Text('Bỏ qua'),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: width,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  leadingWidth: 100,
                  leading: FlatButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        Text(
                          'Trở về',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) {
        Future.microtask(
            () => controller?.updateDimensions(qrKey, scanArea: scanArea));
        return false;
      },
      child: SizeChangedLayoutNotifier(
        key: const Key('qr-size-notifier'),
        child: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderLength: 0,
            borderWidth: 0,
            cutOutSize: scanArea,
            cutOutBottomOffset: cutOutBottomOffset,
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      //TODO: navigate
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
