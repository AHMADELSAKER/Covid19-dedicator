import 'package:flutter/material.dart';
import 'base_animation_manager.dart';

class HeaderItemAnimationManager extends BaseAnimationManager {

  AnimationController _headerAnimationController;

  AnimationController get headerAnimationController => _headerAnimationController;

  Animation<double> _headerAnimation;

  Animation<double> get headerAnimation => _headerAnimation;

  @override
  init({@required tickerProvider}) {
    /* Controllers */
    _headerAnimationController = AnimationController(duration: const Duration(milliseconds: 800), vsync: tickerProvider);
    /**/

    /* Animation */
    _headerAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(new CurvedAnimation(parent: _headerAnimationController, curve: Interval(0.0, 1.0, curve: Cubic(0.63, 0, 0.23, 1.17))));
       /**/
  }

  @override
  startEnterAnimation() {
    _headerAnimationController.forward();
  }

  @override
  startExitAnimation({rootScreenAnimationManager}){
    _headerAnimationController.animateBack(0, duration: Duration(milliseconds: 650), curve: Cubic(0.63, 0, 0.23, 1.17));
  }

  @override
  dispose() {
    _headerAnimationController.dispose();
  }

}