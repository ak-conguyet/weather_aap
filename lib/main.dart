import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/LocationServices.dart';
import 'package:weather_app/Utils/Utils.dart';
import 'package:weather_app/screens/Home.dart';



void main() {
  DartPluginRegistrant.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.light(
          primary: Utils.getColor(),
          secondary: Utils.getColor(),
        ),
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Hannom'
        )
      ),
      home: App()
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: LocationServices.handleLocationPermission(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Container();
          }
          bool hasPermission = snapshot.data ?? false;
          if(hasPermission){
            return const HomeBloc();
          }
          return noAccessTOLocation();
        },
      ),
    );
  }

  Widget loading(){
    return SafeArea(
      child: Center(
        child: Lottie.asset('lottie/weather_loading.json'),
      ),
    );
  }

  Widget noAccessTOLocation(){
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(50),
            child: Lottie.asset('lottie/no_access_to_location.json'),
          ),
          Text(
            'No access to location',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.5)
            ),
          )
        ],
      )
    );
  }
}


