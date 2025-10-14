import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  WeatherData? weatherData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    try {
      final data = await WeatherService.getCurrentWeather();
      if (mounted) {
        setState(() {
          weatherData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isPressed = false;
        
        return GestureDetector(
          onTapDown: (_) {
            setState(() {
              isPressed = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              isPressed = false;
            });
          },
          onTapCancel: () {
            setState(() {
              isPressed = false;
            });
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PantallaClima()),
            );
          },
          child: Transform.scale(
            scale: isPressed ? 0.95 : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 180,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF87CEEB), // Azul cielo
                    Color(0xFF98D8E8), // Azul claro
                    Color(0xFF87CEEB), // Azul cielo
                    Color(0xFF4682B4), // Azul acero
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(-4, -4),
                  ),
                  BoxShadow(
                    color: Color(0xFF87CEEB).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Color(0xFF87CEEB).withOpacity(0.2),
                    blurRadius: 35,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    // Fondo decorativo según el clima
                    if (!isLoading && weatherData != null)
                      _buildWeatherBackground(weatherData!.icon),
                    
                    // Contenido principal
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              ),
                            )
                          : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Header con localización
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    weatherData?.location ?? 'Paraná, ER',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                          color: Colors.black45,
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            
                            // Temperatura principal con icono
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  _getWeatherIcon(weatherData?.icon ?? '01d'),
                                  color: Colors.white,
                                  size: 32,
                                  shadows: const [
                                    Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 4,
                                      color: Colors.black45,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [Colors.white, Colors.yellow, Colors.orange],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ).createShader(bounds),
                                  child: Text(
                                    '${weatherData?.temperature.toStringAsFixed(0) ?? '28'}°',
                                    style: const TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      height: 1.0,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 4,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            
                            // Descripción del clima
                            Text(
                              weatherData?.description ?? 'Soleado',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black45,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            
                            // Información adicional en columnas
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Humedad
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.water_drop,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${weatherData?.humidity ?? 65}%',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(1, 1),
                                            blurRadius: 2,
                                            color: Colors.black45,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Humedad',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                // Viento
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.air,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${weatherData?.windSpeed.toStringAsFixed(0) ?? '12'}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(1, 1),
                                            blurRadius: 2,
                                            color: Colors.black45,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'km/h',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Construir fondo decorativo según el clima que llena todo el widget
  Widget _buildWeatherBackground(String iconCode) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Stack(
          children: [
            // Sol grande para clima soleado - Llena el fondo
            if (iconCode == '01d' || iconCode == '01n') ...[
              // Sol gigante de fondo superior derecha
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.yellow.withOpacity(0.8),
                        Colors.orange.withOpacity(0.6),
                        Colors.yellow.withOpacity(0.4),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4, 0.7, 1.0],
                    ),
                  ),
                ),
              ),
              // Sol adicional abajo a la izquierda
              Positioned(
                bottom: -50,
                left: -50,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.orange.withOpacity(0.6),
                        Colors.yellow.withOpacity(0.4),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              // Iconos de sol grandes decorativos
              Positioned(
                top: 5,
                left: 10,
                child: Icon(
                  Icons.wb_sunny,
                  size: 45,
                  color: Colors.yellow.withOpacity(0.4),
                ),
              ),
              Positioned(
                bottom: 15,
                right: 10,
                child: Icon(
                  Icons.wb_sunny,
                  size: 50,
                  color: Colors.orange.withOpacity(0.35),
                ),
              ),
            ],
            
            // Nubes para clima nublado - Múltiples nubes grandes y visibles
            if (iconCode == '02d' || iconCode == '02n' || iconCode == '03d' || iconCode == '03n' || iconCode == '04d' || iconCode == '04n') ...[
              // Nube gigante superior derecha
              Positioned(
                top: -15,
                right: -20,
                child: Icon(
                  Icons.cloud,
                  size: 100,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              // Nube grande superior izquierda
              Positioned(
                top: 10,
                left: -15,
                child: Icon(
                  Icons.cloud,
                  size: 75,
                  color: Colors.white.withOpacity(0.55),
                ),
              ),
              // Nube grande inferior centro
              Positioned(
                bottom: -10,
                left: 25,
                child: Icon(
                  Icons.cloud,
                  size: 85,
                  color: Colors.white.withOpacity(0.45),
                ),
              ),
              // Nube centro derecha
              Positioned(
                top: 55,
                right: 15,
                child: Icon(
                  Icons.cloud,
                  size: 55,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              // Nube pequeña centro izquierda
              Positioned(
                bottom: 45,
                left: 5,
                child: Icon(
                  Icons.cloud,
                  size: 50,
                  color: Colors.white.withOpacity(0.48),
                ),
              ),
            ],
            
            // Lluvia - Nubes y muchas gotas visibles
            if (iconCode == '09d' || iconCode == '09n' || iconCode == '10d' || iconCode == '10n') ...[
              // Nubes oscuras grandes
              Positioned(
                top: -10,
                left: 5,
                child: Icon(
                  Icons.cloud,
                  size: 85,
                  color: Colors.grey.shade600.withOpacity(0.6),
                ),
              ),
              Positioned(
                top: 5,
                right: 0,
                child: Icon(
                  Icons.cloud,
                  size: 75,
                  color: Colors.grey.shade700.withOpacity(0.55),
                ),
              ),
              // Múltiples gotas de lluvia más grandes y visibles
              Positioned(
                top: 50,
                left: 20,
                child: Icon(Icons.water_drop, size: 18, color: Colors.lightBlue.withOpacity(0.7)),
              ),
              Positioned(
                top: 60,
                left: 40,
                child: Icon(Icons.water_drop, size: 16, color: Colors.lightBlue.withOpacity(0.65)),
              ),
              Positioned(
                top: 70,
                left: 30,
                child: Icon(Icons.water_drop, size: 17, color: Colors.lightBlue.withOpacity(0.7)),
              ),
              Positioned(
                top: 55,
                right: 35,
                child: Icon(Icons.water_drop, size: 15, color: Colors.lightBlue.withOpacity(0.65)),
              ),
              Positioned(
                top: 65,
                right: 50,
                child: Icon(Icons.water_drop, size: 16, color: Colors.lightBlue.withOpacity(0.7)),
              ),
              Positioned(
                top: 75,
                right: 40,
                child: Icon(Icons.water_drop, size: 14, color: Colors.lightBlue.withOpacity(0.6)),
              ),
              Positioned(
                bottom: 40,
                left: 50,
                child: Icon(Icons.water_drop, size: 17, color: Colors.lightBlue.withOpacity(0.65)),
              ),
              Positioned(
                bottom: 35,
                right: 25,
                child: Icon(Icons.water_drop, size: 15, color: Colors.lightBlue.withOpacity(0.7)),
              ),
              Positioned(
                bottom: 50,
                left: 65,
                child: Icon(Icons.water_drop, size: 14, color: Colors.lightBlue.withOpacity(0.65)),
              ),
            ],
            
            // Tormenta - Nubes oscuras y múltiples rayos brillantes
            if (iconCode == '11d' || iconCode == '11n') ...[
              // Nubes oscuras grandes
              Positioned(
                top: -15,
                right: -10,
                child: Icon(
                  Icons.cloud,
                  size: 95,
                  color: Colors.grey.shade800.withOpacity(0.65),
                ),
              ),
              Positioned(
                top: 5,
                left: 0,
                child: Icon(
                  Icons.cloud,
                  size: 80,
                  color: Colors.grey.shade700.withOpacity(0.6),
                ),
              ),
              Positioned(
                bottom: -5,
                right: 20,
                child: Icon(
                  Icons.cloud,
                  size: 70,
                  color: Colors.grey.shade600.withOpacity(0.55),
                ),
              ),
              // Rayos grandes y brillantes
              Positioned(
                top: 48,
                right: 20,
                child: Icon(
                  Icons.flash_on,
                  size: 50,
                  color: Colors.yellow.withOpacity(0.85),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 25,
                child: Icon(
                  Icons.flash_on,
                  size: 38,
                  color: Colors.yellow.withOpacity(0.8),
                ),
              ),
              Positioned(
                top: 70,
                left: 60,
                child: Icon(
                  Icons.flash_on,
                  size: 32,
                  color: Colors.yellow.withOpacity(0.75),
                ),
              ),
            ],
            
            // Nieve - Múltiples copos grandes cayendo
            if (iconCode == '13d' || iconCode == '13n') ...[
              Positioned(
                top: 10,
                left: 15,
                child: Icon(Icons.ac_unit, size: 35, color: Colors.white.withOpacity(0.75)),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Icon(Icons.ac_unit, size: 32, color: Colors.white.withOpacity(0.7)),
              ),
              Positioned(
                top: 45,
                left: 40,
                child: Icon(Icons.ac_unit, size: 30, color: Colors.white.withOpacity(0.65)),
              ),
              Positioned(
                top: 55,
                right: 35,
                child: Icon(Icons.ac_unit, size: 28, color: Colors.white.withOpacity(0.75)),
              ),
              Positioned(
                top: 75,
                left: 25,
                child: Icon(Icons.ac_unit, size: 26, color: Colors.white.withOpacity(0.7)),
              ),
              Positioned(
                bottom: 40,
                left: 55,
                child: Icon(Icons.ac_unit, size: 34, color: Colors.white.withOpacity(0.72)),
              ),
              Positioned(
                bottom: 30,
                right: 15,
                child: Icon(Icons.ac_unit, size: 31, color: Colors.white.withOpacity(0.75)),
              ),
              Positioned(
                bottom: 50,
                left: 10,
                child: Icon(Icons.ac_unit, size: 27, color: Colors.white.withOpacity(0.68)),
              ),
              Positioned(
                bottom: 55,
                right: 50,
                child: Icon(Icons.ac_unit, size: 29, color: Colors.white.withOpacity(0.7)),
              ),
            ],
            
            // Niebla - Capas horizontales densas que llenan el widget
            if (iconCode == '50d' || iconCode == '50n') ...[
              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.55),
                        Colors.white.withOpacity(0.55),
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 90,
                left: 0,
                right: 0,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.48),
                        Colors.white.withOpacity(0.48),
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.45),
                        Colors.white.withOpacity(0.45),
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Función para obtener el icono del clima
  IconData _getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
      case '01n':
        return Icons.wb_sunny;
      case '02d':
      case '02n':
      case '03d':
      case '03n':
        return Icons.wb_cloudy;
      case '04d':
      case '04n':
        return Icons.cloud;
      case '09d':
      case '09n':
      case '10d':
      case '10n':
        return Icons.grain;
      case '11d':
      case '11n':
        return Icons.flash_on;
      case '13d':
      case '13n':
        return Icons.ac_unit;
      case '50d':
      case '50n':
        return Icons.foggy;
      default:
        return Icons.wb_sunny;
    }
  }
}

// Pantalla de pronóstico extendido de 10 días
class PantallaClima extends StatefulWidget {
  const PantallaClima({super.key});

  @override
  State<PantallaClima> createState() => _PantallaClimaState();
}

class _PantallaClimaState extends State<PantallaClima> {
  List<WeatherData>? forecast;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadForecast();
  }

  Future<void> _loadForecast() async {
    try {
      final data = await WeatherService.getForecast();
      if (mounted) {
        setState(() {
          forecast = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pronóstico 10 Días',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1976D2),
              Color(0xFF4682B4),
              Color(0xFF87CEEB),
            ],
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadForecast,
                color: const Color(0xFF1976D2),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: forecast?.length ?? 0,
                  itemBuilder: (context, index) {
                    final day = forecast![index];
                    final dayName = _getDayName(day.date);
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              Colors.blue.shade50,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header con día y fecha
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dayName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1976D2),
                                        ),
                                      ),
                                      if (day.date != null)
                                        Text(
                                          '${day.date!.day}/${day.date!.month}/${day.date!.year}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                    ],
                                  ),
                                  Icon(
                                    _getWeatherIcon(day.icon),
                                    size: 48,
                                    color: const Color(0xFF1976D2),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              
                              // Temperatura y descripción
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${day.temperature.toStringAsFixed(0)}°C',
                                        style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1976D2),
                                        ),
                                      ),
                                      Text(
                                        day.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (day.tempMin != null && day.tempMax != null)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.arrow_upward, size: 16, color: Colors.red),
                                            Text(
                                              '${day.tempMax!.toStringAsFixed(0)}°',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.arrow_downward, size: 16, color: Colors.blue),
                                            Text(
                                              '${day.tempMin!.toStringAsFixed(0)}°',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              
                              const Divider(height: 24),
                              
                              // Detalles adicionales
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildDetailItem(
                                    Icons.water_drop,
                                    'Humedad',
                                    '${day.humidity}%',
                                  ),
                                  _buildDetailItem(
                                    Icons.air,
                                    'Viento',
                                    '${day.windSpeed.toStringAsFixed(0)} km/h',
                                  ),
                                  if (day.precipitation != null)
                                    _buildDetailItem(
                                      Icons.grain,
                                      'Lluvia',
                                      '${day.precipitation!.toStringAsFixed(0)}%',
                                    ),
                                  if (day.clouds != null)
                                    _buildDetailItem(
                                      Icons.cloud,
                                      'Nubes',
                                      '${day.clouds}%',
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: const Color(0xFF1976D2)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1976D2),
          ),
        ),
      ],
    );
  }

  String _getDayName(DateTime? date) {
    if (date == null) return 'Hoy';
    
    final now = DateTime.now();
    final difference = date.difference(DateTime(now.year, now.month, now.day)).inDays;
    
    if (difference == 0) return 'Hoy';
    if (difference == 1) return 'Mañana';
    
    const days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return days[date.weekday - 1];
  }

  IconData _getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
      case '01n':
        return Icons.wb_sunny;
      case '02d':
      case '02n':
      case '03d':
      case '03n':
        return Icons.wb_cloudy;
      case '04d':
      case '04n':
        return Icons.cloud;
      case '09d':
      case '09n':
      case '10d':
      case '10n':
        return Icons.grain;
      case '11d':
      case '11n':
        return Icons.flash_on;
      case '13d':
      case '13n':
        return Icons.ac_unit;
      case '50d':
      case '50n':
        return Icons.foggy;
      default:
        return Icons.wb_sunny;
    }
  }
}
