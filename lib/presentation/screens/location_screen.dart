import 'package:flutter/material.dart';
import 'package:weather_app/config/helpers/database/location.dart';
import 'package:weather_app/infrastructure/models/location_model.dart';
import 'package:weather_app/presentation/screens/weather_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  LocationDB locationDB = LocationDB();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicaciones'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: locationDB.getAllLocations(),
        builder: (
          BuildContext context, 
          AsyncSnapshot<List<LocationModel>?> snapshot){
            if(snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.blue,
                    child: ListTile(
                      title: Text( '${snapshot.data![index].name!}  ${(snapshot.data![index].temp! - 273.15).toStringAsFixed(2)}°', style: const TextStyle( fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black )),
                      subtitle: Text( '${snapshot.data![index].latitude!} ${snapshot.data![index].longitude!}',
                                style: const TextStyle( fontSize: 12, color: Colors.black )),
                      onTap: () => Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context)=> WeatherScreen(
                            lat: snapshot.data![index].latitude!,
                            lon: snapshot.data![index].longitude!
                          )
                        )
                      ),
                      onLongPress: () {
                        Size screenSize = MediaQuery.of(context).size;
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(screenSize.width / 2, screenSize.height / 2, 0, 0),
                          items: [
                            PopupMenuItem(
                              child: ListTile(
                                leading: const Icon(Icons.delete),
                                title: const Text('Eliminar'),
                                onTap: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    snapshot.data!.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
      ),
    );
  }
}