
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

typedef CallbackOnSuccess = Function(Position);
class LocationServices{

  static Future<bool> handleLocationPermission({Function()? onDisable,Function()? onAccept,Function()? onDenied,}) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('Location services are disabled. Please enable the services')));
      onDisable == null ? (){} : onDisable();
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Location permissions are denied')));
        onDenied == null ? (){} : onDenied();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      onDisable == null ? (){} : onDisable();
      return false;
    }
    onAccept == null ? (){} : onAccept();
    return true;
  }

  Future<void> getCurrentPosition({required CallbackOnSuccess onSuccess}) async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
          onSuccess(position);
    }).catchError((e) {
      debugPrint(e);
    });
  }
}