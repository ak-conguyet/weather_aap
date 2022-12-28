import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weather_app/CustonRefreshIndicator.dart';
import 'package:weather_app/Utils/LunarTime.dart';
import 'package:weather_app/Utils/Utils.dart';
import 'package:weather_app/screens/weather_bloc.dart';
import 'package:weather_app/screens/weather_state.dart';

import '../Weather.dart';
import 'Weather_Event.dart';

class HomeBloc extends StatelessWidget {
  const HomeBloc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c)=>Weather_Bloc(),
      child: const Home(),
    );
  }
}


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late RefreshController _refreshController;
  late Weather_Bloc _bloc;

  @override
  void initState() {
    _refreshController = RefreshController();
    _bloc = BlocProvider.of(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Utils.getColor().withOpacity(0.5),
      body: BlocBuilder<Weather_Bloc,Weather_State>(
        bloc: _bloc,
        builder: (_,state){
          if(state is Weather_Initical ){
            _bloc.add(Weather_Request());
            return Container();
          }
          if(state is Weather_loading){
            return SafeArea(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Lottie.asset('lottie/weather_loading.json')
                ),
              ),
            );
          }

          if(state is Weather_Successful){
            Weather weather = state.weather;
            return SafeArea(
              child: RefreshConfiguration(
                child: SmartRefresher(
                    header: CustomRefreshIndicator(),
                    controller: _refreshController,
                    onRefresh: (){
                      _bloc.add(Weather_Refresh());
                    },
                    child: ListView(
                      children: [
                        mainContent(size,weather),
                        _chitietWeather(weather),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _line(title: 'Âm lịch'),
                            _hanNomText(
                                title: 'Ngày',
                                text: LunarTime.now().canChiNgay()
                            ),
                            _hanNomText(
                                title: 'Tháng',
                                text: LunarTime.now().canChiThang()
                            ),
                            _hanNomText(
                                title: 'Năm',
                                text: LunarTime.now().canChiNam()
                            )
                          ],
                        )
                      ],
                    )
                ),
              ),
            );
          }
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Lottie.asset('lottie/weather_partly_cloudy.json'),
                  const Text(
                    'Something is wrong',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'default'
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      'Retry',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                          color: Utils.getColor()
                      ),
                    ),
                    onTap: ()=> _bloc.add(Weather_Request()),
                  )
                ],
              ),
          );
        },
      )
    );
  }

  Widget _hanNomText({required String title,required String text}){
    var  temp = text.split(' ');
    var first = temp.first.split('/');
    var last = temp.last.split('/');
    return _container(
      child: Text(
        '$title: ${first.first}${last.first} - ${first.last} ${last.last}',
        style: _textStyle(),
      )
    );
  }

  Column _chitietWeather(Weather weather) {
    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _line(title: 'Chi tiết'),
                          _container(
                              child: Text(
                                'Nhiệt độ: ${weather.temp} ℃',
                                style: _textStyle(),
                              )
                          ),
                          _container(
                              child: Text(
                                'Độ ẩm: ${weather.humidity}%',
                                style: _textStyle(),
                              )
                          ),
                          _container(
                              child: Text(
                                'Sức gió: ${weather.windSpeed} kph',
                                style: _textStyle(),
                              )
                          ),
                        ],
                      );
  }

  Container _container({required Widget child}){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: child,
    );
  }

  SizedBox mainContent(Size size,Weather data) {
    return SizedBox(
                  height: size.height * (2/3),
                  child: Stack(
                    children: [
                      Positioned(
                          top: 20,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Utils.dateFormat(DateTime.now()),
                                style:_textStyle(),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_pin, size: 16,color: Colors.white,),
                                  SizedBox(width: 5,),
                                  Text(
                                    data.cityName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                      ),
                      Positioned(
                          left: 20,
                          bottom: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.weatherCodition,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                '- ${data.weatherDescription}',
                                style: TextStyle(
                                    color: Colors.white,
                                  fontSize: 16
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          )
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding:const EdgeInsets.only(right: 20),
                          child: _verticalTime(
                              value: LunarTime.now().toStringVi(),
                              size: 22
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:const EdgeInsets.only(left: 20,bottom: 70,top: 30),
                          child: _tietKhi(
                              value: LunarTime.now().tietKhi(),
                              size: 50
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Lottie.asset('lottie/${Utils.getLottieani(data.weatherCode)}'),
                      )
                    ],
                  )
              );
  }

  TextStyle _textStyle() {
    return const TextStyle(
        color: Colors.white, fontSize: 20, );
  }

  Widget _line({String title:''}) {
    return Padding(
      padding: EdgeInsets.only(top: 20,bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.only(left: 50,right: 50),
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold
                ),
              )
          ),
          Expanded(
              child: Container(
                height: 2,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(5))
                ),
              )
          )
        ],
      )
    );
  }

  Widget _verticalTime({required String value, double size:16,}){
    String time = value.replaceAll('/', ' . ');
    List listString = [];
    for(int i =0; i < time.length;i++){
      listString.add(time[i]);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: listString.map((e){
        return Text(
          e,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      }).toList()
    );
  }

  Widget _tietKhi({required String value, double size:16,}){
    var temp = value.split('/');
    String han = temp.first;
    String viet = temp.last;
    List listViet = viet.split(' ');
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text(
                 han[0],
                 style: TextStyle(
                   fontSize: size,
                   fontWeight: FontWeight.bold,
                   color: Colors.white,
                 ),
               ),
               Text(
                 '(${listViet[0]})',
                 style: TextStyle(
                   fontSize: size/5,
                   fontWeight: FontWeight.bold,
                   color: Colors.white,
                 ),
               )
             ],
           ),
         ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  han[1],
                  style: TextStyle(
                    fontSize: size,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '(${listViet[1]})',
                  style: TextStyle(
                    fontSize: size/5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ]
    );
  }
}
