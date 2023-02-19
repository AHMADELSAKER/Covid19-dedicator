import 'dart:async';
import 'dart:typed_data';

import 'package:covid19_assistant/bloc/home_bloc.dart';
import 'package:covid19_assistant/helper/app_colors.dart';
import 'package:covid19_assistant/helper/app_fonts.dart';
import 'package:covid19_assistant/helper/enums.dart';
import 'package:covid19_assistant/helper/utils.dart';
import 'package:covid19_assistant/model/report_list.dart';
import 'package:covid19_assistant/model/statistic_list.dart';
import 'package:covid19_assistant/service/api_provider.dart';
import 'package:covid19_assistant/service/data_resource.dart';
import 'package:covid19_assistant/ui/common_widgets/header_item.dart';
import 'package:covid19_assistant/ui/common_widgets/shimmer_loading.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'animation/home_animation_manager.dart';
import 'base_statefulle_widget.dart';
import 'common_widgets/failure_result_widget.dart';

class HomeScreen extends BaseStateFullWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseStateFullWidgetState<HomeScreen> {

  final scrollController = ScrollController();
  double offset = 0;

  final HomeBloc homeBloc = HomeBloc();
  final _selectImageController = BehaviorSubject<Asset>();
  final BehaviorSubject<HomeScreenSections> _screenSectionsController = BehaviorSubject.seeded(HomeScreenSections.HOME);
  final _selectedCountryController = BehaviorSubject<StatisticModel>();
  GoogleMapController googleMapController;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(34.8149, 39.0464523),
    zoom: 2,
  );
  Set<Marker> _markers = {};
  HomeAnimationManager animationManager;

  @override
  void initState() {
    super.initState();

    animationManager = HomeAnimationManager();
    animationManager.init(tickerProvider: this);
    animationManager.startEnterAnimation();

    scrollController.addListener(onScroll);
    // Utils.getMyLocation(onGetLocation: (locationData) async {
    //   googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    //     target: LatLng(
    //       locationData.latitude,
    //       locationData.longitude,
    //     ),
    //     zoom: 13,
    //   )));
    // });

  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (scrollController.hasClients) ? scrollController.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        controller: scrollController,
        child: StreamBuilder<HomeScreenSections>(
          initialData: HomeScreenSections.HOME,
          stream: _screenSectionsController.stream,
          builder: (context, snapshot) {
            return Column(
              children: [
                buildHeader(snapshot.data),
                buildSectionTitle(snapshot.data),
                SizedBox(height: height* .02),
                if(snapshot.data == HomeScreenSections.HOME) buildHomeComponents(),
                if(snapshot.data == HomeScreenSections.REPORTS) buildReportResults(),
                if(snapshot.data == HomeScreenSections.STATISTICS) buildStatisticResults(),
              ],
            );
          }
        ),
      ),
    );
  }

  Widget buildHeader(section){
    return HeaderItem(
      offset: offset,
      homeSection: section,
      onClickGallery: () {
        _selectImageController.sink.add(null);
        _screenSectionsController.sink.add(HomeScreenSections.REPORTS);
        homeBloc.fetchReports();

        animationManager.sectionTitleAnimationController.animateBack(0, duration: Duration(milliseconds: 200), curve: Cubic(0.63, 0, 0.23, 1.17));
        animationManager.homeComponentsAnimationController.animateBack(0, duration: Duration(milliseconds: 650), curve: Cubic(0.63, 0, 0.23, 1.17));
        animationManager.statisticsComponentsAnimationController.animateBack(0, duration: Duration(milliseconds: 650), curve: Cubic(0.63, 0, 0.23, 1.17));
        Timer(Duration(milliseconds: 600), () {
          animationManager.sectionTitleAnimationController.forward();
          animationManager.reportsComponentsAnimationController.forward();
        });
      },
      onClickStatistics: () {
        _selectImageController..sink.add(null);
        homeBloc.fetchStatistics();
        _screenSectionsController.sink.add(HomeScreenSections.STATISTICS);

        animationManager.sectionTitleAnimationController.animateBack(0, duration: Duration(milliseconds: 200), curve: Cubic(0.63, 0, 0.23, 1.17));
        animationManager.homeComponentsAnimationController.animateBack(0, duration: Duration(milliseconds: 650), curve: Cubic(0.63, 0, 0.23, 1.17));
        animationManager.reportsComponentsAnimationController.animateBack(0, duration: Duration(milliseconds: 650), curve: Cubic(0.63, 0, 0.23, 1.17));
        Timer(Duration(milliseconds: 600), () {
          animationManager.sectionTitleAnimationController.forward();
          animationManager.statisticsComponentsAnimationController.forward();
        });
      },
      onClickHome: () {
        _selectImageController.sink.add(null);
        _screenSectionsController.sink.add(HomeScreenSections.HOME);
        homeBloc.setReportDataRes(DataResource.init());

        animationManager.sectionTitleAnimationController.animateBack(0, duration: Duration(milliseconds: 200), curve: Cubic(0.63, 0, 0.23, 1.17));
        animationManager.reportsComponentsAnimationController.animateBack(0, duration: Duration(milliseconds: 650), curve: Cubic(0.63, 0, 0.23, 1.17));
        animationManager.statisticsComponentsAnimationController.animateBack(0, duration: Duration(milliseconds: 650), curve: Cubic(0.63, 0, 0.23, 1.17));
        Timer(Duration(milliseconds: 600), () {
          animationManager.sectionTitleAnimationController.forward();
          animationManager.homeComponentsAnimationController.forward();
        });
      },
    );
  }

  Widget buildSectionTitle(section){
    String title='';
    IconData icon;
    switch(section){
      case HomeScreenSections.HOME:
        title = 'home';
        icon = Icons.home_rounded;
        break;
      case HomeScreenSections.REPORTS:
        title = 'reports';
        icon = Icons.photo_library_outlined;
        break;
      case HomeScreenSections.STATISTICS:
        title = 'statistics';
        icon = Icons.bar_chart_rounded;
        break;
    }
    return AnimatedBuilder(
      animation: animationManager.sectionTitleAnimationController,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.translationValues(
            - animationManager.sectionTitleAnimation.value* width,
            0.0,
            0.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: width* .04,),
              Icon(icon , color: AppColors.mainColor, size: width*.075,),
              SizedBox(width: width*.02,),
              Text(
                appLocal.trans(title),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: AppFonts.getXLargeFontSize(context),
                    color: AppColors.grayDark
                ),
              )
            ],
          ),
        );
      },
    );
  }



  Widget buildHomeComponents(){
    return AnimatedBuilder(
      animation: animationManager.homeComponentsAnimationController,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.translationValues(
            0.0,
            animationManager.homeComponentsAnimation.value* height,
            0.0,
          ),
          child: StreamBuilder<DataResource<ReportModel>>(
              initialData: DataResource.init(),
              stream: homeBloc.reportStream,
              builder: (context, testSnapshot) {
                if (testSnapshot.hasData && testSnapshot.data != null) {
                  switch (testSnapshot.data.status) {
                    case Status.INIT:
                      return buildImageUploader();
                    case Status.LOADING:
                      return Column(
                        children: [
                          buildImageUploader(),
                          buildLoader(),
                        ],
                      );
                    case Status.SUCCESS:
                      return buildReportResult(testSnapshot.data.data);
                    case Status.FAILURE:
                      return FailureResultWidget(
                        message: testSnapshot.data.message,
                        onClickRetry: () {
                          _selectImageController.sink.add(null);
                          homeBloc.setReportDataRes(DataResource.init());
                        },
                      );

                    default:
                      return Container();
                  }
                } else {
                  return Container();
                }
              }
          ),
        );
      },
    );
  }

  Widget buildLoader(){
    return Container(
      child: lottie.Lottie.asset(
        'assets/animations/covid19_loading.json',
        fit: BoxFit.contain,
        width: width * 1,
        height: width * 1 *.4,
      ),
    );
  }

  Widget buildImageUploader(){
    return StreamBuilder<Asset>(
      stream:  _selectImageController.stream,
      builder: (context, assetSnapshot) {
        return Container(
          alignment: Alignment.center,
          width: width * .70,
          height: width * .70,
          // margin: EdgeInsets.only(top: 16, bottom: widget.itemWidth!=null?16:null),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(8),
            color: AppColors.grayXXXLight,
          ),
          child: assetSnapshot?.data==null
              ?
          FlatButton(
            onPressed: () {
              Utils.loadAssets(onData: (Asset asset) {
                _selectImageController.sink.add(asset);
                homeBloc.fetchReport(file: asset);
              }, onError: () {
                Utils.showToast("something_went_wrong", context);
              });
            },
            child: Text(
              appLocal.trans("upload_image"),
              style: TextStyle(
                  fontSize: AppFonts.getMediumFontSize(context),
                  color: AppColors.mainColor,
                  fontWeight: FontWeight.w700
              ),
            ),
          )
              :
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AssetThumb(
              asset: assetSnapshot.data,
              width: (width * .70).round(),
              height: (width * .70).round(),
            ),
          )
        );
      }
    );
  }

  Widget buildReportResult(ReportModel report){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildReportCardItem(report: report),
        SizedBox(height: height*.2),
        RaisedButton(
          elevation: 1.0,
          color: AppColors.mainColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onPressed: () {
            _selectImageController.sink.add(null);
            homeBloc.setReportDataRes(DataResource.init());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
            child: Text(
              appLocal.trans("re_test"),
              style: TextStyle(
                  fontSize: AppFonts.getNormalFontSize(context),
                  color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildReportResults(){
    return AnimatedBuilder(
      animation: animationManager.reportsComponentsAnimationController,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.translationValues(
            0.0,
            animationManager.reportsComponentsAnimation.value* height,
            0.0,
          ),
          child: StreamBuilder(
            stream: homeBloc.reportsStream,
            builder: (context, reportsSnapshot) {
              if (reportsSnapshot.hasData && reportsSnapshot.data != null) {
                switch (reportsSnapshot.data.status) {
                  case Status.LOADING:
                    return buildReportList(isLoading: true);
                  case Status.SUCCESS:
                    return buildReportList(reports: reportsSnapshot.data.data);
                  case Status.NO_RESULTS:
                    return FailureResultWidget(
                      message: 'no_results_message',
                      onClickRetry: () {
                        homeBloc.fetchReports();
                      },
                    );
                  case Status.FAILURE:
                    return FailureResultWidget(
                      message: reportsSnapshot.data.message,
                      onClickRetry: () {
                        homeBloc.fetchReports();
                      },
                    );

                  default:
                    return Container();
                }
              } else {
                return Container();
              }
            },
          ),
        );
      },
    );
  }

  Widget buildReportList({List<ReportModel> reports, isLoading=false,}){
    return AnimationLimiter(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: isLoading ? 8 : reports.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            columnCount: 1,
            position: index,
            duration: const Duration(milliseconds: 400),
            child: SlideAnimation(
              verticalOffset: height * .4,
              child: FadeInAnimation(
                  child: Column(
                      children: [
                        // SizedBox(height: index == 0 ? 8 : 16,),
                        buildReportCardItem(report: isLoading ? null : reports[index], isLoading: isLoading),
                        SizedBox(height: index == (isLoading ? 7 : reports.length-1)? 32 : 24 ,),
                      ]
                  )
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildReportCardItem({ReportModel report, isLoading = false}){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width*.05),
      height: width*.4,
      child: Stack(
        children: [
          if(!isLoading) Container(
            margin: EdgeInsets.symmetric(vertical: width*.02),
            padding: EdgeInsets.only(left: width*.4 + 2*width *.02, top: height* .02, right: width* .02, bottom: height* .02,),
            width: width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.15),
                  blurRadius: 2.0, // soften the shadow
                  spreadRadius: 0.0, //extend the shadow
                  offset: Offset(0.0, 0.0,),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitleResultWidget('result', report.result),
                SizedBox(height: height*.01),
                buildTitleResultWidget('accuracy', '${(double.parse(report.accuracy)*100).toStringAsFixed(2)} %'),
                Spacer(),
                Text(
                  report.getCreatedAtDate(context),
                  style: TextStyle(
                    fontSize: AppFonts.getSmallFontSize(context),
                    color: AppColors.grayLight,
                    height: 1,
                  ),
                  maxLines: 1,
                  softWrap: true,
                ),
              ],
            ),
          ),
          if(isLoading) Container(
              margin: EdgeInsets.symmetric(vertical: width*.02),
              width: width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.15),
                    blurRadius: 2.0, // soften the shadow
                    spreadRadius: 0.0, //extend the shadow
                    offset: Offset(0.0, 0.0,),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ShimmerLoading(width: width, height: double.infinity,),
              ),
          ),

          Container(
            margin: EdgeInsets.only(left: width *.02),
            width: width * .4,
            height: width * .4,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.15),
                  blurRadius: 3.0, // soften the shadow
                  spreadRadius: 0.0, //extend the shadow
                  offset: Offset(0.0, 0.0,),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: isLoading
                  ?
              ShimmerLoading(width: width * .4, height: width * .4,)
                  :
              Utils.buildImage(
                url: ApiProvider.baseUrl+report.url,
                width: width * .4,
                height: width * .4,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTitleResultWidget(title, value){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: AppFonts.getXSmallFontSize(context),
            color: AppColors.grayLight,
            height: 1,
          ),
          maxLines: 1,
          softWrap: true,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: AppFonts.getMediumFontSize(context),
            color: AppColors.grayDark,
            height: 1,
          ),
          maxLines: 1,
          softWrap: true,
        ),
      ],
    );
  }

  Widget buildStatisticResults(){
    return AnimatedBuilder(
      animation: animationManager.statisticsComponentsAnimationController,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.translationValues(
            0.0,
            animationManager.statisticsComponentsAnimation.value* height,
            0.0,
          ),
          child: StreamBuilder<DataResource<List<StatisticModel>>>(
          stream: homeBloc.statisticsStream,
          builder: (context, statisticsSnapshot) {
            if (statisticsSnapshot.hasData && statisticsSnapshot.data != null) {
              switch (statisticsSnapshot.data.status) {
                case Status.LOADING:
                  return Column(
                    children: [
                      buildCountryStatisticsCard(isLoading: true),
                      SizedBox(height: height* .02),
                      buildMapStatisticsCard(isLoading: true),
                      SizedBox(height: height* .04),
                    ],
                  );
                case Status.SUCCESS:
                  _selectedCountryController.sink.add(statisticsSnapshot.data.data.firstWhere((statistic) => statistic.countryInfo.iso2=="SY"));
                  return Column(
                    children: [
                      buildCountryStatisticsCard(statistics: statisticsSnapshot.data.data),
                      SizedBox(height: height* .02),
                      buildMapStatisticsCard(statistics: statisticsSnapshot.data.data),
                      SizedBox(height: height* .04),
                    ],
                  );
                case Status.NO_RESULTS:
                  return FailureResultWidget(
                    message: 'no_results_message',
                    onClickRetry: () {
                      homeBloc.fetchStatistics();
                    },
                  );
                case Status.FAILURE:
                  return FailureResultWidget(
                    message: statisticsSnapshot.data.message,
                    onClickRetry: () {
                      homeBloc.fetchStatistics();
                    },
                  );

                default:
                  return Container();
              }
            } else {
              return Container();
            }
          },
        )
        );
      },
    );

  }

  Widget buildCountryStatisticsCard({List<StatisticModel> statistics, isLoading=false}){
    return StreamBuilder<StatisticModel>(
      stream: _selectedCountryController.stream,
      builder: (context, statisticSnapshot) {
        return Container(
          margin: EdgeInsets.only(left: width*.04, right: width*.04, bottom: height*.01),
          width: double.infinity,
          child: Stack(
            children: [
              if(!isLoading) Container(
                margin: EdgeInsets.only(top: height*.03, left: width*.04, right: width*.04),
                padding: EdgeInsets.only(left: width*.04, top: height* .03, right: width* .04, bottom: height* .12,),
                width: width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.15),
                      blurRadius: 2.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: Offset(0.0, 0.0,),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: width* .19),
                      child: Text(
                        statisticSnapshot?.data?.country??'',
                        style: TextStyle(
                            // fontWeight: FontWeight.w500,
                            fontSize: AppFonts.getLargeFontSize(context),
                            color: AppColors.grayDark,
                          height: 1,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: height* .03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildCountStatistics(
                          icon: Icons.radio_button_checked_rounded,
                          iconColor: Colors.orange,
                          count: Utils.getFormattedCount(statisticSnapshot?.data?.cases??0),
                          titleKey: 'affected',
                        ),
                        buildCountStatistics(
                          icon: Icons.radio_button_checked_rounded,
                          iconColor: Colors.red,
                          count: Utils.getFormattedCount(statisticSnapshot?.data?.deaths??0),
                          titleKey: 'deaths',
                        ),
                        buildCountStatistics(
                          icon: Icons.radio_button_checked_rounded,
                          iconColor: Colors.green,
                          count: Utils.getFormattedCount(statisticSnapshot?.data?.recovered??0),
                          titleKey: 'recovered',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if(isLoading) Container(
                margin: EdgeInsets.only(top: height*.02, left: width*.02, right: width*.02),
                width: width,
                height: height* .35,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.15),
                      blurRadius: 2.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: Offset(0.0, 0.0,),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ShimmerLoading(width: double.infinity,height: double.infinity,),
                ),
              ),
              Container(
                width: width* .25,
                height: width* .18,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.15),
                      blurRadius: 3.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: Offset(0.0, 0.0,),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: isLoading
                      ?
                  ShimmerLoading(width: width* .25, height: width* .18,)
                      :
                  Utils.buildImage(
                    url: statisticSnapshot.data.countryInfo.flag,
                    width: width* .25,
                    height: width* .18,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if(!isLoading) Positioned(
                left: 0,
                right: 0,
                bottom: height* 0.025,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withOpacity(0.15),
                        blurRadius: 2.0, // soften the shadow
                        spreadRadius: 0.0, //extend the shadow
                        offset: Offset(0.0, 0.0,),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownSearch<StatisticModel>(
                    mode: Mode.BOTTOM_SHEET,
                    showSelectedItem: true,
                    items: statistics,
                    hint: appLocal.trans("select_country"),
                    selectedItem: statistics.firstWhere((statistic) => statistic.countryInfo.iso2=="SY"),
                    filterFn: (StatisticModel statistic, filter) => statistic.statisticFilterByCountry(filter),
                    compareFn: (item, selectedItem) => selectedItem.isEqual(item),
                    onFind: (text) async {
                      StatisticModel statistic = statistics.firstWhere((statistic) => statistic.country.toLowerCase()==text, orElse: () => null);
                      _selectedCountryController.sink.add(statistic);
                      return statistics;
                      },
                    itemAsString: (StatisticModel u) => u.country,
                    onChanged: (StatisticModel statistic) => _selectedCountryController.sink.add(statistic),
                    showSearchBox: true,
                    dropdownSearchDecoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: width* .04, vertical: height* .004,),
                      hintText: appLocal.trans('select_country'),
                      hintStyle: TextStyle(
                        color: AppColors.grayXXLight,
                        fontSize: AppFonts.getNormalFontSize(context),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(width: .2, color: AppColors.mainColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(width: .2, color: AppColors.mainColor),
                      ),
                      focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(width: .2, color: AppColors.mainColor),
                      ),
                      focusColor: Colors.white,
                      hoverColor: Colors.white,
                      fillColor: AppColors.white,
                      filled: true,
                    ),
                    searchBoxDecoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      hintText: appLocal.trans('search_country'),
                      hintStyle: TextStyle(
                        color: AppColors.grayXXLight,
                        fontSize: AppFonts.getNormalFontSize(context),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          width: 0,
                        ),
                      ),
                      fillColor: AppColors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(width: 0,),
                      ),
                      focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(width: 0,color: AppColors.mainColor),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget buildCountStatistics({icon, iconColor, count, titleKey}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor, size: width* 0.075,),
        SizedBox(height: height*.02),
        Text(
          count,
          style: TextStyle(
            fontSize: AppFonts.getXXXLargeFontSize(context),
            color: AppColors.grayDark,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
        Text(
          appLocal.trans(titleKey),
          style: TextStyle(
            fontSize: AppFonts.getXSmallFontSize(context),
            color: AppColors.grayLight,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget buildMapStatisticsCard({List<StatisticModel> statistics, isLoading=false}){
    // if(!isLoading) initGoogleMapPins(statistics);
    return Container(
      margin: EdgeInsets.only(left: width*.04, right: width*.04, bottom: height*.01),
      width: double.infinity,
      child: Stack(
        children: [
          if(!isLoading) Container(
            margin: EdgeInsets.only(left: width*.04, right: width*.04),
            padding: EdgeInsets.only(left: width*.04, top: height* .03, right: width* .04, bottom: height* .08,),
            width: width,
            height: height* .5,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.15),
                  blurRadius: 2.0, // soften the shadow
                  spreadRadius: 0.0, //extend the shadow
                  offset: Offset(0.0, 0.0,),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              appLocal.trans('percentage_country'),
              style: TextStyle(
                // fontWeight: FontWeight.w500,
                fontSize: AppFonts.getMediumFontSize(context),
                color: AppColors.grayDark,
                height: 1,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          if(isLoading) Container(
            margin: EdgeInsets.only(top: height*.02, left: width*.02, right: width*.02),
            width: width,
            height: height* .5,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.15),
                  blurRadius: 2.0, // soften the shadow
                  spreadRadius: 0.0, //extend the shadow
                  offset: Offset(0.0, 0.0,),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ShimmerLoading(width: double.infinity,height: double.infinity,),
            ),
          ),
          if(!isLoading) Positioned(
            top: height* .07,
            right: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: height* .4,
                child: GoogleMap(
                  mapType: MapType.normal,
                  zoomControlsEnabled: true,
                  initialCameraPosition: _kGooglePlex,
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;

                    Utils.getMyLocation(onGetLocation: (locationData) async {
                      googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                          target: LatLng(
                            locationData.latitude,
                            locationData.longitude,
                          ),
                          zoom: 5
                      )));
                    });
                    initGoogleMapPins(statistics);
                    },
                  markers: _markers,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  initGoogleMapPins(List<StatisticModel> statistics,) async {
    final Uint8List markerIcon = await Utils.getBytesFromAsset('assets/icons/ic_map_pin.png', 30);
    int totalCases=0;
    statistics.forEach((statistic) {
      totalCases = totalCases+statistic.cases;
    });
    statistics.forEach((statistic) {
      final Marker marker = Marker(
        icon: BitmapDescriptor.fromBytes(
          markerIcon,
        ),
          markerId: MarkerId(statistic.countryInfo.id.toString()),
          position: LatLng(
            statistic.countryInfo.lat,
            statistic.countryInfo.long,
          ),
          infoWindow: InfoWindow(
            title: "${(statistic.cases *100 /totalCases).toStringAsFixed(3)}%",
          ),
          flat: true,
          visible: true,
          onTap: () {
            Fluttertoast.showToast(
              msg: "${statistic.country}\n${(statistic.cases *100 /totalCases).toStringAsFixed(5)}%",
            );
          }
          );

      setState(() {
        _markers.add(marker);
      });
    });
  }

}
