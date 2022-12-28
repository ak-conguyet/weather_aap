
import 'dart:ui';

import 'package:geolocator/geolocator.dart';

import '../MyColors.dart';

class Utils{

  static String getLottieani(int code){
    String result = '';
    int curentHour = DateTime.now().hour;
    bool isDay = curentHour > 5 && curentHour < 18;

    if(code ~/ 100 == 2){
      return isDay ? 'weather_stormshowersday.json' : 'weather_storm.json';
    }

    if(code ~/ 100 < 6){
      return isDay ? 'weather_partly_shower.json' : 'weather_rainynight.json';
    }

    if(code ~/ 100 == 6){
      return isDay ? 'weather_snow_sunny.json' : 'weather_snownight.json';
    }

    if(code ~/ 100 == 7){
      return isDay ? 'weather_foggy.json' : 'weather_mist.json';
    }

    if(code == 800){
      return isDay ? 'weather_sunny.json' : 'weather_night.json';
    }

    return isDay ? 'weather_partly_cloudy.json' : 'weather_cloudynight.json';
  }

  static Color getColor(){
    int hour = DateTime.now().hour;
    if( hour >= 3 && hour < 9) {
      return MyColors.bg4;
    }

    if( hour >= 9  && hour < 15) {
      return MyColors.bg1;
    }

    if( hour >= 15 && hour < 21) {
      return MyColors.bg2;
    }

    return MyColors.bg3;
  }

  static String dateFormat(DateTime dateTime){
    List thu = ['Thứ hai','Thứ ba','Thứ tư','Thứ năm','Thứ sáu','Thứ bảy','Chủ nhật'];
    String value = '${dateTime.day} Tháng ${dateTime.month} . ${thu[dateTime.weekday]}';
    return value;
  }

  static Uri getAPi({Position? position, String? latlon}){
    return latlon == null || latlon.isEmpty ? Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=${position!.latitude}&lon=${position.longitude}&appid=546d37f2d3fb9a29f6b0765ffde7026f&lang=vi&units=metric')
    : Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=${latlon.split('/').first}&lon=${latlon.split('/').last}&appid=546d37f2d3fb9a29f6b0765ffde7026f&lang=vi&units=metric');
  }

}