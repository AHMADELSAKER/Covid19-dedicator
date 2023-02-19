import 'package:flutter/material.dart';

abstract class BaseAnimationManager{
  init({@required tickerProvider});
  startEnterAnimation();
  startExitAnimation();
  dispose();
}