import 'package:flutter/material.dart';
import 'package:multifunction_app/weather/weather.dart';
import 'package:multifunction_app/Geo/geotest.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'Multifunctional App';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Colors.orange,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> pages = [
    Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.red[100],
      child: const Center(child: Text('First Page')),
    ),
    const WeatherWidget(),
    const GeoWidget(),
    Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.orange[100],
      child: const Center(child: Text('Forth Page')),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multifunctional App'),
      ),
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            activeIcon: Icon(Icons.directions_run),
            label: 'Health',
            tooltip: "Step Counter",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_cloudy),
            activeIcon: Icon(Icons.wb_sunny_rounded),
            label: 'Weather',
            tooltip: "Weather Infomation",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_off),
            activeIcon: Icon(Icons.location_on),
            label: 'Locate',
            tooltip: "Get Location",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pedal_bike),
            activeIcon: Icon(Icons.directions_bike),
            label: 'Bicycle',
            tooltip: "bike",
          ),
        ],
        type: BottomNavigationBarType.shifting,
        //backgroundColor: Colors.red,
        iconSize: 18,
        selectedFontSize: 20,
        selectedIconTheme: const IconThemeData(size: 30, color: Colors.orange),
        selectedLabelStyle: const TextStyle(color: Colors.orange),
        selectedItemColor: Colors.black54,
        unselectedFontSize: 15,
        unselectedIconTheme:
            const IconThemeData(size: 25, color: Colors.black54),
        unselectedLabelStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
