import 'package:DJCloud/screens/home/homeUI.dart';
import 'package:DJCloud/screens/qrScan/qrScanUI.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const home = 'home';
  static const login = 'login';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var routes = <String, WidgetBuilder>{
      "home": (ctx) => HomeUI(settings.arguments),
      "qrScan": (ctx) => QRScanUI(settings.arguments),
    };
    WidgetBuilder builder = routes[settings.name];
    return MaterialPageRoute(builder: (ctx) => builder(ctx));
  }
}
