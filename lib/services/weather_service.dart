import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../config/weather_config.dart';

class WeatherData {
  final String location;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final String icon;
  final double? tempMin;
  final double? tempMax;
  final double? precipitation;
  final int? clouds;
  final DateTime? date;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    this.tempMin,
    this.tempMax,
    this.precipitation,
    this.clouds,
    this.date,
  });
}

class WeatherService {

  // Obtener ubicación actual del dispositivo
  static Future<Position?> _getCurrentLocation() async {
    try {
      // Verificar si los servicios de ubicación están habilitados
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Obtener posición actual
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
    } catch (e) {
      print('Error obteniendo ubicación: $e');
      return null;
    }
  }

  // Convertir coordenadas a nombre de ciudad
  static Future<String> _getCityName(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String city = place.locality ?? place.administrativeArea ?? 'Ubicación desconocida';
        String country = place.country ?? '';
        return '$city, $country'.trim();
      }
    } catch (e) {
      print('Error obteniendo nombre de ciudad: $e');
    }
    return 'Ubicación desconocida';
  }

  // Obtener datos del clima actual
  static Future<WeatherData?> getCurrentWeather() async {
    try {
      // Obtener ubicación
      Position? position = await _getCurrentLocation();
      if (position == null) {
        // Si no se puede obtener ubicación, usar ubicación por defecto
        return await _getWeatherByCoordinates(
          WeatherConfig.defaultLatitude, 
          WeatherConfig.defaultLongitude, 
          WeatherConfig.defaultLocation
        );
      }

      // Obtener nombre de la ciudad
      String cityName = await _getCityName(position.latitude, position.longitude);

      // Obtener datos del clima
      return await _getWeatherByCoordinates(position.latitude, position.longitude, cityName);
    } catch (e) {
      print('Error obteniendo clima: $e');
      // Retornar datos por defecto en caso de error
      return WeatherData(
        location: WeatherConfig.defaultLocation,
        temperature: 28.0,
        description: 'Soleado',
        humidity: 65,
        windSpeed: 12.0,
        icon: '01d',
      );
    }
  }

  // Obtener clima por coordenadas
  static Future<WeatherData?> _getWeatherByCoordinates(double lat, double lon, String cityName) async {
    try {
      final url = '${WeatherConfig.baseUrl}/weather?lat=$lat&lon=$lon&appid=${WeatherConfig.apiKey}&units=metric&lang=es';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        return WeatherData(
          location: cityName,
          temperature: data['main']['temp'].toDouble(),
          description: data['weather'][0]['description'],
          humidity: data['main']['humidity'],
          windSpeed: data['wind']['speed'].toDouble(),
          icon: data['weather'][0]['icon'],
          tempMin: data['main']['temp_min']?.toDouble(),
          tempMax: data['main']['temp_max']?.toDouble(),
          clouds: data['clouds']?['all'],
        );
      }
    } catch (e) {
      print('Error en API de clima: $e');
    }
    
    // Datos por defecto si la API falla
    return WeatherData(
      location: cityName,
      temperature: 28.0,
      description: 'Soleado',
      humidity: 65,
      windSpeed: 12.0,
      icon: '01d',
    );
  }

  // Obtener pronóstico de 10 días (incluyendo hoy)
  static Future<List<WeatherData>> getForecast() async {
    try {
      Position? position = await _getCurrentLocation();
      if (position == null) {
        // Usar coordenadas por defecto
        position = Position(
          latitude: WeatherConfig.defaultLatitude,
          longitude: WeatherConfig.defaultLongitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      }

      String cityName = await _getCityName(position.latitude, position.longitude);
      
      // Primero obtener clima actual para el día de hoy
      final currentWeather = await _getWeatherByCoordinates(position.latitude, position.longitude, cityName);
      
      List<WeatherData> forecast = [];
      
      // Agregar clima actual como primer elemento con la fecha de hoy
      if (currentWeather != null) {
        forecast.add(WeatherData(
          location: currentWeather.location,
          temperature: currentWeather.temperature,
          description: currentWeather.description,
          humidity: currentWeather.humidity,
          windSpeed: currentWeather.windSpeed,
          icon: currentWeather.icon,
          tempMin: currentWeather.tempMin,
          tempMax: currentWeather.tempMax,
          clouds: currentWeather.clouds,
          precipitation: 0,
          date: DateTime.now(),
        ));
      }
      
      // Obtener pronóstico de los próximos días
      final url = '${WeatherConfig.baseUrl}/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=${WeatherConfig.apiKey}&units=metric&lang=es';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Tomar un pronóstico por día (cada 8 elementos = 1 día, mediodía)
        // Empezar desde índice 4 (mediodía del primer día) y tomar hasta completar 10 días total
        for (int i = 4; i < data['list'].length && forecast.length < 10; i += 8) {
          final item = data['list'][i];
          final dateTime = DateTime.parse(item['dt_txt']);
          
          // Verificar que no sea el día de hoy (ya lo agregamos)
          final today = DateTime.now();
          if (dateTime.day != today.day || dateTime.month != today.month || dateTime.year != today.year) {
            forecast.add(WeatherData(
              location: cityName,
              temperature: item['main']['temp'].toDouble(),
              description: item['weather'][0]['description'],
              humidity: item['main']['humidity'],
              windSpeed: item['wind']['speed'].toDouble(),
              icon: item['weather'][0]['icon'],
              tempMin: item['main']['temp_min']?.toDouble(),
              tempMax: item['main']['temp_max']?.toDouble(),
              precipitation: item['pop'] != null ? (item['pop'] * 100).toDouble() : null,
              clouds: item['clouds']?['all'],
              date: dateTime,
            ));
          }
        }
        
        return forecast;
      }
    } catch (e) {
      print('Error obteniendo pronóstico: $e');
    }
    
    // Pronóstico por defecto
    return _getDefaultForecast();
  }

  // Pronóstico por defecto
  static List<WeatherData> _getDefaultForecast() {
    final now = DateTime.now();
    return [
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 28.0, description: 'Soleado', humidity: 65, windSpeed: 12.0, icon: '01d', tempMin: 24.0, tempMax: 30.0, clouds: 20, precipitation: 0, date: now),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 26.0, description: 'Parcialmente nublado', humidity: 70, windSpeed: 15.0, icon: '02d', tempMin: 22.0, tempMax: 28.0, clouds: 40, precipitation: 10, date: now.add(const Duration(days: 1))),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 24.0, description: 'Nublado', humidity: 75, windSpeed: 18.0, icon: '04d', tempMin: 20.0, tempMax: 26.0, clouds: 80, precipitation: 30, date: now.add(const Duration(days: 2))),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 22.0, description: 'Lluvia ligera', humidity: 80, windSpeed: 20.0, icon: '10d', tempMin: 18.0, tempMax: 24.0, clouds: 90, precipitation: 70, date: now.add(const Duration(days: 3))),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 25.0, description: 'Soleado', humidity: 68, windSpeed: 14.0, icon: '01d', tempMin: 21.0, tempMax: 27.0, clouds: 15, precipitation: 5, date: now.add(const Duration(days: 4))),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 27.0, description: 'Soleado', humidity: 62, windSpeed: 11.0, icon: '01d', tempMin: 23.0, tempMax: 29.0, clouds: 10, precipitation: 0, date: now.add(const Duration(days: 5))),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 29.0, description: 'Soleado', humidity: 60, windSpeed: 10.0, icon: '01d', tempMin: 25.0, tempMax: 31.0, clouds: 5, precipitation: 0, date: now.add(const Duration(days: 6))),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 26.0, description: 'Parcialmente nublado', humidity: 72, windSpeed: 16.0, icon: '02d', tempMin: 22.0, tempMax: 28.0, clouds: 50, precipitation: 20, date: now.add(const Duration(days: 7))),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 23.0, description: 'Nublado', humidity: 78, windSpeed: 19.0, icon: '04d', tempMin: 19.0, tempMax: 25.0, clouds: 85, precipitation: 40, date: now.add(const Duration(days: 8))),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 24.0, description: 'Soleado', humidity: 66, windSpeed: 13.0, icon: '01d', tempMin: 20.0, tempMax: 26.0, clouds: 25, precipitation: 10, date: now.add(const Duration(days: 9))),
    ];
  }
}
