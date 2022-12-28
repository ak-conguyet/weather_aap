

class Weather{
  final int weatherCode;
  final String weatherCodition;
  final String weatherDescription;
  final temp;
  final humidity;
  final visibility;
  final double windSpeed;
  final int sunrise;
  final int sunset;
  final String cityName;

  const Weather({
    required this.weatherCode,
    required this.weatherCodition,
    required this.weatherDescription,
    required this.temp,
    required this.humidity,
    required this.visibility,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
    required this.cityName,
  });

  factory Weather.fromJson(Map<String, dynamic> json){
    return Weather(
      weatherCode: json['weather'][0]['id'],
      weatherCodition: json['weather'][0]['main'],
      weatherDescription: json['weather'][0]['description'],
      temp: json['main']['temp'],
      humidity: json['main']['humidity'],
      visibility: json['visibility'],
      windSpeed: json['wind']['speed'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      cityName: json['name']
    );
  }

}