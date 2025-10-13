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

  WeatherData({
    required this.location,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
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

  // Obtener pronóstico de 10 días
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
      
      final url = '${WeatherConfig.baseUrl}/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=${WeatherConfig.apiKey}&units=metric&lang=es';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<WeatherData> forecast = [];
        
        // Tomar un pronóstico por día (cada 8 elementos = 1 día)
        for (int i = 0; i < data['list'].length && i < 80; i += 8) {
          final item = data['list'][i];
          forecast.add(WeatherData(
            location: cityName,
            temperature: item['main']['temp'].toDouble(),
            description: item['weather'][0]['description'],
            humidity: item['main']['humidity'],
            windSpeed: item['wind']['speed'].toDouble(),
            icon: item['weather'][0]['icon'],
          ));
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
    return [
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 28.0, description: 'Soleado', humidity: 65, windSpeed: 12.0, icon: '01d'),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 26.0, description: 'Parcialmente nublado', humidity: 70, windSpeed: 15.0, icon: '02d'),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 24.0, description: 'Nublado', humidity: 75, windSpeed: 18.0, icon: '04d'),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 22.0, description: 'Lluvia ligera', humidity: 80, windSpeed: 20.0, icon: '10d'),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 25.0, description: 'Soleado', humidity: 68, windSpeed: 14.0, icon: '01d'),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 27.0, description: 'Soleado', humidity: 62, windSpeed: 11.0, icon: '01d'),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 29.0, description: 'Soleado', humidity: 60, windSpeed: 10.0, icon: '01d'),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 26.0, description: 'Parcialmente nublado', humidity: 72, windSpeed: 16.0, icon: '02d'),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 23.0, description: 'Nublado', humidity: 78, windSpeed: 19.0, icon: '04d'),
      WeatherData(location: WeatherConfig.defaultLocation, temperature: 24.0, description: 'Soleado', humidity: 66, windSpeed: 13.0, icon: '01d'),
    ];
  }
}
