class WeatherModel {
    int? dt;
    Main? main;
    List<Weather>? weather;
    Wind? wind;
    DateTime? dtTxt;

    WeatherModel({
        this.dt,
        this.main,
        this.weather,
        this.wind,
        this.dtTxt,
    });

    factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
        dt: json["dt"],
        main: json["main"] == null ? null : Main.fromJson(json["main"]),
        weather: json["weather"] == null ? [] : List<Weather>.from(json["weather"]!.map((x) => Weather.fromJson(x))),
        wind: json["wind"] == null ? null : Wind.fromJson(json["wind"]),
        dtTxt: json["dt_txt"] == null ? null : DateTime.parse(json["dt_txt"]),
    );

    Map<String, dynamic> toJson() => {
        "dt": dt,
        "main": main?.toJson(),
        "weather": weather == null ? [] : List<dynamic>.from(weather!.map((x) => x.toJson())),
        "wind": wind?.toJson(),
        "dt_txt": dtTxt?.toIso8601String(),
    };
}

class Main {
    double? temp;
    double? feelsLike;
    double? tempMin;
    double? tempMax;
    int? pressure;
    int? seaLevel;
    int? grndLevel;
    int? humidity;
    double? tempKf;

    Main({
        this.temp,
        this.feelsLike,
        this.tempMin,
        this.tempMax,
        this.pressure,
        this.seaLevel,
        this.grndLevel,
        this.humidity,
        this.tempKf,
    });

    factory Main.fromJson(Map<String, dynamic> json) => Main(
        temp: json["temp"]?.toDouble(),
        feelsLike: json["feels_like"]?.toDouble(),
        tempMin: json["temp_min"]?.toDouble(),
        tempMax: json["temp_max"]?.toDouble(),
        pressure: json["pressure"],
        seaLevel: json["sea_level"],
        grndLevel: json["grnd_level"],
        humidity: json["humidity"],
        tempKf: json["temp_kf"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "temp": temp,
        "feels_like": feelsLike,
        "temp_min": tempMin,
        "temp_max": tempMax,
        "pressure": pressure,
        "sea_level": seaLevel,
        "grnd_level": grndLevel,
        "humidity": humidity,
        "temp_kf": tempKf,
    };
}

class Weather {
    int? id;
    String? main;
    String? description;
    String? icon;

    Weather({
        this.id,
        this.main,
        this.description,
        this.icon,
    });

    factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        id: json["id"],
        main: json["main"],
        description: json["description"],
        icon: json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "main": main,
        "description": description,
        "icon": icon,
    };
}

class Wind {
    double? speed;
    int? deg;
    double? gust;

    Wind({
        this.speed,
        this.deg,
        this.gust,
    });

    factory Wind.fromJson(Map<String, dynamic> json) => Wind(
        speed: json["speed"]?.toDouble(),
        deg: json["deg"],
        gust: json["gust"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "speed": speed,
        "deg": deg,
        "gust": gust,
    };
}