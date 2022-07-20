import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// ignore: library_prefixes
import 'package:geocoding/geocoding.dart' as geoCording;

String _location = "no data";

class GeoWidget extends StatefulWidget {
  const GeoWidget({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _GeoWidgetState createState() => _GeoWidgetState();
}

class _GeoWidgetState extends State<GeoWidget> {
  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location services are disabled.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final placeMarks = await geoCording.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    final placeMark = placeMarks[0];
    //print("緯度: ${position.latitude}");
    //print("経度: ${position.longitude}");
    //print("高度: ${position.altitude}");

    setState(
      () {
        _location =
            "${placeMark.administrativeArea}\n${placeMark.locality}\n緯度: ${position.latitude}\n経度: ${position.longitude}";
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              // ignore: unnecessary_brace_in_string_interps, unnecessary_string_interpolations
              '${_location}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getLocation,
        child: const Icon(Icons.location_on),
      ),
    );
  }
}
