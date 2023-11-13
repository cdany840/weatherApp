import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather_app/config/helpers/database/location.dart';
import 'package:weather_app/config/helpers/open_weather.dart';
import 'package:weather_app/infrastructure/models/location_model.dart';
import 'package:weather_app/presentation/screens/location_screen.dart';
import 'package:weather_app/presentation/widgets/buttons_map.dart';

class WeatherMap extends StatefulWidget {
  const WeatherMap({
    super.key, required this.lat, required this.lon, this.styleMap
  });

  final double lat;
  final double lon;
  final String? styleMap;

  @override
  State<WeatherMap> createState() => _WeatherMapState();
}

class _WeatherMapState extends State<WeatherMap> {
  final token = 'pk.eyJ1IjoiM2NkYW55IiwiYSI6ImNsb3Q0b2IzdTA1ODAya28xaTRzaHV1dHAifQ.-jPsasrhaDigjM3GGz5C3Q';
  String currentMapStyle = 'mapbox/streets-v12';
  List<Marker> markers = [];
  final mapController = MapController();
  final OpenWeather apiOpenWeather = OpenWeather();
  TextEditingController _textEditingController = TextEditingController();
  String name = '';

  LocationDB locationDB = LocationDB();
  String? icon;

  Future<void> _showTextFieldDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ubicación'),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              hintText: 'Ingrese el texto',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  name = _textEditingController.text;
                  _textEditingController.clear();
                });
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _changeMapStyle(String mapStyle) {
    setState(() {
      currentMapStyle = mapStyle;
    });
  }

  void getLocations() async {
    List<LocationModel> data = await locationDB.getAllLocations();
    for (var location in data) {
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(location.latitude!, location.longitude!),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: 'https://openweathermap.org/img/wn/${location.icon}@2x.png',
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.location_pin),
                width: 40,
                height: 40,
              ),
              Text(location.name!, style: const TextStyle(color: Colors.black)),
              Text('${(location.temp! - 273.15).toStringAsFixed(2)}°', style: const TextStyle(color: Colors.black))
            ],
          )
        )
      );
    }
    setState(() {
      
    });
  }

  void loadData(double lat, double lon) async {
    final weather = await apiOpenWeather.getWeatherToday(lat, lon);
    icon = weather!.weather![0].icon;
    await locationDB.insert({
      'name': name,
      'latitude': lat,
      'longitude': lon,
      'icon': icon,
      'temp': weather.main!.temp!
    });
  }

  @override
  void initState() {
    super.initState();
    getLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        centerTitle: true,
        elevation: 15,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute( builder: (context)=> const LocationScreen() )
              );
            },
          ),
        ],
      ),
      body: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          initialCenter: LatLng(widget.lat, widget.lon),
          initialZoom: 20,
          onTap: (point, latLng) {
            _showTextFieldDialog(context).whenComplete(() => loadData(latLng.latitude, latLng.longitude));
            markers.add(
              Marker(
                width: 80.0,
                height: 80.0,
                point: latLng,
                child: CachedNetworkImage(
                  imageUrl: 'https://openweathermap.org/img/wn/$icon@2x.png',
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.location_pin),
                  width: 40,
                  height: 40,
                ),
              ),
            );
            setState(() {
              
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
            additionalOptions: {
              'accessToken': token,
              'id': currentMapStyle,
            },
          ),
          MarkerLayer(
            markers: markers,
          )
        ],
      ),
      floatingActionButton: ButtonsMap(
        onPressed: () {
          setState(() {
            markers.add(
              Marker(
              point: LatLng(widget.lat, widget.lon),
              child: const Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 40,
              ),
            )
            );
          });
        },
        function: _changeMapStyle
      ),
    );
  }
}