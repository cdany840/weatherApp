import 'package:flutter/material.dart';
import 'package:weather_app/config/helpers/get_location.dart';
import 'package:weather_app/config/helpers/open_weather.dart';
import 'package:weather_app/infrastructure/models/weather_model.dart';
import 'package:weather_app/presentation/widgets/weather_five_days.dart';
import 'package:weather_app/presentation/widgets/weather_map.dart';
import 'package:weather_app/presentation/widgets/weather_today.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({
    super.key,
    this.lat,
    this.lon
  });
  final double? lat;
  final double? lon;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  OpenWeather apiOpenWeather = OpenWeather();
  WeatherModel weatherModel = WeatherModel();
  Map<String, dynamic> cityMap = {};
  GetLocation getLocation = GetLocation();
  List<String> icons = [];

  void getWeather() async {
    await getLocation.getLocationData();
    final WeatherModel weather;
    final Map<String, dynamic> city;
    if (widget.lat != null && widget.lon != null) {
      weather = (await apiOpenWeather.getWeatherToday(widget.lat!, widget.lon!))!;
      city = (await apiOpenWeather.getCityWeather(widget.lat!, widget.lon!))!; 
    } else {
      weather = (await apiOpenWeather.getWeatherToday(getLocation.latitude!, getLocation.longitude!))!;
      city = (await apiOpenWeather.getCityWeather(getLocation.latitude!, getLocation.longitude!))!; 
    }
    setState(() {
      weatherModel = weather;
      cityMap = city;
    });
  }

  @override
  void initState() {    
    getWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return cityMap.isNotEmpty ? Scaffold(
      appBar: AppBar(
        title: Text('${cityMap['country']} / ${cityMap['name']}', style: const TextStyle(color: Colors.black87)),        
        centerTitle: true,
        elevation: 15,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {              
              Navigator.push(
                context, 
                MaterialPageRoute( builder: (context)=> WeatherMap(lat: getLocation.latitude!, lon: getLocation.longitude!) )
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient( //rgb(0, 12, 54) rgb(10, 41, 96) rgb(1, 64, 118) rgb(24, 114, 149) rgb(121, 179, 191)
            colors: [Color.fromARGB(255, 0, 12, 54), Color.fromARGB(255, 10, 41, 96), Color.fromARGB(255, 1, 64, 118)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WeatherToday( weatherModel: weatherModel ),
            const SizedBox( height: 24 ),
            const Text('Weather for five days', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            SizedBox(
              height: 140,
              child: WeatherFiveDays(lat: getLocation.latitude!, lon: getLocation.longitude!,)
            ),
            Container(
              alignment:Alignment.center,
              child: const Text('Clima'),
            ),
          ],
        ),
      ),
    )
    : const SizedBox(
        height: 100.0,
        width: 100.0,
        child: Center(
          child: CircularProgressIndicator()
        ),
      );
  }
}