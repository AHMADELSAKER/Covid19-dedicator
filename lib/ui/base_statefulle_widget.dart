import 'package:covid19_assistant/local/app_local.dart';
import 'package:flutter/material.dart';

class BaseStateFullWidget extends StatefulWidget {

  @override
  BaseStateFullWidgetState createState() => BaseStateFullWidgetState();
}

class BaseStateFullWidgetState<T extends BaseStateFullWidget> extends State<T> with TickerProviderStateMixin {

  MediaQueryData mediaQuery;
  double width;
  double height;
  var lang;
  AppLocalizations appLocal;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    lang = AppLocalizations.of(context).locale.languageCode;
    appLocal = AppLocalizations.of(context);

    return Container();
  }
}