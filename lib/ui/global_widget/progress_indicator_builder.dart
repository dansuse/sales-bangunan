import 'package:flutter/material.dart';
import 'package:salbang/resources/colors.dart';
import 'package:shimmer/shimmer.dart';
class ProgressIndicatorBuilder{
  static Widget getCenterCircularProgressIndicator(){
    return Center(child: CircularProgressIndicator(valueColor: const AlwaysStoppedAnimation<Color>(colorAccent),),);
  }
  static Widget getLinearCircularProgressIndicator(){
    return LinearProgressIndicator(valueColor: const AlwaysStoppedAnimation<Color>(colorAccent),);
  }

  static Widget shimmerProgressIndicator(){
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        ),
      ),
    );
  }

  static Widget shimmerProgressIndicatorCustomWidth(double customWidth){
    return Container(
      width:customWidth,
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Container(
          width: customWidth,
          height: double.infinity,
          color: Colors.white,
        ),
      ),
    );
  }
}