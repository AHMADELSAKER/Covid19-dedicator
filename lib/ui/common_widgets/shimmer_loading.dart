import 'package:covid19_assistant/helper/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final width;
  final height;

  ShimmerLoading({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppColors.shimmerBaseColor,
        highlightColor: AppColors.shimmerHighlightColor,
        direction: ShimmerDirection.ttb,
        loop: 12,
        period: Duration(milliseconds: 1800),
        child: Container(
          color: AppColors.white,
          height: height!=null? height : MediaQuery.of(context).size.height,
          width: width!=null? width : MediaQuery.of(context).size.width,
        ));
  }
}
