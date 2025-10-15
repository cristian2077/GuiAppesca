import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'widgets/calendar_widget.dart';
import 'screens/hospedaje_screen.dart';
import 'screens/foto_completa_screen.dart';

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
                      
                      const SizedBox(height: 20),
                      
                      // Widget de servicios de hospedaje
                      _buildServiciosHospedajeWidget(context),
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
                        child: Text(
                          'Hoy - ${DateFormat('d \'de\' MMMM', 'es').format(DateTime.now())}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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

  Widget _buildServiciosHospedajeWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PantallaServiciosHospedaje()),
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
                Color(0xFF1976D2), // Azul oscuro
                Color(0xFF2196F3), // Azul medio
                Color(0xFF64B5F6), // Azul claro
                Color(0xFF1565C0), // Azul profundo
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
                color: Color(0xFF2196F3).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Color(0xFF2196F3).withOpacity(0.2),
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
                        'Servicios de Hospedaje',
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
                      Icons.hotel,
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
  bool _cargando = true;
  String _ubicacion = 'Obteniendo ubicación...';
  String _error = '';
  
  // Datos de ejemplo para 10 días
  List<Map<String, dynamic>> pronostico10Dias = [
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
  void initState() {
    super.initState();
    _obtenerUbicacionYClima();
  }

  Future<void> _obtenerUbicacionYClima() async {
    try {
    setState(() {
        _cargando = true;
        _error = '';
      });

      // Solicitar permisos de ubicación
      var permiso = await Permission.location.request();
      
      if (!permiso.isGranted) {
        setState(() {
          _error = 'Se necesita permiso de ubicación para obtener el clima';
          _cargando = false;
        });
        return;
      }

      // Obtener posición actual
      Position posicion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Obtener nombre de la ubicación
      List<Placemark> placemarks = await placemarkFromCoordinates(
        posicion.latitude,
        posicion.longitude,
      );
      
      String ciudad = placemarks.first.locality ?? 'Ubicación actual';
      String pais = placemarks.first.country ?? '';

      setState(() {
        _ubicacion = '$ciudad, $pais';
      });

      // Obtener datos del clima desde Open-Meteo (API gratuita)
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?'
        'latitude=${posicion.latitude}'
        '&longitude=${posicion.longitude}'
        '&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max,windspeed_10m_max,weathercode'
        '&timezone=auto'
        '&forecast_days=10'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final datos = json.decode(response.body);
        final daily = datos['daily'];
        
        // Actualizar pronóstico con datos reales
        List<Map<String, dynamic>> nuevoPronostico = [];
        
        for (int i = 0; i < 10; i++) {
          DateTime fecha = DateTime.parse(daily['time'][i]);
          String dia = i == 0 ? 'Hoy' : i == 1 ? 'Mañana' : _obtenerNombreDia(fecha.weekday);
          String fechaStr = DateFormat('d MMM', 'es').format(fecha);
          
          int tempMax = daily['temperature_2m_max'][i].round();
          int tempMin = daily['temperature_2m_min'][i].round();
          int weatherCode = daily['weathercode'][i];
          int precipitacion = daily['precipitation_probability_max'][i];
          int viento = daily['windspeed_10m_max'][i].round();
          
          // Interpretar código del clima
          Map<String, dynamic> climaInfo = _interpretarCodigoClima(weatherCode);
          
          nuevoPronostico.add({
            'dia': dia,
            'fecha': fechaStr,
            'tempMax': tempMax,
            'tempMin': tempMin,
            'estado': climaInfo['estado'],
            'icono': climaInfo['icono'],
            'humedad': 60 + (precipitacion ~/ 3), // Estimación
            'viento': viento,
            'precipitacion': precipitacion,
          });
        }
        
        setState(() {
          pronostico10Dias = nuevoPronostico;
          _cargando = false;
        });
      } else {
        throw Exception('Error al obtener datos del clima');
      }
    } catch (e) {
      setState(() {
        _error = 'Error al obtener el clima: ${e.toString()}';
        _cargando = false;
      });
    }
  }

  String _obtenerNombreDia(int weekday) {
    const dias = ['Lun', 'Mar', 'Miér', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return dias[weekday - 1];
  }

  Map<String, dynamic> _interpretarCodigoClima(int code) {
    // Códigos WMO Weather interpretation codes
    if (code == 0) {
      return {'estado': 'Despejado', 'icono': Icons.wb_sunny};
    } else if (code <= 3) {
      return {'estado': 'Parcialmente nublado', 'icono': Icons.wb_cloudy};
    } else if (code <= 48) {
      return {'estado': 'Nublado', 'icono': Icons.cloud};
    } else if (code <= 67) {
      return {'estado': 'Lluvioso', 'icono': Icons.water_drop};
    } else if (code <= 77) {
      return {'estado': 'Nieve', 'icono': Icons.ac_unit};
    } else if (code <= 82) {
      return {'estado': 'Lluvia intensa', 'icono': Icons.water_drop};
    } else if (code <= 86) {
      return {'estado': 'Nieve intensa', 'icono': Icons.ac_unit};
    } else {
      return {'estado': 'Tormenta', 'icono': Icons.flash_on};
    }
  }

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
                        child: _cargando 
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
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
                            Text(
                              _ubicacion,
                              style: const TextStyle(
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
                            Text(
                              _error.isEmpty 
                                ? (_cargando ? 'Cargando clima...' : 'Actualizado ahora')
                                : _error,
                              style: TextStyle(
                                fontSize: 14,
                                color: _error.isEmpty ? Colors.white70 : Colors.redAccent,
                                shadows: const [
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

  // Expandir fechas de contrataciones para marcar todos los días en el calendario
  List<DateTime> _expandBookingDates(List<Booking> bookings) {
    List<DateTime> allDates = [];
    
    for (var booking in bookings) {
      // Agregar el día inicial
      allDates.add(booking.date);
      
      // Agregar los días adicionales según fishingDays
      for (int i = 1; i < booking.fishingDays; i++) {
        allDates.add(booking.date.add(Duration(days: i)));
      }
    }
    
    return allDates;
  }

  // Mostrar contrataciones de una fecha específica
  void _showDateBookings(DateTime selectedDate) {
    // Buscar contrataciones que incluyan la fecha seleccionada
    final dayBookings = bookings.where((booking) {
      final startDate = booking.date;
      final endDate = booking.date.add(Duration(days: booking.fishingDays - 1));
      
      // Verificar si selectedDate está dentro del rango de la contratación
      return selectedDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
             selectedDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

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
                  bookedDates: _expandBookingDates(bookings),
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
              
              // Estado de pago y botones de acción
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Botón Editar
                      GestureDetector(
                        onTap: () => _editBooking(booking, index),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2196F3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Botón Eliminar
                      GestureDetector(
                        onTap: () => _confirmDeleteBooking(booking, index),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF44336),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Botón Compartir
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

  // Compartir contratación por WhatsApp, Email, etc.
  Future<void> _shareBooking(Booking booking) async {
    // Calcular fecha de finalización
    final fechaInicio = DateFormat('dd/MM/yyyy').format(booking.date);
    final fechaFin = DateFormat('dd/MM/yyyy').format(
      booking.date.add(Duration(days: booking.fishingDays - 1))
    );
    
    final String shareText = '''
🎣 CONTRATACIÓN DE PESCA - GuiAppesca

━━━━━━━━━━━━━━━━━━━━━━
📋 DATOS DEL CLIENTE
━━━━━━━━━━━━━━━━━━━━━━
👤 Nombre: ${booking.clientName}
📞 Teléfono: ${booking.clientPhone}
📍 Ubicación: ${booking.clientLocation}

━━━━━━━━━━━━━━━━━━━━━━
📅 DETALLES DE LA PESCA
━━━━━━━━━━━━━━━━━━━━━━
📆 Fecha Inicio: $fechaInicio
📆 Fecha Fin: $fechaFin
🗓️ Días de Pesca: ${booking.fishingDays} ${booking.fishingDays == 1 ? 'día' : 'días'}
👥 Cantidad de Pescadores: ${booking.numberOfFishermen}
🐟 Especies Objetivo: ${booking.targetSpecies.join(', ')}
🎣 Modalidad: ${booking.fishingMode.displayName}

━━━━━━━━━━━━━━━━━━━━━━
📦 SERVICIOS INCLUIDOS
━━━━━━━━━━━━━━━━━━━━━━
${booking.additionalBoats.isNotEmpty ? '⛵ Embarcaciones Adicionales: ${booking.additionalBoats.join(', ')}\n' : ''}${booking.includesBait ? '🪱 Carnada: Incluida\n' : ''}${booking.equipmentRental ? '🎣 Alquiler de Equipo: Incluido\n' : ''}${booking.includesAccommodation ? '🏠 Alojamiento: ${booking.accommodationNights} ${booking.accommodationNights == 1 ? 'noche' : 'noches'}\n' : ''}${booking.includesMeals ? '🍽️ Comidas: Incluidas\n' : ''}
━━━━━━━━━━━━━━━━━━━━━━
💰 INFORMACIÓN DE PAGO
━━━━━━━━━━━━━━━━━━━━━━
💵 Precio Total: \$${NumberFormat('#,##0', 'es').format(booking.totalPrice)}
💳 Seña Abonada: \$${NumberFormat('#,##0', 'es').format(booking.depositAmount)}
💰 Saldo Restante: \$${NumberFormat('#,##0', 'es').format(booking.totalPrice - booking.depositAmount)}
✅ Estado del Pago: ${booking.paymentStatus.displayName}
${booking.notes != null && booking.notes!.isNotEmpty ? '\n━━━━━━━━━━━━━━━━━━━━━━\n📝 NOTAS ADICIONALES\n━━━━━━━━━━━━━━━━━━━━━━\n${booking.notes}\n' : ''}
━━━━━━━━━━━━━━━━━━━━━━

📱 Generado por GuiAppesca
🎣 Tu guía de pesca digital

━━━━━━━━━━━━━━━━━━━━━━
✍️ Comprobante de acuerdos con el guía de pesca
━━━━━━━━━━━━━━━━━━━━━━
''';

    try {
      // Compartir usando share_plus
      await Share.share(
        shareText,
        subject: '🎣 Contratación de Pesca - ${booking.clientName}',
      );

      // Mostrar mensaje de confirmación
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Compartir contratación'),
            backgroundColor: Color(0xFF4CAF50),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al compartir: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Método para editar una contratación
  void _editBooking(Booking booking, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaEditarContratacion(
          booking: booking,
          onUpdateBooking: (updatedBooking) async {
            final bookings = await BookingStorage.loadBookings();
            bookings[index] = updatedBooking;
            await BookingStorage.saveBookings(bookings);
            setState(() {});
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Contratación actualizada exitosamente'),
                backgroundColor: Color(0xFF4CAF50),
                duration: Duration(seconds: 2),
              ),
            );
          },
          existingBookings: [],
        ),
      ),
    );
  }

  // Método para confirmar eliminación
  void _confirmDeleteBooking(Booking booking, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFF44336),
                size: 28,
              ),
              SizedBox(width: 8),
              Text(
                'Confirmar Eliminación',
                style: TextStyle(
                  color: Color(0xFFF44336),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¿Estás seguro de que deseas eliminar esta contratación?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFFB74D)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '👤 ${booking.clientName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '📅 ${DateFormat('dd/MM/yyyy').format(booking.date)}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '⚠️ Esta acción no se puede deshacer.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFF44336),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar diálogo
                
                // Eliminar la contratación
                await BookingStorage.removeBooking(index);
                setState(() {});
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🗑️ Contratación eliminada'),
                    backgroundColor: Color(0xFFF44336),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF44336),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text(
                'Eliminar',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Clase para editar contrataciones existentes
class PantallaEditarContratacion extends StatefulWidget {
  final Booking booking;
  final Function(Booking) onUpdateBooking;
  final List<Booking> existingBookings;

  const PantallaEditarContratacion({
    super.key,
    required this.booking,
    required this.onUpdateBooking,
    this.existingBookings = const [],
  });

  @override
  State<PantallaEditarContratacion> createState() => _PantallaEditarContratacionState();
}

class _PantallaEditarContratacionState extends State<PantallaEditarContratacion> {
  // Estados para el formulario (inicializados con los datos del booking)
  late DateTime selectedDate;
  bool hasSelectedDate = true;
  late String clientName;
  late String clientPhone;
  late String clientLocation;
  late String numberOfFishermen;
  String targetSpecies = '';
  late Set<String> selectedSpecies;
  late FishingMode selectedFishingMode;
  Set<FishingMode> selectedFishingModes = {};
  late List<String> additionalBoats;
  late bool includesBait;
  late bool equipmentRental;
  late bool includesAccommodation;
  late String fishingDays;
  late String totalPrice;
  late String depositAmount;
  late String notes;
  late PaymentStatus paymentStatus;
  ServiceDetails serviceDetails = ServiceDetails();
  
  bool showSpeciesDropdown = false;
  bool showFishingModeDropdown = false;
  bool expandedServices = false;
  bool expandedEquipment = false;
  bool expandedAccommodation = false;

  @override
  void initState() {
    super.initState();
    // Inicializar con los datos del booking existente
    selectedDate = widget.booking.date;
    clientName = widget.booking.clientName;
    clientPhone = widget.booking.clientPhone;
    clientLocation = widget.booking.clientLocation;
    numberOfFishermen = widget.booking.numberOfFishermen.toString();
    selectedSpecies = widget.booking.targetSpecies.toSet();
    selectedFishingMode = widget.booking.fishingMode;
    additionalBoats = List<String>.from(widget.booking.additionalBoats);
    includesBait = widget.booking.includesBait;
    equipmentRental = widget.booking.equipmentRental;
    includesAccommodation = widget.booking.includesAccommodation;
    fishingDays = widget.booking.fishingDays.toString();
    totalPrice = widget.booking.totalPrice.toString();
    depositAmount = widget.booking.depositAmount.toString();
    notes = widget.booking.notes ?? '';
    paymentStatus = widget.booking.paymentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Contratación',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFBBDEFB),
              Color(0xFF64B5F6),
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
                    const Text(
                      '✏️ Editar Contratación',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    _buildTextField(
                      label: '👤 Nombre del cliente',
                      value: clientName,
                      onChanged: (value) => setState(() => clientName = value),
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: '📞 Teléfono',
                      value: clientPhone,
                      onChanged: (value) => setState(() => clientPhone = value),
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: '📍 Localidad del cliente',
                      value: clientLocation,
                      onChanged: (value) => setState(() => clientLocation = value),
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: '🎣 Días de pesca',
                      value: fishingDays,
                      onChanged: (value) => setState(() => fishingDays = value),
                      icon: Icons.settings,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: '👥 Número de pescadores',
                      value: numberOfFishermen,
                      onChanged: (value) => setState(() => numberOfFishermen = value),
                      icon: Icons.person,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: '💰 Precio total',
                      value: totalPrice,
                      onChanged: (value) => setState(() => totalPrice = value),
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: '💳 Seña/Anticipo',
                      value: depositAmount,
                      onChanged: (value) => setState(() => depositAmount = value),
                      icon: Icons.payment,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    
                    // Estado de pago
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '💳 Estado del pago',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2196F3),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...PaymentStatus.values.map((status) {
                            return RadioListTile<PaymentStatus>(
                              title: Text(status.displayName),
                              value: status,
                              groupValue: paymentStatus,
                              onChanged: (value) {
                                setState(() => paymentStatus = value!);
                              },
                              activeColor: const Color(0xFF2196F3),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildTextField(
                      label: '📝 Notas adicionales (opcional)',
                      value: notes,
                      onChanged: (value) => setState(() => notes = value),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    
                    // Botones
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2196F3),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Guardar Cambios',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
    IconData? icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: TextEditingController(text: value)..selection = TextSelection.fromPosition(TextPosition(offset: value.length)),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }

  void _saveChanges() {
    if (clientName.isEmpty || clientPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa los campos obligatorios'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final updatedBooking = Booking(
      date: selectedDate,
      clientName: clientName,
      clientPhone: clientPhone,
      clientLocation: clientLocation,
      numberOfFishermen: int.tryParse(numberOfFishermen) ?? 1,
      targetSpecies: selectedSpecies.toList(),
      fishingMode: selectedFishingMode,
      additionalBoats: additionalBoats,
      includesBait: includesBait,
      equipmentRental: equipmentRental,
      includesAccommodation: includesAccommodation,
      includesMeals: false,
      fishingDays: int.tryParse(fishingDays) ?? 1,
      accommodationNights: 0,
      totalPrice: double.tryParse(totalPrice) ?? 0.0,
      depositAmount: double.tryParse(depositAmount) ?? 0.0,
      paymentStatus: paymentStatus,
      notes: notes.isEmpty ? null : notes,
      serviceDetails: serviceDetails,
    );

    widget.onUpdateBooking(updatedBooking);
    Navigator.pop(context);
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
  List<GuiaPesca> guias = []; // Lista de guías cargados
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarGuias();
  }

  Future<void> _cargarGuias() async {
    try {
      final loadedGuias = await GuiasStorage.loadGuias();
      if (mounted) {
        setState(() {
          guias = loadedGuias;
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
            content: Text('Error al cargar guías: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botón para agregar nuevo guía
            ElevatedButton.icon(
              onPressed: () {
                // Navegar a pantalla para agregar guía
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PantallaAgregarGuia(
                      onGuardado: (guia) async {
                        try {
                          await GuiasStorage.addGuia(guia);
                          await _cargarGuias();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Guía guardado exitosamente'),
                                backgroundColor: Color(0xFF4CAF50),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('❌ Error al guardar: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 24),
              label: const Text(
                'Agregar Nuevo Guía',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Lista de guías
            Expanded(
              child: guias.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_boat,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay guías agregados',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Toca el botón "Agregar Nuevo Guía" para comenzar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: guias.length,
                      itemBuilder: (context, index) {
                        return _buildGuiaCard(guias[index], index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuiaCard(GuiaPesca guia, int index) {
    return FutureBuilder<String>(
      future: GuiasStorage.getDeviceId(),
      builder: (context, snapshot) {
        final currentDeviceId = snapshot.data ?? '';
        final isCreator = currentDeviceId == guia.creadorId;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              // Ver pantalla individual del guía al tocar cualquier parte
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaDetalleGuia(
                    guia: guia,
                    guiaIndex: index,
                    onGuiaUpdated: () => _cargarGuias(),
                  ),
                ),
              );
            },
            child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: CircleAvatar(
          radius: 30,
          backgroundColor: const Color(0xFF4CAF50),
          child: guia.logoUrl != null && guia.logoUrl!.isNotEmpty
              ? ClipOval(
                  child: guia.logoUrl!.startsWith('http')
                      ? Image.network(
                          guia.logoUrl!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, size: 30, color: Colors.white);
                          },
                        )
                      : Image.file(
                          File(guia.logoUrl!),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, size: 30, color: Colors.white);
                          },
                        ),
                )
              : const Icon(Icons.person, size: 30, color: Colors.white),
        ),
        title: Text(
          guia.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          guia.telefono,
          style: const TextStyle(fontSize: 14),
        ),
        trailing: isCreator ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFFFF9800)),
              onPressed: () {
                // Editar guía
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PantallaEditarGuia(
                      guia: guia,
                      guiaIndex: index,
                      onGuardado: (guiaActualizado) async {
                        try {
                          await GuiasStorage.updateGuia(index, guiaActualizado);
                          await _cargarGuias();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Guía actualizado exitosamente'),
                                backgroundColor: Color(0xFF4CAF50),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('❌ Error al actualizar: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Confirmar eliminación
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Eliminar Guía'),
                    content: Text('¿Estás seguro de eliminar a ${guia.nombre}?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await GuiasStorage.removeGuia(index);
                            await _cargarGuias();
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('🗑️ Guía eliminado'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('❌ Error al eliminar: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Eliminar',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ) : null, // Si no es creador, no mostrar botones
        ),
      ),
        );
      },
    );
  }
}

// Modelo de datos para GuiaPesca
class GuiaPesca {
  final String nombre;
  final String telefono;
  final String? email;
  final String? logoUrl;
  final String? facebook;
  final String? instagram;
  final String? whatsapp;
  final String? tiktok;
  final List<String> fotos; // Lista de rutas de fotos
  final String? descripcion;
  final String creadorId; // ID del dispositivo que creó el guía

  GuiaPesca({
    required this.nombre,
    required this.telefono,
    this.email,
    this.logoUrl,
    this.facebook,
    this.instagram,
    this.whatsapp,
    this.tiktok,
    List<String>? fotos,
    this.descripcion,
    required this.creadorId,
  }) : fotos = fotos ?? [];

  // Convertir GuiaPesca a Map para JSON
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
      'logoUrl': logoUrl,
      'facebook': facebook,
      'instagram': instagram,
      'whatsapp': whatsapp,
      'tiktok': tiktok,
      'fotos': fotos,
      'descripcion': descripcion,
      'creadorId': creadorId,
    };
  }

  // Crear GuiaPesca desde Map
  factory GuiaPesca.fromJson(Map<String, dynamic> json) {
    return GuiaPesca(
      nombre: json['nombre'],
      telefono: json['telefono'],
      email: json['email'],
      logoUrl: json['logoUrl'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      whatsapp: json['whatsapp'],
      tiktok: json['tiktok'],
      fotos: json['fotos'] != null ? List<String>.from(json['fotos']) : [],
      descripcion: json['descripcion'],
      creadorId: json['creadorId'] ?? '',
    );
  }
}

// Servicio para manejar la persistencia de guías
class GuiasStorage {
  static const String _guiasKey = 'saved_guias';
  static const String _deviceIdKey = 'device_id';

  // Obtener o crear ID único del dispositivo
  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);
    
    if (deviceId == null) {
      // Generar ID único basado en timestamp y random
      deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
      await prefs.setString(_deviceIdKey, deviceId);
    }
    
    return deviceId;
  }

  // Guardar lista de guías
  static Future<void> saveGuias(List<GuiaPesca> guias) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> guiasJson = guias.map((guia) => json.encode(guia.toJson())).toList();
      await prefs.setStringList(_guiasKey, guiasJson);
    } catch (e) {
      rethrow;
    }
  }

  // Cargar lista de guías
  static Future<List<GuiaPesca>> loadGuias() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? guiasJson = prefs.getStringList(_guiasKey);
    
    if (guiasJson == null) {
      return [];
    }
    
    try {
      return guiasJson.map((jsonString) {
        final Map<String, dynamic> guiaMap = json.decode(jsonString);
        return GuiaPesca.fromJson(guiaMap);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Agregar un nuevo guía
  static Future<void> addGuia(GuiaPesca guia) async {
    try {
      final guias = await loadGuias();
      guias.add(guia);
      await saveGuias(guias);
    } catch (e) {
      rethrow;
    }
  }

  // Actualizar un guía
  static Future<void> updateGuia(int index, GuiaPesca guia) async {
    try {
      final guias = await loadGuias();
      if (index >= 0 && index < guias.length) {
        guias[index] = guia;
        await saveGuias(guias);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Eliminar un guía
  static Future<void> removeGuia(int index) async {
    final guias = await loadGuias();
    if (index >= 0 && index < guias.length) {
      guias.removeAt(index);
      await saveGuias(guias);
    }
  }
}

// Pantalla para agregar un nuevo guía
class PantallaAgregarGuia extends StatefulWidget {
  final Function(GuiaPesca) onGuardado;

  const PantallaAgregarGuia({
    super.key,
    required this.onGuardado,
  });

  @override
  State<PantallaAgregarGuia> createState() => _PantallaAgregarGuiaState();
}

class _PantallaAgregarGuiaState extends State<PantallaAgregarGuia> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _tiktokController = TextEditingController();
  final _descripcionController = TextEditingController();
  
  String? _logoImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _whatsappController.dispose();
    _tiktokController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarLogo() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _logoImagePath = image.path;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Logo seleccionado'),
              backgroundColor: Color(0xFF4CAF50),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al seleccionar imagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _guardarGuia() async {
    if (_formKey.currentState!.validate()) {
      final deviceId = await GuiasStorage.getDeviceId();
      
      final guia = GuiaPesca(
        nombre: _nombreController.text,
        telefono: _telefonoController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
        logoUrl: _logoImagePath,
        facebook: _facebookController.text.isEmpty ? null : _facebookController.text,
        instagram: _instagramController.text.isEmpty ? null : _instagramController.text,
        whatsapp: _whatsappController.text.isEmpty ? null : _whatsappController.text,
        tiktok: _tiktokController.text.isEmpty ? null : _tiktokController.text,
        descripcion: _descripcionController.text.isEmpty ? null : _descripcionController.text,
        creadorId: deviceId,
      );

      widget.onGuardado(guia);
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Guía agregado exitosamente'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar Nuevo Guía',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nombre
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Guía *',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Teléfono
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono *',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el teléfono';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (opcional)',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              
              // Selector de Logo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Logo del Guía',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    if (_logoImagePath != null)
                      Center(
                        child: Stack(
                          children: [
                            ClipOval(
                              child: Image.file(
                                File(_logoImagePath!),
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.all(4),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _logoImagePath = null;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 12),
                    
                    ElevatedButton.icon(
                      onPressed: _seleccionarLogo,
                      icon: const Icon(Icons.photo_library),
                      label: Text(_logoImagePath == null ? 'Seleccionar Logo' : 'Cambiar Logo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Facebook
              TextFormField(
                controller: _facebookController,
                decoration: const InputDecoration(
                  labelText: 'Facebook (opcional)',
                  hintText: 'https://facebook.com/tu_pagina',
                  prefixIcon: Icon(Icons.facebook),
                  border: OutlineInputBorder(),
                  helperText: 'Enlace completo o @usuario',
                  helperMaxLines: 1,
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              
              // Instagram
              TextFormField(
                controller: _instagramController,
                decoration: const InputDecoration(
                  labelText: 'Instagram (opcional)',
                  hintText: 'https://instagram.com/tu_perfil',
                  prefixIcon: Icon(Icons.camera_alt),
                  border: OutlineInputBorder(),
                  helperText: 'Enlace completo o @usuario',
                  helperMaxLines: 1,
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              
              // WhatsApp
              TextFormField(
                controller: _whatsappController,
                decoration: const InputDecoration(
                  labelText: 'WhatsApp (opcional)',
                  hintText: '+54 9 11 1234-5678',
                  prefixIcon: Icon(Icons.chat),
                  border: OutlineInputBorder(),
                  helperText: 'Número con código de país',
                  helperMaxLines: 1,
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              
              // TikTok
              TextFormField(
                controller: _tiktokController,
                decoration: const InputDecoration(
                  labelText: 'TikTok (opcional)',
                  hintText: 'https://tiktok.com/@tu_usuario',
                  prefixIcon: Icon(Icons.video_library),
                  border: OutlineInputBorder(),
                  helperText: 'Enlace completo o @usuario',
                  helperMaxLines: 1,
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              
              // Descripción
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              
              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _guardarGuia,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Guardar'),
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
}

// Pantalla para editar un guía existente
class PantallaEditarGuia extends StatefulWidget {
  final GuiaPesca guia;
  final int guiaIndex;
  final Function(GuiaPesca) onGuardado;

  const PantallaEditarGuia({
    super.key,
    required this.guia,
    required this.guiaIndex,
    required this.onGuardado,
  });

  @override
  State<PantallaEditarGuia> createState() => _PantallaEditarGuiaState();
}

class _PantallaEditarGuiaState extends State<PantallaEditarGuia> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _telefonoController;
  late TextEditingController _emailController;
  late TextEditingController _facebookController;
  late TextEditingController _instagramController;
  late TextEditingController _whatsappController;
  late TextEditingController _tiktokController;
  late TextEditingController _descripcionController;
  
  String? _logoImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.guia.nombre);
    _telefonoController = TextEditingController(text: widget.guia.telefono);
    _emailController = TextEditingController(text: widget.guia.email ?? '');
    _facebookController = TextEditingController(text: widget.guia.facebook ?? '');
    _instagramController = TextEditingController(text: widget.guia.instagram ?? '');
    _whatsappController = TextEditingController(text: widget.guia.whatsapp ?? '');
    _tiktokController = TextEditingController(text: widget.guia.tiktok ?? '');
    _descripcionController = TextEditingController(text: widget.guia.descripcion ?? '');
    _logoImagePath = widget.guia.logoUrl;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _whatsappController.dispose();
    _tiktokController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarLogo() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _logoImagePath = image.path;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Logo seleccionado'),
              backgroundColor: Color(0xFF4CAF50),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al seleccionar imagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _guardarGuia() {
    if (_formKey.currentState!.validate()) {
      final guia = GuiaPesca(
        nombre: _nombreController.text,
        telefono: _telefonoController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
        logoUrl: _logoImagePath,
        facebook: _facebookController.text.isEmpty ? null : _facebookController.text,
        instagram: _instagramController.text.isEmpty ? null : _instagramController.text,
        whatsapp: _whatsappController.text.isEmpty ? null : _whatsappController.text,
        tiktok: _tiktokController.text.isEmpty ? null : _tiktokController.text,
        descripcion: _descripcionController.text.isEmpty ? null : _descripcionController.text,
        fotos: widget.guia.fotos, // Mantener las fotos existentes
        creadorId: widget.guia.creadorId, // Mantener el creador original
      );

      widget.onGuardado(guia);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Guía',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nombre
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Guía *',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Teléfono
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono *',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el teléfono';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (opcional)',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              
              // Selector de Logo (versión compacta)
              ElevatedButton.icon(
                onPressed: _seleccionarLogo,
                icon: const Icon(Icons.photo_library),
                label: Text(_logoImagePath == null ? 'Seleccionar Logo' : 'Cambiar Logo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              
              // Facebook
              TextFormField(
                controller: _facebookController,
                decoration: const InputDecoration(
                  labelText: 'Facebook (opcional)',
                  hintText: 'https://facebook.com/tu_pagina',
                  prefixIcon: Icon(Icons.facebook),
                  border: OutlineInputBorder(),
                  helperText: 'Enlace completo o @usuario',
                  helperMaxLines: 1,
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              
              // Instagram
              TextFormField(
                controller: _instagramController,
                decoration: const InputDecoration(
                  labelText: 'Instagram (opcional)',
                  hintText: 'https://instagram.com/tu_perfil',
                  prefixIcon: Icon(Icons.camera_alt),
                  border: OutlineInputBorder(),
                  helperText: 'Enlace completo o @usuario',
                  helperMaxLines: 1,
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              
              // WhatsApp
              TextFormField(
                controller: _whatsappController,
                decoration: const InputDecoration(
                  labelText: 'WhatsApp (opcional)',
                  hintText: '+54 9 11 1234-5678',
                  prefixIcon: Icon(Icons.chat),
                  border: OutlineInputBorder(),
                  helperText: 'Número con código de país',
                  helperMaxLines: 1,
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              
              // TikTok
              TextFormField(
                controller: _tiktokController,
                decoration: const InputDecoration(
                  labelText: 'TikTok (opcional)',
                  hintText: 'https://tiktok.com/@tu_usuario',
                  prefixIcon: Icon(Icons.video_library),
                  border: OutlineInputBorder(),
                  helperText: 'Enlace completo o @usuario',
                  helperMaxLines: 1,
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              
              // Descripción
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              
              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _guardarGuia,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Guardar Cambios'),
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
}

// Pantalla de detalles individual del guía
class PantallaDetalleGuia extends StatefulWidget {
  final GuiaPesca guia;
  final int guiaIndex;
  final VoidCallback onGuiaUpdated;

  const PantallaDetalleGuia({
    super.key,
    required this.guia,
    required this.guiaIndex,
    required this.onGuiaUpdated,
  });

  @override
  State<PantallaDetalleGuia> createState() => _PantallaDetalleGuiaState();
}

class _PantallaDetalleGuiaState extends State<PantallaDetalleGuia> {
  late List<String> fotos;

  @override
  void initState() {
    super.initState();
    fotos = List.from(widget.guia.fotos);
  }

  Future<void> _agregarFoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          fotos.add(image.path);
        });
        
        // Guardar cambios en el almacenamiento
        final guiaActualizado = GuiaPesca(
          nombre: widget.guia.nombre,
          telefono: widget.guia.telefono,
          email: widget.guia.email,
          logoUrl: widget.guia.logoUrl,
          facebook: widget.guia.facebook,
          instagram: widget.guia.instagram,
          whatsapp: widget.guia.whatsapp,
          tiktok: widget.guia.tiktok,
          descripcion: widget.guia.descripcion,
          fotos: fotos,
          creadorId: widget.guia.creadorId,
        );
        
        await GuiasStorage.updateGuia(widget.guiaIndex, guiaActualizado);
        widget.onGuiaUpdated();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('📸 Foto agregada exitosamente'),
              backgroundColor: Color(0xFF4CAF50),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al agregar foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _eliminarFoto(int index) async {
    setState(() {
      fotos.removeAt(index);
    });
    
    // Guardar cambios en el almacenamiento
    try {
      final guiaActualizado = GuiaPesca(
        nombre: widget.guia.nombre,
        telefono: widget.guia.telefono,
        email: widget.guia.email,
        logoUrl: widget.guia.logoUrl,
        facebook: widget.guia.facebook,
        instagram: widget.guia.instagram,
        whatsapp: widget.guia.whatsapp,
        tiktok: widget.guia.tiktok,
        descripcion: widget.guia.descripcion,
        fotos: fotos,
        creadorId: widget.guia.creadorId,
      );
      
      await GuiasStorage.updateGuia(widget.guiaIndex, guiaActualizado);
      widget.onGuiaUpdated();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🗑️ Foto eliminada'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al eliminar foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: Text(
          widget.guia.nombre,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con logo y datos del guía
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Logo
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: widget.guia.logoUrl != null && widget.guia.logoUrl!.isNotEmpty
                        ? ClipOval(
                            child: widget.guia.logoUrl!.startsWith('http')
                                ? Image.network(
                                    widget.guia.logoUrl!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.person, size: 60, color: Color(0xFF4CAF50));
                                    },
                                  )
                                : Image.file(
                                    File(widget.guia.logoUrl!),
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.person, size: 60, color: Color(0xFF4CAF50));
                                    },
                                  ),
                          )
                        : const Icon(Icons.person, size: 60, color: Color(0xFF4CAF50)),
                  ),
                  const SizedBox(height: 16),
                  
                  // Nombre
                  Text(
                    widget.guia.nombre,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  
                  // Teléfono
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        widget.guia.telefono,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  
                  if (widget.guia.email != null && widget.guia.email!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.email, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          widget.guia.email!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            // Redes sociales
            if (widget.guia.facebook != null || widget.guia.instagram != null || widget.guia.whatsapp != null || widget.guia.tiktok != null)
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.guia.facebook != null && widget.guia.facebook!.isNotEmpty)
                      _buildSocialButton(Icons.facebook, 'Facebook', widget.guia.facebook!),
                    if (widget.guia.instagram != null && widget.guia.instagram!.isNotEmpty)
                      _buildSocialButton(Icons.camera_alt, 'Instagram', widget.guia.instagram!),
                    if (widget.guia.whatsapp != null && widget.guia.whatsapp!.isNotEmpty)
                      _buildSocialButton(Icons.chat, 'WhatsApp', widget.guia.whatsapp!),
                    if (widget.guia.tiktok != null && widget.guia.tiktok!.isNotEmpty)
                      _buildSocialButton(Icons.video_library, 'TikTok', widget.guia.tiktok!),
                  ],
                ),
              ),
            
            // Descripción
            if (widget.guia.descripcion != null && widget.guia.descripcion!.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sobre el Guía',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.guia.descripcion!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            
            // Galería de fotos
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '📸 Galería de Capturas',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _agregarFoto,
                        icon: const Icon(Icons.add_a_photo, size: 18),
                        label: const Text('Agregar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  if (fotos.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.photo_library,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay fotos aún',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Toca "Agregar" para subir fotos de capturas',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: fotos.length,
                      itemBuilder: (context, index) {
                        return _buildFotoCard(fotos[index], index);
                      },
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () async {
          Uri? uri;
          
          if (label == 'WhatsApp' && value.isNotEmpty) {
            // Limpiar número de WhatsApp (quitar espacios, guiones, etc.)
            final phone = value.replaceAll(RegExp(r'[^\d+]'), '');
            uri = Uri.parse('https://wa.me/$phone');
          } else if (label == 'Facebook' && value.isNotEmpty) {
            uri = Uri.parse(value.startsWith('http') ? value : 'https://facebook.com/$value');
          } else if (label == 'Instagram' && value.isNotEmpty) {
            uri = Uri.parse(value.startsWith('http') ? value : 'https://instagram.com/$value');
          } else if (label == 'TikTok' && value.isNotEmpty) {
            // Manejar @usuario o URL completa
            if (value.startsWith('http')) {
              uri = Uri.parse(value);
            } else {
              final username = value.replaceAll('@', '');
              uri = Uri.parse('https://tiktok.com/@$username');
            }
          }
          
          if (uri != null) {
            try {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('❌ No se puede abrir $label')),
                  );
                }
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('❌ Error al abrir $label: $e')),
                );
              }
            }
          }
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFotoCard(String fotoUrl, int index) {
    // Detectar si es una URL o ruta local
    final isLocalFile = !fotoUrl.startsWith('http');
    
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            // Abrir foto en pantalla completa
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PantallaFotoCompleta(
                  fotoUrl: fotoUrl,
                  isLocalFile: isLocalFile,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: isLocalFile
                  ? Image.file(
                      File(fotoUrl),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                          ),
                        );
                      },
                    )
                  : Image.network(
                      fotoUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.all(8),
            ),
            onPressed: () => _eliminarFoto(index),
          ),
        ),
      ],
    );
  }
}

