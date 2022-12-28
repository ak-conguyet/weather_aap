
import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/screens/weather_state.dart';
import 'package:http/http.dart' as http;
import '../LocationServices.dart';
import '../Utils/Utils.dart';
import '../Weather.dart';
import 'Weather_Event.dart';
class Weather_Bloc extends Bloc<Weather_Event,Weather_State>{
  Weather_Bloc():super(Weather_Initical()){
    on<Weather_Request>((event, emit)=>onRequest());
    on<Weather_Refresh>((event, emit) => onRefresh());
  }

  void onLoading(){
    emit(Weather_loading());
  }

  void onRequest() async{
    onLoading();
    try {
      Weather weather = await _getWeather();
      emit(Weather_Successful(weather: weather));
    } catch (e, s) {
      print(s);
      emit(Weather_Failure());
    }
  }

  Future<void> onInit() async{

  }

  static Weather_State init() {
    return Weather_loading();
  }


  static Future<Weather> _getWeather() async {
    final prefs = await SharedPreferences.getInstance();
    String? latlon = prefs.getString('latlon');
    Position? position;
    if(latlon == null || latlon.isEmpty){
      LocationServices locationServices = LocationServices();
      await locationServices.getCurrentPosition(onSuccess: (p){
        position = p;
        prefs.setString('latlon', '${p.latitude}/${p.longitude}');
      });
    }
    http.Response response = await http.get(Utils.getAPi(
        position: position,
        latlon: latlon
    ));
    return Weather.fromJson(jsonDecode(response.body));
  }

  void onRefresh() async{
    emit(Weather_loading());
    final prefs = await SharedPreferences.getInstance();
    String? latlon = prefs.getString('latlon');
    if(!(latlon == null || latlon.isEmpty)){
      await prefs.remove('latlon');
      print('remove');
    }
    print('refresh');
    try {
      Weather weather = await _getWeather();
      emit(Weather_Successful(weather: weather));
    } catch (e, s) {
      print(s);
      emit(Weather_Failure());
    }
  }

}