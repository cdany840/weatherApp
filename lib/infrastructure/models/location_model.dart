class LocationModel {
    String? name;
    String? icon;
    double? temp;
    double? latitude;
    double? longitude;

    LocationModel({
        this.name,
        this.icon,
        this.temp,
        this.latitude,
        this.longitude,
    });

    factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        name: json["name"],
        icon: json["icon"],
        temp: json["temp"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "icon": icon,
        "temp": temp,
        "latitude": latitude,
        "longitude": longitude,
    };
}