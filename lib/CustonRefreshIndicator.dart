import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomRefreshIndicator extends RefreshIndicator{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CustomRefreshIndicator();
  }

}

class _CustomRefreshIndicator extends RefreshIndicatorState<CustomRefreshIndicator>{

  double _offset = 0;


  @override
  void onOffsetChange(double offset) {
    if(offset<0) return;
    setState(() {
      _offset = offset;
    });
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    // TODO: implement buildContent
    return Container(
      margin: EdgeInsets.only(top: 100),
      color: Color(0xffffffff),
      height: _offset,
      width: MediaQuery.of(context).size.width,
      child: Lottie.asset('lottie/weather_loading.json'),
    );
  }

}