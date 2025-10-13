import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'widgets/calendar_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guía de Pesca',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006064), // Color marino
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
      locale: const Locale('es', 'ES'),
      home: const PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4FC3F7), // Celeste claro
              Color(0xFF29B6F6), // Celeste medio
              Color(0xFF0277BD), // Azul celeste
              Color(0xFF01579B), // Azul más oscuro
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Nombre de la app
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF4CAF50), // Verde brillante
                        Color(0xFF66BB6A), // Verde claro
                        Color(0xFF4CAF50), // Verde brillante
                        Color(0xFF2E7D32), // Verde oscuro
                      ],
                      stops: [0.0, 0.3, 0.7, 1.0],
                    ).createShader(bounds),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Imagen del dorado
                        Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(2, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/dorado_guiappesca.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Si no se encuentra la imagen, mostrar un icono de pez
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFFFFD700), // Dorado
                                        Color(0xFFFFA500), // Naranja dorado
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.set_meal,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // Texto GuiAppesca
                        Text(
                          'GuiAppesca',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 2.0,
                            fontFamily: 'Arial',
                            shadows: [
                              // Bordes nítidos
                              Shadow(
                                offset: Offset(-1, -1),
                                blurRadius: 0,
                                color: Colors.black87,
                              ),
                              Shadow(
                                offset: Offset(1, -1),
                                blurRadius: 0,
                                color: Colors.black87,
                              ),
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 0,
                                color: Colors.black87,
                              ),
                              Shadow(
                                offset: Offset(-1, 1),
                                blurRadius: 0,
                                color: Colors.black87,
                              ),
                              // Efecto de elevación - múltiples capas
                              Shadow(
                                offset: Offset(0, 3),
                                blurRadius: 6,
                                color: Colors.black.withOpacity(0.4),
                              ),
                              Shadow(
                                offset: Offset(0, 6),
                                blurRadius: 12,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              Shadow(
                                offset: Offset(0, 9),
                                blurRadius: 18,
                                color: Colors.black.withOpacity(0.2),
                              ),
                              Shadow(
                                offset: Offset(0, 12),
                                blurRadius: 24,
                                color: Colors.black.withOpacity(0.15),
                              ),
                              Shadow(
                                offset: Offset(0, 15),
                                blurRadius: 30,
                                color: Colors.black.withOpacity(0.1),
                              ),
                              // Sombra lateral para profundidad
                              Shadow(
                                offset: Offset(2, 8),
                                blurRadius: 16,
                                color: Colors.black.withOpacity(0.25),
                              ),
                              Shadow(
                                offset: Offset(-2, 8),
                                blurRadius: 16,
                                color: Colors.black.withOpacity(0.25),
                              ),
                              // Resplandor verde sutil
                              Shadow(
                                offset: Offset(0, 4),
                                blurRadius: 8,
                                color: Color(0xFF4CAF50).withOpacity(0.2),
                              ),
                            ],
                          ),
                        ),
                        // Imagen del dorado (derecha)
                        Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(2, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/dorado_guiappesca.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Si no se encuentra la imagen, mostrar un icono de pez
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFFFFD700), // Dorado
                                        Color(0xFFFFA500), // Naranja dorado
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.set_meal,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Widgets en la parte superior
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Fila superior con agenda y clima
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Widget de agenda
                          _buildAgendaGuia(context),
                          
                          // Widget de clima
                          _buildClimaWidget(context),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Widget de servicios de guías
                      _buildServiciosGuiaWidget(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgendaGuia(BuildContext context) {
    return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PantallaAgendaDetalle()),
            );
          },
          child: Transform.scale(
            scale: 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 160,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1976D2), // Azul metálico claro
                    Color(0xFF1E88E5), // Azul brillante
                    Color(0xFF0D47A1), // Azul metálico oscuro
                    Color(0xFF01579B), // Azul metálico más oscuro
                  ],
                  stops: [0.0, 0.3, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(-3, -3),
                  ),
                  BoxShadow(
                    color: Color(0xFF1976D2).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icono decorativo principal
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Título
                      const Text(
                        'Agenda del Guía',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0.5, 0.5),
                              blurRadius: 1,
                              color: Colors.black45,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      
                      // Fecha actual
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Hoy - 15 de Enero',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 8,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 0.5),
                                blurRadius: 1,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
  }

  Widget _buildClimaWidget(BuildContext context) {
    return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PantallaClima()),
            );
          },
          child: Transform.scale(
            scale: 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 160,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
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
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Header con localización
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Expanded(
                            child: Text(
                              'Paraná, ER',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0.5, 0.5),
                                    blurRadius: 1,
                                    color: Colors.black45,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      
                      // Temperatura y datos del clima
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Temperatura actual
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white,
                                Colors.yellow.withOpacity(0.8),
                                Colors.orange.withOpacity(0.6),
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              '28°C',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          // Humedad
                          Column(
                            children: [
                              const Icon(
                                Icons.water_drop,
                                color: Colors.white,
                                size: 10,
                              ),
                              const Text(
                                '65%',
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0.5, 0.5),
                                      blurRadius: 1,
                                      color: Colors.black45,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Estado del clima y viento
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Estado del clima
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 1,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.wb_sunny,
                                  color: Colors.white,
                                  size: 8,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Soleado',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 7,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 0.5),
                                        blurRadius: 1,
                                        color: Colors.black26,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Viento
                          Row(
                            children: [
                              const Icon(
                                Icons.air,
                                color: Colors.white,
                                size: 8,
                              ),
                              const SizedBox(width: 3),
                              const Text(
                                '12 km/h',
                                style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0.5, 0.5),
                                      blurRadius: 1,
                                      color: Colors.black45,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
  }

  Widget _buildServiciosGuiaWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PantallaServiciosGuia()),
        );
      },
      child: Transform.scale(
        scale: 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 340,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2E7D32), // Verde oscuro
                Color(0xFF4CAF50), // Verde medio
                Color(0xFF66BB6A), // Verde claro
                Color(0xFF388E3C), // Verde profundo
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
                color: Color(0xFF4CAF50).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Color(0xFF4CAF50).withOpacity(0.2),
                blurRadius: 35,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Contenido centrado
                  Expanded(
                    child: Center(
                      child: const Text(
                        'Servicios de Guías de Pesca',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  
                  // Icono principal
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.directions_boat,
                      color: Colors.white,
                      size: 32,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PantallaClima extends StatefulWidget {
  const PantallaClima({super.key});

  @override
  State<PantallaClima> createState() => _PantallaClimaState();
}

class _PantallaClimaState extends State<PantallaClima> {
  // Datos de ejemplo para 10 días
  final List<Map<String, dynamic>> pronostico10Dias = [
    {
      'dia': 'Hoy',
      'fecha': '15 Ene',
      'tempMax': 32,
      'tempMin': 18,
      'estado': 'Soleado',
      'icono': Icons.wb_sunny,
      'humedad': 65,
      'viento': 12,
      'precipitacion': 0,
    },
    {
      'dia': 'Mañana',
      'fecha': '16 Ene',
      'tempMax': 29,
      'tempMin': 16,
      'estado': 'Parcialmente nublado',
      'icono': Icons.wb_cloudy,
      'humedad': 70,
      'viento': 15,
      'precipitacion': 10,
    },
    {
      'dia': 'Miér',
      'fecha': '17 Ene',
      'tempMax': 27,
      'tempMin': 14,
      'estado': 'Lluvioso',
      'icono': Icons.water_drop,
      'humedad': 85,
      'viento': 20,
      'precipitacion': 80,
    },
    {
      'dia': 'Jue',
      'fecha': '18 Ene',
      'tempMax': 25,
      'tempMin': 12,
      'estado': 'Lluvioso',
      'icono': Icons.water_drop,
      'humedad': 90,
      'viento': 18,
      'precipitacion': 95,
    },
    {
      'dia': 'Vie',
      'fecha': '19 Ene',
      'tempMax': 28,
      'tempMin': 15,
      'estado': 'Parcialmente nublado',
      'icono': Icons.wb_cloudy,
      'humedad': 75,
      'viento': 14,
      'precipitacion': 20,
    },
    {
      'dia': 'Sáb',
      'fecha': '20 Ene',
      'tempMax': 31,
      'tempMin': 17,
      'estado': 'Soleado',
      'icono': Icons.wb_sunny,
      'humedad': 60,
      'viento': 10,
      'precipitacion': 0,
    },
    {
      'dia': 'Dom',
      'fecha': '21 Ene',
      'tempMax': 33,
      'tempMin': 19,
      'estado': 'Soleado',
      'icono': Icons.wb_sunny,
      'humedad': 55,
      'viento': 8,
      'precipitacion': 0,
    },
    {
      'dia': 'Lun',
      'fecha': '22 Ene',
      'tempMax': 30,
      'tempMin': 16,
      'estado': 'Parcialmente nublado',
      'icono': Icons.wb_cloudy,
      'humedad': 68,
      'viento': 12,
      'precipitacion': 15,
    },
    {
      'dia': 'Mar',
      'fecha': '23 Ene',
      'tempMax': 26,
      'tempMin': 13,
      'estado': 'Lluvioso',
      'icono': Icons.water_drop,
      'humedad': 88,
      'viento': 22,
      'precipitacion': 70,
    },
    {
      'dia': 'Miér',
      'fecha': '24 Ene',
      'tempMax': 24,
      'tempMin': 11,
      'estado': 'Nublado',
      'icono': Icons.cloud,
      'humedad': 82,
      'viento': 16,
      'precipitacion': 45,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pronóstico 10 Días',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF87CEEB),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF87CEEB), // Azul cielo
              Color(0xFF98D8E8), // Azul claro
              Color(0xFF4FC3F7), // Celeste
              Color(0xFF29B6F6), // Azul celeste
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con localización actual
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Paraná, Entre Ríos',
                              style: TextStyle(
                                fontSize: 20,
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
                            const Text(
                              'Argentina',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 1,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.wb_sunny,
                        color: Colors.white,
                        size: 32,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Lista de pronóstico
                Expanded(
                  child: ListView.builder(
                    itemCount: pronostico10Dias.length,
                    itemBuilder: (context, index) {
                      final dia = pronostico10Dias[index];
                      return _buildDiaPronostico(dia, index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiaPronostico(Map<String, dynamic> dia, int index) {
    Color colorFondo = Colors.white.withOpacity(0.15);
    if (index == 0) {
      colorFondo = Colors.white.withOpacity(0.25);
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Día y fecha
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dia['dia'],
                  style: TextStyle(
                    fontSize: index == 0 ? 18 : 16,
                    fontWeight: index == 0 ? FontWeight.bold : FontWeight.w600,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
                Text(
                  dia['fecha'],
                  style: TextStyle(
                    fontSize: index == 0 ? 14 : 12,
                    color: Colors.white70,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 1),
                        blurRadius: 1,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Icono del clima
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              dia['icono'],
              color: Colors.white,
              size: index == 0 ? 24 : 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Estado del clima
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dia['estado'],
                  style: TextStyle(
                    fontSize: index == 0 ? 14 : 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 1),
                        blurRadius: 1,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.water_drop,
                      color: Colors.white70,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${dia['humedad']}%',
                      style: TextStyle(
                        fontSize: index == 0 ? 12 : 10,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.air,
                      color: Colors.white70,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${dia['viento']} km/h',
                      style: TextStyle(
                        fontSize: index == 0 ? 12 : 10,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                if (dia['precipitacion'] > 0) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.water_drop,
                        color: Colors.blue[200],
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${dia['precipitacion']}%',
                        style: TextStyle(
                          fontSize: index == 0 ? 12 : 10,
                          color: Colors.blue[200],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          
          // Temperaturas
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${dia['tempMax']}°',
                style: TextStyle(
                  fontSize: index == 0 ? 18 : 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              Text(
                '${dia['tempMin']}°',
                style: TextStyle(
                  fontSize: index == 0 ? 14 : 12,
                  color: Colors.white70,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 1),
                      blurRadius: 1,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Enums y modelos de datos
enum FishingMode { spinning, trolling, fly, bait, baitCasting }

enum PaymentStatus { pending, partial, completed }

class ServiceDetails {
  final EquipmentDetails equipment;
  final AccommodationDetails accommodation;

  ServiceDetails({
    this.equipment = const EquipmentDetails(),
    this.accommodation = const AccommodationDetails(),
  });

  ServiceDetails copyWith({
    EquipmentDetails? equipment,
    AccommodationDetails? accommodation,
  }) {
    return ServiceDetails(
      equipment: equipment ?? this.equipment,
      accommodation: accommodation ?? this.accommodation,
    );
  }
}

class EquipmentDetails {
  final int quantity;
  final bool forDoradoSurubi;
  final bool forBogaVariada;

  const EquipmentDetails({
    this.quantity = 0,
    this.forDoradoSurubi = false,
    this.forBogaVariada = false,
  });

  EquipmentDetails copyWith({
    int? quantity,
    bool? forDoradoSurubi,
    bool? forBogaVariada,
  }) {
    return EquipmentDetails(
      quantity: quantity ?? this.quantity,
      forDoradoSurubi: forDoradoSurubi ?? this.forDoradoSurubi,
      forBogaVariada: forBogaVariada ?? this.forBogaVariada,
    );
  }
}

class AccommodationDetails {
  final int nights;
  final bool includesBreakfast;
  final bool includesLunch;
  final bool includesDinner;

  const AccommodationDetails({
    this.nights = 0,
    this.includesBreakfast = false,
    this.includesLunch = false,
    this.includesDinner = false,
  });

  AccommodationDetails copyWith({
    int? nights,
    bool? includesBreakfast,
    bool? includesLunch,
    bool? includesDinner,
  }) {
    return AccommodationDetails(
      nights: nights ?? this.nights,
      includesBreakfast: includesBreakfast ?? this.includesBreakfast,
      includesLunch: includesLunch ?? this.includesLunch,
      includesDinner: includesDinner ?? this.includesDinner,
    );
  }
}

class Booking {
  final DateTime date;
  final String clientName;
  final String clientPhone;
  final String clientLocation;
  final int numberOfFishermen;
  final List<String> targetSpecies;
  final FishingMode fishingMode;
  final List<String> additionalBoats;
  final bool includesBait;
  final bool equipmentRental;
  final bool includesAccommodation;
  final bool includesMeals;
  final int fishingDays;
  final int accommodationNights;
  final double totalPrice;
  final double depositAmount;
  final PaymentStatus paymentStatus;
  final String? notes;
  final ServiceDetails serviceDetails;

  Booking({
    required this.date,
    required this.clientName,
    required this.clientPhone,
    required this.clientLocation,
    required this.numberOfFishermen,
    required this.targetSpecies,
    required this.fishingMode,
    required this.additionalBoats,
    required this.includesBait,
    required this.equipmentRental,
    required this.includesAccommodation,
    required this.includesMeals,
    required this.fishingDays,
    required this.accommodationNights,
    required this.totalPrice,
    required this.depositAmount,
    required this.paymentStatus,
    this.notes,
    required this.serviceDetails,
  });

  // Convertir Booking a Map para JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'clientName': clientName,
      'clientPhone': clientPhone,
      'clientLocation': clientLocation,
      'numberOfFishermen': numberOfFishermen,
      'targetSpecies': targetSpecies,
      'fishingMode': fishingMode.name,
      'additionalBoats': additionalBoats,
      'includesBait': includesBait,
      'equipmentRental': equipmentRental,
      'includesAccommodation': includesAccommodation,
      'includesMeals': includesMeals,
      'fishingDays': fishingDays,
      'accommodationNights': accommodationNights,
      'totalPrice': totalPrice,
      'depositAmount': depositAmount,
      'paymentStatus': paymentStatus.name,
      'notes': notes,
    };
  }

  // Crear Booking desde Map
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      date: DateTime.parse(json['date']),
      clientName: json['clientName'],
      clientPhone: json['clientPhone'],
      clientLocation: json['clientLocation'],
      numberOfFishermen: json['numberOfFishermen'],
      targetSpecies: List<String>.from(json['targetSpecies']),
      fishingMode: FishingMode.values.firstWhere((e) => e.name == json['fishingMode']),
      additionalBoats: List<String>.from(json['additionalBoats']),
      includesBait: json['includesBait'],
      equipmentRental: json['equipmentRental'],
      includesAccommodation: json['includesAccommodation'],
      includesMeals: json['includesMeals'],
      fishingDays: json['fishingDays'],
      accommodationNights: json['accommodationNights'],
      totalPrice: json['totalPrice'].toDouble(),
      depositAmount: json['depositAmount'].toDouble(),
      paymentStatus: PaymentStatus.values.firstWhere((e) => e.name == json['paymentStatus']),
      notes: json['notes'],
      serviceDetails: ServiceDetails(), // Simplificado para persistencia
    );
  }
}

extension FishingModeExtension on FishingMode {
  String get displayName {
    switch (this) {
      case FishingMode.spinning:
        return 'Spinning';
      case FishingMode.trolling:
        return 'Trolling';
      case FishingMode.fly:
        return 'Fly Fishing';
      case FishingMode.bait:
        return 'Carnada';
      case FishingMode.baitCasting:
        return 'Bait Casting';
    }
  }
}

extension PaymentStatusExtension on PaymentStatus {
  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pendiente';
      case PaymentStatus.partial:
        return 'Parcial';
      case PaymentStatus.completed:
        return 'Completado';
    }
  }
}

// Servicio para manejar la persistencia de datos
class BookingStorage {
  static const String _bookingsKey = 'saved_bookings';

  // Guardar lista de contrataciones
  static Future<void> saveBookings(List<Booking> bookings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> bookingsJson = bookings.map((booking) => json.encode(booking.toJson())).toList();
      await prefs.setStringList(_bookingsKey, bookingsJson);
    } catch (e) {
      rethrow;
    }
  }

  // Cargar lista de contrataciones
  static Future<List<Booking>> loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? bookingsJson = prefs.getStringList(_bookingsKey);
    
    if (bookingsJson == null) {
      return [];
    }
    
    try {
      return bookingsJson.map((jsonString) {
        final Map<String, dynamic> bookingMap = json.decode(jsonString);
        return Booking.fromJson(bookingMap);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Agregar una nueva contratación
  static Future<void> addBooking(Booking booking) async {
    try {
      final bookings = await loadBookings();
      bookings.add(booking);
      await saveBookings(bookings);
    } catch (e) {
      rethrow;
    }
  }

  // Eliminar una contratación
  static Future<void> removeBooking(int index) async {
    final bookings = await loadBookings();
    if (index >= 0 && index < bookings.length) {
      bookings.removeAt(index);
      await saveBookings(bookings);
    }
  }
}

class PantallaAgendaDetalle extends StatefulWidget {
  const PantallaAgendaDetalle({super.key});

  @override
  State<PantallaAgendaDetalle> createState() => _PantallaAgendaDetalleState();
}

class _PantallaAgendaDetalleState extends State<PantallaAgendaDetalle> {
  // Lista de contrataciones guardadas
  List<Booking> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  // Cargar contrataciones al inicializar
  Future<void> _loadBookings() async {
    try {
      final loadedBookings = await BookingStorage.loadBookings();
      if (mounted) {
    setState(() {
          bookings = loadedBookings;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar contrataciones: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Agregar nueva contratación
  Future<void> _addBooking(Booking booking) async {
    try {
      await BookingStorage.addBooking(booking);
      if (mounted) {
        setState(() {
          bookings.add(booking);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contratación guardada exitosamente'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar contratación: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Mostrar contrataciones de una fecha específica
  void _showDateBookings(DateTime selectedDate) {
    final dayBookings = bookings.where((booking) =>
        booking.date.year == selectedDate.year &&
        booking.date.month == selectedDate.month &&
        booking.date.day == selectedDate.day).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Contrataciones del ${DateFormat('dd/MM/yyyy').format(selectedDate)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1976D2),
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: dayBookings.isEmpty
              ? const Text(
                  'No hay contrataciones para esta fecha.',
                  style: TextStyle(fontSize: 16),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: dayBookings.length,
                  itemBuilder: (context, index) {
                    final booking = dayBookings[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: const Color(0xFF1976D2),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    booking.clientName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getPaymentStatusColor(booking.paymentStatus),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    booking.paymentStatus.displayName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '👥 ${booking.numberOfFishermen} pescadores',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              '🐟 ${booking.targetSpecies.join(', ')}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              '💰 \$${NumberFormat('#,##0', 'es').format(booking.totalPrice)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cerrar',
              style: TextStyle(color: Color(0xFF1976D2)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agenda del Guía',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1976D2),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PantallaNuevaContratacion(
                      onSaveBooking: _addBooking,
                      existingBookings: bookings,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                'Nueva Contratación',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4FC3F7), // Celeste claro
              Color(0xFF29B6F6), // Celeste medio
              Color(0xFF0277BD), // Azul celeste
              Color(0xFF01579B), // Azul más oscuro
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
        child: Column(
              children: [
                
                // Calendario de disponibilidad
                CalendarWidget(
                  bookedDates: bookings.map((booking) => booking.date).toList(),
                  onDateSelected: (selectedDate) {
                    _showDateBookings(selectedDate);
                  },
                ),
                const SizedBox(height: 16),
                
                // Lista de contrataciones
                Expanded(
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white.withOpacity(0.95),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contrataciones Guardadas',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          if (isLoading)
                            Expanded(
                              child: Center(
                                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
                                    ),
                                    const SizedBox(height: 16),
            Text(
                                      'Cargando contrataciones...',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.withOpacity(0.7),
                                      ),
            ),
          ],
        ),
      ),
                            )
                          else if (bookings.isEmpty)
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 64,
                                      color: Colors.grey.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No hay contrataciones registradas',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Toca "Nueva Contratación" para comenzar',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: ListView.builder(
                                itemCount: bookings.length,
                                itemBuilder: (context, index) {
                                  final booking = bookings[index];
                                  return _buildBookingCard(booking, index);
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking, int index) {
    return GestureDetector(
      onTap: () => _showBookingDetails(booking),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icono de calendario
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF1976D2),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              
              // Información principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.clientName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM/yyyy').format(booking.date),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Estado de pago y botón compartir
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getPaymentStatusColor(booking.paymentStatus),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      booking.paymentStatus.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _shareBooking(booking),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.partial:
        return Colors.blue;
      case PaymentStatus.completed:
        return Colors.green;
    }
  }

  void _showBookingDetails(Booking booking) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Detalles de la Contratación',
            style: const TextStyle(
              color: Color(0xFF1976D2),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Cliente', booking.clientName),
                _buildDetailRow('Teléfono', booking.clientPhone),
                _buildDetailRow('Ubicación', booking.clientLocation),
                _buildDetailRow('Fecha', DateFormat('dd/MM/yyyy').format(booking.date)),
                _buildDetailRow('Número de pescadores', booking.numberOfFishermen.toString()),
                _buildDetailRow('Especies objetivo', booking.targetSpecies.join(', ')),
                _buildDetailRow('Modo de pesca', booking.fishingMode.displayName),
                _buildDetailRow('Precio total', '\$${NumberFormat('#,##0', 'es').format(booking.totalPrice)}'),
                _buildDetailRow('Seña', '\$${NumberFormat('#,##0', 'es').format(booking.depositAmount)}'),
                _buildDetailRow('Estado del pago', booking.paymentStatus.displayName),
                if (booking.notes != null) _buildDetailRow('Notas', booking.notes!),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => _shareBooking(booking),
              child: const Text(
                'Compartir',
                style: TextStyle(color: Color(0xFF4CAF50)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF666666),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF333333)),
            ),
          ),
        ],
      ),
    );
  }

  void _shareBooking(Booking booking) {
    final String shareText = '''
🎣 Contratación de Pesca - GuiAppesca

👤 Cliente: ${booking.clientName}
📞 Teléfono: ${booking.clientPhone}
📍 Ubicación: ${booking.clientLocation}
📅 Fecha: ${DateFormat('dd/MM/yyyy').format(booking.date)}
👥 Pescadores: ${booking.numberOfFishermen}
🐟 Especies: ${booking.targetSpecies.join(', ')}
🎣 Modo: ${booking.fishingMode.displayName}
💰 Precio Total: \$${NumberFormat('#,##0', 'es').format(booking.totalPrice)}
💳 Seña: \$${NumberFormat('#,##0', 'es').format(booking.depositAmount)}
✅ Estado: ${booking.paymentStatus.displayName}
${booking.notes != null ? '📝 Notas: ${booking.notes}' : ''}

Generado por GuiAppesca

---
Comprobante de acuerdos con el guía de pesca
''';

    // Simular compartir (en una app real usarías share_plus)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Compartir Contratación',
            style: TextStyle(
              color: Color(0xFF4CAF50),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.share,
                  size: 48,
                  color: Color(0xFF4CAF50),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Contenido listo para compartir:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Text(
                    shareText,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Este comprobante incluye todos los detalles del acuerdo con el guía de pesca.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF666666),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Aquí copiarías al portapapeles
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Texto copiado al portapapeles'),
                    backgroundColor: Color(0xFF4CAF50),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text(
                'Copiar Texto',
                style: TextStyle(color: Color(0xFF4CAF50)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}

class PantallaNuevaContratacion extends StatefulWidget {
  final Function(Booking) onSaveBooking;
  final List<Booking> existingBookings;

  const PantallaNuevaContratacion({
    super.key,
    required this.onSaveBooking,
    this.existingBookings = const [],
  });

  @override
  State<PantallaNuevaContratacion> createState() => _PantallaNuevaContratacionState();
}

class _PantallaNuevaContratacionState extends State<PantallaNuevaContratacion> {
  // Estados para el formulario
  DateTime selectedDate = DateTime.now();
  bool hasSelectedDate = false;
  String clientName = '';
  String clientPhone = '';
  String clientLocation = '';
  String numberOfFishermen = '';
  String targetSpecies = '';
  Set<String> selectedSpecies = {};
  FishingMode selectedFishingMode = FishingMode.spinning;
  Set<FishingMode> selectedFishingModes = {};
  List<String> additionalBoats = [];
  bool includesBait = false;
  bool equipmentRental = false;
  bool includesAccommodation = false;
  String fishingDays = '';
  String totalPrice = '';
  String depositAmount = '';
  String notes = '';
  
  // Estado del pago
  PaymentStatus paymentStatus = PaymentStatus.pending;
  
  // Estados para detalles de servicios
  ServiceDetails serviceDetails = ServiceDetails();
  
  
  // Estado para el dropdown de especies
  bool showSpeciesDropdown = false;
  
  // Estado para el dropdown de modalidad de pesca
  bool showFishingModeDropdown = false;
  
  // Estados para secciones expandibles de servicios
  bool expandedServices = false;
  bool expandedEquipment = false;
  bool expandedAccommodation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nueva Contratación de Pesca',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1976D2),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFBBDEFB), // Azul claro
              Color(0xFF64B5F6), // Azul medio
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
        child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            Text(
                      '📝 Nueva Contratación de Pesca',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Fecha de la pesca
                    _buildDateButton(),
                    const SizedBox(height: 16),
                    
                    // Nombre del cliente
                    _buildTextField(
                      label: '👤 Nombre del cliente',
                      value: clientName,
                      onChanged: (value) => setState(() => clientName = value),
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    
                    // Teléfono del cliente
                    _buildTextField(
                      label: '📞 Teléfono',
                      value: clientPhone,
                      onChanged: (value) => setState(() => clientPhone = value),
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    
                    // Localidad del cliente
                    _buildTextField(
                      label: '📍 Localidad del cliente',
                      value: clientLocation,
                      onChanged: (value) => setState(() => clientLocation = value),
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 16),
                    
                    // Días de pesca
                    _buildTextField(
                      label: '🎣 Días de pesca',
                      value: fishingDays,
                      onChanged: (value) => setState(() => fishingDays = value),
                      icon: Icons.settings,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    
                    // Número de pescadores
                    _buildTextField(
                      label: '👥 Número de pescadores',
                      value: numberOfFishermen,
                      onChanged: (value) {
                        setState(() {
                          numberOfFishermen = value;
                          // Calcular lanchas adicionales automáticamente
                          final numFishermen = int.tryParse(value) ?? 0;
                          final additionalBoatsCount = numFishermen >= 5
                              ? ((numFishermen - 5) ~/ 3) + 1
                              : 0;
                          
                          // Ajustar la lista de nombres de guías
                          if (additionalBoatsCount > additionalBoats.length) {
                            additionalBoats.addAll(
                              List.filled(additionalBoatsCount - additionalBoats.length, ''),
                            );
                          } else if (additionalBoatsCount < additionalBoats.length) {
                            additionalBoats = additionalBoats.take(additionalBoatsCount).toList();
                          }
                        });
                      },
                      icon: Icons.person,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    
                    // Especie objetivo
                    _buildSpeciesSelector(),
                    const SizedBox(height: 16),
                    
                    // Modalidad de pesca
                    _buildFishingModeSelector(),
                    const SizedBox(height: 16),
                    
                    // Lanchas adicionales
                    _buildAdditionalBoatsSection(),
                    
                    // Servicios incluidos
                    _buildServicesSection(),
                    
                    // Precio total y seña
                    _buildPriceSection(),
                    
                    // Saldo pendiente
                    _buildBalanceSection(),
                    
                    // Notas adicionales
                    _buildTextField(
                      label: '📝 Notas adicionales (opcional)',
                      value: notes,
                      onChanged: (value) => setState(() => notes = value),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    
                    // Botones
                    _buildActionButtons(),
          ],
        ),
      ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateButton() {
    return GestureDetector(
      onTap: _showDatePicker,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.date_range, color: Color(0xFF1976D2)),
                const SizedBox(width: 8),
                Text(
                  hasSelectedDate 
                      ? DateFormat('dd/MM/yyyy').format(selectedDate)
                      : '📅 Fecha de la pesca',
                  style: TextStyle(
                    color: hasSelectedDate ? Color(0xFF1976D2) : Colors.grey,
                    fontWeight: hasSelectedDate ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (selectedDate != null && selectedDate!.isAfter(now)) 
          ? selectedDate! 
          : now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      locale: const Locale('es', 'ES'),
    );
    
    if (picked != null && picked != selectedDate) {
      // Verificar si ya existe una contratación en esa fecha
      final existingBooking = widget.existingBookings.where((booking) =>
          booking.date.year == picked.year &&
          booking.date.month == picked.month &&
          booking.date.day == picked.day).isNotEmpty;
      
      if (existingBooking) {
        // Mostrar advertencia si el día ya está ocupado
        _showDateConflictWarning(picked);
      } else {
        setState(() {
          selectedDate = picked;
          hasSelectedDate = true;
        });
      }
    }
  }

  void _showDateConflictWarning(DateTime conflictDate) {
    final dayBookings = widget.existingBookings.where((booking) =>
        booking.date.year == conflictDate.year &&
        booking.date.month == conflictDate.month &&
        booking.date.day == conflictDate.day).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange, size: 28),
            const SizedBox(width: 8),
            const Text(
              'Fecha Ocupada',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'El día ${DateFormat('dd/MM/yyyy').format(conflictDate)} ya tiene ${dayBookings.length} contratación${dayBookings.length > 1 ? 'es' : ''}:',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            ...dayBookings.map((booking) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.orange, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.clientName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${booking.numberOfFishermen} pescadores',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )).toList(),
            const SizedBox(height: 12),
            const Text(
              '¿Desea continuar con esta fecha de todas formas?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                selectedDate = conflictDate;
                hasSelectedDate = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSpeciesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => showSpeciesDropdown = !showSpeciesDropdown),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFF1976D2)),
                    const SizedBox(width: 8),
                    Text(
                      selectedSpecies.isNotEmpty 
                          ? selectedSpecies.join(', ')
                          : '🐟 Especie que vienen a pescar',
                      style: TextStyle(
                        color: selectedSpecies.isNotEmpty ? Color(0xFF1976D2) : Colors.grey,
                        fontWeight: selectedSpecies.isNotEmpty ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Icon(
                  showSpeciesDropdown ? Icons.keyboard_arrow_up : Icons.arrow_drop_down,
                  color: Color(0xFF1976D2),
                ),
              ],
            ),
          ),
        ),
        if (showSpeciesDropdown)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: ['Dorado', 'Surubí', 'Boga', 'Variada'].map((species) {
                return CheckboxListTile(
                  title: Text(species),
                  value: selectedSpecies.contains(species),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        selectedSpecies.add(species);
                      } else {
                        selectedSpecies.remove(species);
                      }
                      targetSpecies = selectedSpecies.join(', ');
                    });
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildFishingModeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => showFishingModeDropdown = !showFishingModeDropdown),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFF1976D2)),
                    const SizedBox(width: 8),
                    Text(
                      selectedFishingModes.isNotEmpty 
                          ? selectedFishingModes.map((mode) => mode.displayName).join(', ')
                          : '🎣 Modalidad de pesca',
                      style: TextStyle(
                        color: selectedFishingModes.isNotEmpty ? Color(0xFF1976D2) : Colors.grey,
                        fontWeight: selectedFishingModes.isNotEmpty ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Icon(
                  showFishingModeDropdown ? Icons.keyboard_arrow_up : Icons.arrow_drop_down,
                  color: Color(0xFF1976D2),
                ),
              ],
            ),
          ),
        ),
        if (showFishingModeDropdown)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: FishingMode.values.map((mode) {
                return CheckboxListTile(
                  title: Text(mode.displayName),
                  value: selectedFishingModes.contains(mode),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        selectedFishingModes.add(mode);
                      } else {
                        selectedFishingModes.remove(mode);
                      }
                      selectedFishingMode = selectedFishingModes.isNotEmpty 
                          ? selectedFishingModes.first 
                          : FishingMode.spinning;
                    });
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildAdditionalBoatsSection() {
    final numFishermen = int.tryParse(numberOfFishermen) ?? 0;
    final additionalBoatsCount = numFishermen >= 5
        ? ((numFishermen - 5) ~/ 3) + 1
        : 0;

    if (additionalBoatsCount > 0) {
      return Card(
        color: const Color(0xFFE3F2FD),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🚤 Lanchas adicionales requeridas: $additionalBoatsCount',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Regla: A partir de 5 pescadores se requiere 1 lancha adicional, y cada 3 pescadores más se agrega otra lancha.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 12),
              ...additionalBoats.asMap().entries.map((entry) {
                final index = entry.key;
                final guideName = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildTextField(
                    label: '👨‍✈️ Nombre del guía - Lancha ${index + 1}',
                    value: guideName,
                    onChanged: (value) {
                      setState(() {
                        additionalBoats[index] = value;
                      });
                    },
                    icon: Icons.person,
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildServicesSection() {
    return Card(
      color: const Color(0xFFF5F5F5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🛠️ Servicios incluidos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 12),
            
            // Carnada
            _buildExpandableServiceItem(
              title: 'Carnada',
              emoji: '🪱',
              isIncluded: includesBait,
              onCheckedChange: (checked) => setState(() => includesBait = checked),
            ),
            
            // Equipos de pesca
            _buildExpandableServiceItem(
              title: 'Equipos de pesca',
              emoji: '🎣',
              isIncluded: equipmentRental,
              onCheckedChange: (checked) => setState(() => equipmentRental = checked),
              isExpanded: expandedEquipment,
              onToggleExpanded: () => setState(() => expandedEquipment = !expandedEquipment),
              expandedContent: _buildEquipmentDetailsSection(),
            ),
            
            // Hospedaje
            _buildExpandableServiceItem(
              title: 'Hospedaje',
              emoji: '🏠',
              isIncluded: includesAccommodation,
              onCheckedChange: (checked) => setState(() => includesAccommodation = checked),
              isExpanded: expandedAccommodation,
              onToggleExpanded: () => setState(() => expandedAccommodation = !expandedAccommodation),
              expandedContent: _buildAccommodationDetailsSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            label: '💰 Precio total (\$)',
            value: totalPrice,
            onChanged: (value) {
              // Solo permitir números
              final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
              setState(() => totalPrice = cleanValue);
            },
            icon: Icons.star,
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTextField(
            label: '💳 Seña (\$)',
            value: depositAmount,
            onChanged: (value) {
              // Solo permitir números
              final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
              setState(() => depositAmount = cleanValue);
            },
            icon: Icons.star,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceSection() {
    final totalPriceValue = double.tryParse(totalPrice) ?? 0.0;
    final depositAmountValue = double.tryParse(depositAmount) ?? 0.0;
    final remainingBalance = totalPriceValue - depositAmountValue;

    // Actualizar estado del pago automáticamente
    if (depositAmountValue >= totalPriceValue && totalPriceValue > 0) {
      paymentStatus = PaymentStatus.completed;
    } else if (depositAmountValue > 0) {
      paymentStatus = PaymentStatus.partial;
    } else {
      paymentStatus = PaymentStatus.pending;
    }

    return Card(
      color: remainingBalance > 0 ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: remainingBalance > 0 ? Color(0xFFFF5722) : Color(0xFF4CAF50),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Saldo pendiente',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                  ],
                ),
            Text(
                  '\$${NumberFormat('#,##0', 'es').format(remainingBalance)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: remainingBalance > 0 ? Color(0xFFFF5722) : Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
            if (remainingBalance > 0)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      depositAmount = totalPrice;
                      paymentStatus = PaymentStatus.completed;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('✅ Pagado'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancelar'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              try {
                // Validar campos requeridos
                if (clientName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor ingrese el nombre del cliente'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                if (selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor seleccione una fecha'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final booking = Booking(
                  date: selectedDate!,
                  clientName: clientName,
                  clientPhone: clientPhone,
                  clientLocation: clientLocation,
                  numberOfFishermen: int.tryParse(numberOfFishermen) ?? 0,
                  targetSpecies: selectedSpecies.toList(),
                  fishingMode: selectedFishingMode,
                  additionalBoats: additionalBoats,
                  includesBait: includesBait,
                  equipmentRental: equipmentRental,
                  includesAccommodation: includesAccommodation,
                  includesMeals: false,
                  fishingDays: int.tryParse(fishingDays) ?? 0,
                  accommodationNights: 0,
                  totalPrice: double.tryParse(totalPrice) ?? 0.0,
                  depositAmount: double.tryParse(depositAmount) ?? 0.0,
                  paymentStatus: paymentStatus,
                  notes: notes.isEmpty ? null : notes,
                  serviceDetails: serviceDetails,
                );
                
                // Guardar la contratación usando el callback
                widget.onSaveBooking(booking);
                
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al crear la contratación: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
            child: const Text('Guardar'),
          ),
        ),
      ],
    );
  }


  Widget _buildExpandableServiceItem({
    required String title,
    required String emoji,
    required bool isIncluded,
    required ValueChanged<bool> onCheckedChange,
    bool isExpanded = false,
    VoidCallback? onToggleExpanded,
    Widget? expandedContent,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: isIncluded,
              onChanged: (checked) {
                onCheckedChange(checked ?? false);
                // Si se marca el servicio y hay contenido expandible, expandir automáticamente
                if (checked == true && expandedContent != null && !isExpanded && onToggleExpanded != null) {
                  onToggleExpanded();
                }
              },
              activeColor: const Color(0xFF4CAF50),
            ),
            Expanded(
              child: Text(
                '$emoji $title',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isIncluded ? const Color(0xFF2E7D32) : const Color(0xFF424242),
                ),
              ),
            ),
            if (expandedContent != null)
              IconButton(
                onPressed: onToggleExpanded,
                icon: Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: const Color(0xFF1976D2),
                ),
              ),
          ],
        ),
        if (isExpanded && expandedContent != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: expandedContent,
          ),
      ],
    );
  }

  Widget _buildEquipmentDetailsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎣 Detalles de equipos',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 12),
          
          TextField(
            onChanged: (value) {
              final qty = int.tryParse(value) ?? 0;
              setState(() {
                serviceDetails = serviceDetails.copyWith(
                  equipment: serviceDetails.equipment.copyWith(quantity: qty),
                );
              });
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Cantidad de equipos',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              filled: true,
              fillColor: Colors.white,
            ),
            controller: TextEditingController(
              text: serviceDetails.equipment.quantity.toString(),
            ),
          ),
          const SizedBox(height: 16),
          
          Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: serviceDetails.equipment.forDoradoSurubi,
                    onChanged: (checked) {
                      setState(() {
                        serviceDetails = serviceDetails.copyWith(
                          equipment: serviceDetails.equipment.copyWith(
                            forDoradoSurubi: checked ?? false,
                          ),
                        );
                      });
                    },
                    activeColor: const Color(0xFF4CAF50),
                  ),
                  const Expanded(
                    child: Text(
                      'Dorado y Surubí',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: serviceDetails.equipment.forBogaVariada,
                    onChanged: (checked) {
                      setState(() {
                        serviceDetails = serviceDetails.copyWith(
                          equipment: serviceDetails.equipment.copyWith(
                            forBogaVariada: checked ?? false,
                          ),
                        );
                      });
                    },
                    activeColor: const Color(0xFF4CAF50),
                  ),
                  const Expanded(
                    child: Text(
                      'Boga y Variada',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccommodationDetailsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF1976D2).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🏠 Detalles de hospedaje',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 12),
          
          TextField(
            onChanged: (value) {
              final nights = int.tryParse(value) ?? 0;
              setState(() {
                serviceDetails = serviceDetails.copyWith(
                  accommodation: serviceDetails.accommodation.copyWith(nights: nights),
                );
              });
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Cantidad de noches',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              filled: true,
              fillColor: Colors.white,
            ),
            controller: TextEditingController(
              text: serviceDetails.accommodation.nights.toString(),
            ),
          ),
          const SizedBox(height: 16),
          
          Column(
            children: [
              _buildMealOption(
                title: 'Desayuno',
                emoji: '🌅',
                isIncluded: serviceDetails.accommodation.includesBreakfast,
                onCheckedChange: (checked) {
                  setState(() {
                    serviceDetails = serviceDetails.copyWith(
                      accommodation: serviceDetails.accommodation.copyWith(
                        includesBreakfast: checked,
                      ),
                    );
                  });
                },
              ),
              _buildMealOption(
                title: 'Almuerzo',
                emoji: '🌞',
                isIncluded: serviceDetails.accommodation.includesLunch,
                onCheckedChange: (checked) {
                  setState(() {
                    serviceDetails = serviceDetails.copyWith(
                      accommodation: serviceDetails.accommodation.copyWith(
                        includesLunch: checked,
                      ),
                    );
                  });
                },
              ),
              _buildMealOption(
                title: 'Cena',
                emoji: '🌙',
                isIncluded: serviceDetails.accommodation.includesDinner,
                onCheckedChange: (checked) {
                  setState(() {
                    serviceDetails = serviceDetails.copyWith(
                      accommodation: serviceDetails.accommodation.copyWith(
                        includesDinner: checked,
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealOption({
    required String title,
    required String emoji,
    required bool isIncluded,
    required ValueChanged<bool> onCheckedChange,
  }) {
    return Row(
      children: [
        Checkbox(
          value: isIncluded,
          onChanged: (checked) => onCheckedChange(checked ?? false),
          activeColor: const Color(0xFF4CAF50),
        ),
        Text(
          '$emoji $title',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF424242),
          ),
        ),
      ],
    );
  }
}

class PantallaServiciosGuia extends StatefulWidget {
  const PantallaServiciosGuia({super.key});

  @override
  State<PantallaServiciosGuia> createState() => _PantallaServiciosGuiaState();
}

class _PantallaServiciosGuiaState extends State<PantallaServiciosGuia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text(
          'Servicios de Guías de Pesca',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con información principal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2E7D32),
                    Color(0xFF4CAF50),
                    Color(0xFF66BB6A),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.directions_boat,
                        color: Colors.white,
                        size: 32,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Guías Profesionales de Pesca',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Servicios especializados en pesca deportiva con guías experimentados en las mejores aguas de la región.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Servicios disponibles
            const Text(
              'Servicios Disponibles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Lista de servicios
            _buildServicioCard(
              icon: Icons.set_meal,
              title: 'Pesca de Dorado',
              description: 'Experiencia de pesca de dorado en aguas profundas con guías especializados.',
              price: 'Desde \$15,000',
            ),
            
            _buildServicioCard(
              icon: Icons.waves,
              title: 'Pesca de Surubí',
              description: 'Técnicas especializadas para la captura de surubí en ríos y arroyos.',
              price: 'Desde \$12,000',
            ),
            
            _buildServicioCard(
              icon: Icons.directions_boat,
              title: 'Pesca en Embarcación',
              description: 'Salidas en embarcaciones equipadas con todo el equipo necesario.',
              price: 'Desde \$8,000',
            ),
            
            _buildServicioCard(
              icon: Icons.beach_access,
              title: 'Pesca Costera',
              description: 'Pesca desde la costa con técnicas tradicionales y modernas.',
              price: 'Desde \$5,000',
            ),
            
            _buildServicioCard(
              icon: Icons.nightlight_round,
              title: 'Pesca Nocturna',
              description: 'Experiencia única de pesca nocturna con equipos especializados.',
              price: 'Desde \$10,000',
            ),
            
            _buildServicioCard(
              icon: Icons.school,
              title: 'Clases de Pesca',
              description: 'Aprende técnicas de pesca con instructores certificados.',
              price: 'Desde \$3,000',
            ),
            
            const SizedBox(height: 24),
            
            // Información de contacto
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Color(0xFF4CAF50)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.contact_phone,
                        color: Color(0xFF2E7D32),
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Información de Contacto',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '📞 Teléfono: +54 9 343 123-4567',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '📧 Email: guias@pesca.com',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '📍 Ubicación: Paraná, Entre Ríos',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Aquí se podría agregar funcionalidad de contacto
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Funcionalidad de contacto próximamente'),
                            backgroundColor: Color(0xFF4CAF50),
                          ),
                        );
                      },
                      icon: const Icon(Icons.call),
                      label: const Text('Contactar Guía'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicioCard({
    required IconData icon,
    required String title,
    required String description,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2E7D32),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
