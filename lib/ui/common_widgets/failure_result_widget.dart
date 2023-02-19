import 'dart:ui';

import 'package:covid19_assistant/helper/app_colors.dart';
import 'package:covid19_assistant/helper/app_fonts.dart';
import 'package:covid19_assistant/local/app_local.dart';
import 'package:flutter/material.dart';

class FailureResultWidget extends StatelessWidget {
  final message;
  final onClickRetry;
  FailureResultWidget({@required this.message, @required this.onClickRetry});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(96),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).trans(message),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grayDark,
                fontSize: AppFonts.getMediumFontSize(context),
              ),
            ),
            SizedBox(height: 16,),
            FlatButton(
              onPressed: onClickRetry,
              child: Text(
                AppLocalizations.of(context).trans("retry"),
                style: TextStyle(
                    fontSize: AppFonts.getMediumFontSize(context),
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.w700
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
