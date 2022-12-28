import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../Weather.dart';

abstract class Weather_State extends Equatable{}

class Weather_Initical extends Weather_State{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Weather_onResult extends Weather_Successful{
  Weather_onResult({required super.weather});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Weather_Successful extends Weather_State{

  final Weather weather;
  Weather_Successful({required this.weather}) {
    // TODO: implement Weather_Successful
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [weather];
}

class Weather_Failure extends Weather_State{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Weather_loading extends Weather_State{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}