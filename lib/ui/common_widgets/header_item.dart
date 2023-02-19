import 'package:covid19_assistant/helper/app_colors.dart';
import 'package:covid19_assistant/helper/app_fonts.dart';
import 'package:covid19_assistant/helper/enums.dart';
import 'package:covid19_assistant/ui/animation/header_item_animation_manager.dart';
import 'package:covid19_assistant/ui/base_statefulle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class HeaderItem extends BaseStateFullWidget {
  final double offset;
  final onClickGallery;
  final onClickStatistics;
  final onClickHome;
  final homeSection;

  HeaderItem({
    @required this.offset,
    @required this.onClickHome,
    @required this.homeSection,
    @required this.onClickGallery,
    @required this.onClickStatistics,
  });

  @override
  _HeaderItemState createState() => _HeaderItemState();
}

class _HeaderItemState extends BaseStateFullWidgetState<HeaderItem> {

  HeaderItemAnimationManager animationManager;

  @override
  void initState() {
    super.initState();

    animationManager = HeaderItemAnimationManager();
    animationManager.init(tickerProvider: this);
    animationManager.startEnterAnimation();
  }

  @override
  void dispose() {
    animationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedBuilder(
      animation: animationManager.headerAnimationController,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.translationValues(
            0.0,
            animationManager.headerAnimation.value* height,
            0.0,
          ),
          child: ClipPath(
            clipper: MyClipper(),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(left: width *.07, top: width *.08,),
                  height: height * .45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        AppColors.mainColor,
                        AppColors.accentColor,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if(widget.homeSection!=HomeScreenSections.HOME) InkWell(
                            onTap: widget.onClickHome,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.home_rounded , color: Colors.white, size: width*.075,),
                            ),
                          ),
                          if(widget.homeSection!=HomeScreenSections.REPORTS) InkWell(
                            onTap: widget.onClickGallery,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.photo_library_outlined , color: Colors.white, size: width*.075,),
                            ),
                          ),
                          if(widget.homeSection!=HomeScreenSections.STATISTICS) InkWell(
                            onTap: widget.onClickStatistics,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.bar_chart_rounded, color: Colors.white, size: width*.1,),
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            Transform(
                              transform: Matrix4.translationValues(
                                0.0,
                                -animationManager.headerAnimation.value* height,
                                0.0,
                              ),
                              child: Positioned(
                                top: (widget.offset < 0) ? 0 : widget.offset,
                                child: SvgPicture.asset(
                                  'assets/icons/Drcorona.svg',
                                  width: width * .55,
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ),
                            Transform(
                              transform: Matrix4.translationValues(
                                - animationManager.headerAnimation.value* width,
                                0.0,
                                0.0,
                              ),
                              child: Positioned(
                                top: width *.065 - widget.offset / 2,
                                left: width * .35,
                                child: Text(
                                  appLocal.trans("header_message"),
                                  style: TextStyle(
                                    fontSize: AppFonts.getXLargeFontSize(context),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            // I dont know why it can't work without container
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ...buildAnimatedViruses()
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> buildAnimatedViruses(){
    return[
      buildAnimatedVirus(top: 0.0, left: 0.0, size: width/3),
      buildAnimatedVirus(top: height*.075, left: width/2.3, size: width/9),
      buildAnimatedVirus(top: height*.15, left: width*.01, size: width/7.5),
      buildAnimatedVirus(top: height*.105, right: width*.08, size: width/7.5),
      buildAnimatedVirus(right: width*.015, bottom: height*.14, size: width/5),
      buildAnimatedVirus(top: height*.21, left: width/2.3, size: width/4),
    ];
  }

  Widget buildAnimatedVirus({top, left, right, bottom, size}){
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Lottie.asset(
        'assets/animations/lottie_virus.json',
        fit: BoxFit.contain,
        width: size * .707,
        height: size ,
      ),
    );
  }

}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * .70);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width, size.height * .65);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
