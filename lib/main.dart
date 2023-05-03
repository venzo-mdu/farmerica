import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farmerica/Providers/CartProviders.dart';

import "package:provider/provider.dart";
import 'package:farmerica/ui/splash.dart';
import 'package:farmerica/ui/widgets/checkout_widget.dart';
import 'package:farmerica/utils/sharedServices.dart';

void main() {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
}

class MyApp extends StatelessWidget {
  SharedServices sharedServices = SharedServices();
  bool login = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider.value(value: CartModel())],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: OpenFlutterEcommerceTheme.of(context),
          home: AnimatedSplash(),
        ));
    // home: BasePage()));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
