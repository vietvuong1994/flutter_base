import 'package:DJCloud/commons/AppRouter.dart';
import 'package:DJCloud/providers/musicPlayerModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
  
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MusicPlayerModel()),
      ],
      child: MaterialApp(
      themeMode: ThemeMode.system,
      title: 'DJ Cloud App',
      initialRoute: 'home',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.generateRoute,
    ),
    );
    
    
  }
}