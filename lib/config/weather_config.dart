class WeatherConfig {
  // IMPORTANTE: Reemplaza 'YOUR_API_KEY_HERE' con tu clave API real de OpenWeatherMap
  // Puedes obtener una clave gratuita en: https://openweathermap.org/api
  static const String apiKey = 'YOUR_API_KEY_HERE';
  
  // URL base de la API de OpenWeatherMap
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  
  // Configuración por defecto
  static const String defaultLocation = 'Paraná, Argentina';
  static const double defaultLatitude = -31.7413;
  static const double defaultLongitude = -60.5115;
  
  // Configuración de la aplicación
  static const String appName = 'Guiappesca';
  static const String appVersion = '1.0.0';
}
