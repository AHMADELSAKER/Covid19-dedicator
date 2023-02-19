import 'package:covid19_assistant/helper/routes_helper.dart';
import 'package:covid19_assistant/ui/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
    // navigateToClass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(child: Text('Splash screen..'),),
      ),
    );
  }

  _afterLayout(_){
    navigateToClass();
  }

  void navigateToClass() {
    RoutesHelper.navigateTo(classToNavigate: HomeScreen(), context: context);
  }
}
