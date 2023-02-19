import 'package:flutter/material.dart';
import 'base_animation_manager.dart';

class HomeAnimationManager extends BaseAnimationManager {

  AnimationController _sectionTitleAnimationController;
  AnimationController _homeComponentsAnimationController;
  AnimationController _reportsComponentsAnimationController;
  AnimationController _statisticsComponentsAnimationController;

  AnimationController get sectionTitleAnimationController => _sectionTitleAnimationController;
  AnimationController get homeComponentsAnimationController => _homeComponentsAnimationController;
  AnimationController get reportsComponentsAnimationController => _reportsComponentsAnimationController;
  AnimationController get statisticsComponentsAnimationController => _statisticsComponentsAnimationController;

  Animation<double> _sectionTitleAnimation;
  Animation<double> _homeComponentsAnimation;
  Animation<double> _reportsComponentsAnimation;
  Animation<double> _statisticsComponentsAnimation;

  Animation<double> get sectionTitleAnimation => _sectionTitleAnimation;
  Animation<double> get homeComponentsAnimation => _homeComponentsAnimation;
  Animation<double> get reportsComponentsAnimation => _reportsComponentsAnimation;
  Animation<double> get statisticsComponentsAnimation => _statisticsComponentsAnimation;

  @override
  init({@required tickerProvider}) {
    /* Controllers */
    _sectionTitleAnimationController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: tickerProvider);
    _homeComponentsAnimationController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: tickerProvider);
    _reportsComponentsAnimationController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: tickerProvider);
    _statisticsComponentsAnimationController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: tickerProvider);
    /**/

    /* Animation */
    _sectionTitleAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(new CurvedAnimation(parent: _sectionTitleAnimationController, curve: Interval(0.0, .75, curve: Cubic(0.63, 0, 0.23, 1.17))));
    _homeComponentsAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(new CurvedAnimation(parent: _homeComponentsAnimationController, curve: Interval(0.3, 1.0, curve: Cubic(0.63, 0, 0.23, 1.17))));
    _reportsComponentsAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(new CurvedAnimation(parent: _reportsComponentsAnimationController, curve: Interval(0.3, 1.0, curve: Cubic(0.63, 0, 0.23, 1.17))));
    _statisticsComponentsAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(new CurvedAnimation(parent: _statisticsComponentsAnimationController, curve: Interval(0.3, 1.0, curve: Cubic(0.63, 0, 0.23, 1.17))));
    /**/
  }

  @override
  startEnterAnimation() {
    _homeComponentsAnimationController.forward();
    _sectionTitleAnimationController.forward();
  }

  @override
  startExitAnimation(){
    _sectionTitleAnimationController.animateBack(0, duration: Duration(milliseconds: 650), curve: Cubic(0.63, 0, 0.23, 1.17));
    _homeComponentsAnimationController.animateBack(0, duration: Duration(milliseconds: 650), curve: Cubic(0.63, 0, 0.23, 1.17));
    _reportsComponentsAnimationController.animateBack(0, duration: Duration(milliseconds: 650), curve: Cubic(0.63, 0, 0.23, 1.17));
    _statisticsComponentsAnimationController.animateBack(0, duration: Duration(milliseconds: 650), curve: Cubic(0.63, 0, 0.23, 1.17));
  }

  @override
  dispose() {
    _sectionTitleAnimationController.dispose();
    _homeComponentsAnimationController.dispose();
    _reportsComponentsAnimationController.dispose();
    _statisticsComponentsAnimationController.dispose();
  }

}