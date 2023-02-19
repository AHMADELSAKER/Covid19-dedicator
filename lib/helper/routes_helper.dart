import 'package:flutter/material.dart';

class RoutesHelper {

  static void navigateTo({@required Widget classToNavigate, @required BuildContext context}) {
    Navigator.of(context).pushReplacement(PageRouteBuilder<dynamic>(
      pageBuilder: (BuildContext c, Animation<double> a1, Animation<double> a2) => classToNavigate,
      maintainState: true,
      barrierDismissible: true,
      opaque: true,
      transitionsBuilder: (BuildContext c, Animation<double> anim, Animation<double> a2, Widget child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 0),
    ));
  }
}
