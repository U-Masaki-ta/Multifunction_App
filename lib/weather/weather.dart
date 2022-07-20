// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

enum WeatherWidgetState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String key = '5ee161dda7ab27c1a3f834950ac99f2e';
  late WeatherFactory ws;
  List<Weather> _data = [];
  WeatherWidgetState _state = WeatherWidgetState.NOT_DOWNLOADED;
  late double lat, lon;

  @override
  void initState() {
    super.initState();
    ws = WeatherFactory(key);
  }

  void queryForecast() async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _state = WeatherWidgetState.DOWNLOADING;
    });

    List<Weather> forecasts = await ws.fiveDayForecastByLocation(lat, lon);
    setState(() {
      _data = forecasts;
      _state = WeatherWidgetState.FINISHED_DOWNLOADING;
    });
  }

  void queryWeather() async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _state = WeatherWidgetState.DOWNLOADING;
    });

    Weather weather = await ws.currentWeatherByLocation(lat, lon);
    setState(() {
      _data = [weather];
      _state = WeatherWidgetState.FINISHED_DOWNLOADING;
    });
  }

  Widget contentFinishedDownload() {
    return Center(
      child: ListView.separated(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_data[index].toString()),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }

  Widget contentDownloading() {
    return Container(
      margin: const EdgeInsets.all(25),
      child: Column(children: [
        const Text(
          'Fetching Weather...',
          style: TextStyle(fontSize: 20),
        ),
        Container(
            margin: const EdgeInsets.only(top: 50),
            child:
                const Center(child: CircularProgressIndicator(strokeWidth: 10)))
      ]),
    );
  }

  Widget contentNotDownloaded() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[
          const Expanded(
            child: Text('Press the button to download the Weather forecast'),
          ),
        ],
      ),
    );
  }

  Widget _resultView() => _state == WeatherWidgetState.FINISHED_DOWNLOADING
      ? contentFinishedDownload()
      : _state == WeatherWidgetState.DOWNLOADING
          ? contentDownloading()
          : contentNotDownloaded();

  void _saveLat(String input) {
    lat = double.tryParse(input)!;
    debugPrint(input.toString());
  }

  void _saveLon(String input) {
    lon = double.tryParse(input)!;
    debugPrint(lon.toString());
  }

  Widget _coordinateInputs() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              margin: const EdgeInsets.all(5),
              child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter latitude'),
                  keyboardType: TextInputType.number,
                  onChanged: _saveLat,
                  onSubmitted: _saveLat)),
        ),
        Expanded(
            child: Container(
                margin: const EdgeInsets.all(5),
                child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter longitude'),
                    keyboardType: TextInputType.number,
                    onChanged: _saveLon,
                    onSubmitted: _saveLon)))
      ],
    );
  }

  Widget _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(5),
          child: TextButton(
            onPressed: queryWeather,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue)),
            child: const Text(
              'Fetch weather',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(5),
          child: TextButton(
            onPressed: queryForecast,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue)),
            child: const Text(
              'Fetch forecast',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: <Widget>[
            _coordinateInputs(),
            _buttons(),
            const Text(
              'Output:',
              style: TextStyle(fontSize: 20),
            ),
            const Divider(
              height: 20.0,
              thickness: 2.0,
            ),
            Expanded(child: _resultView())
          ],
        ),
      ),
    );
  }
}
