import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

// Modelo de datos para Hospedaje
class Hospedaje {
  final String nombre;
  final String telefono;
  final String? email;
  final String? logoUrl;
  final String? facebook;
  final String? instagram;
  final String? whatsapp;
  final String? tiktok;
  final String? direccion;
  final String? descripcion;
  final List<String> fotos;
  final int? capacidad;
  final double? precioPorNoche;
  final List<String> servicios;
  final String creadorId;

  Hospedaje({
    required this.nombre,
    required this.telefono,
    this.email,
    this.logoUrl,
    this.facebook,
    this.instagram,
    this.whatsapp,
    this.tiktok,
    this.direccion,
    this.descripcion,
    List<String>? fotos,
    this.capacidad,
    this.precioPorNoche,
    List<String>? servicios,
    required this.creadorId,
  }) : fotos = fotos ?? [],
       servicios = servicios ?? [];

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
      'direccion': direccion,
      'descripcion': descripcion,
      'fotos': fotos,
      'capacidad': capacidad,
      'precioPorNoche': precioPorNoche,
      'servicios': servicios,
      'creadorId': creadorId,
    };
  }

  factory Hospedaje.fromJson(Map<String, dynamic> json) {
    return Hospedaje(
      nombre: json['nombre'],
      telefono: json['telefono'],
      email: json['email'],
      logoUrl: json['logoUrl'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      whatsapp: json['whatsapp'],
      tiktok: json['tiktok'],
      direccion: json['direccion'],
      descripcion: json['descripcion'],
      fotos: json['fotos'] != null ? List<String>.from(json['fotos']) : [],
      capacidad: json['capacidad'],
      precioPorNoche: json['precioPorNoche']?.toDouble(),
      servicios: json['servicios'] != null ? List<String>.from(json['servicios']) : [],
      creadorId: json['creadorId'] ?? '',
    );
  }
}

// Servicio para manejar la persistencia de hospedajes
class HospedajesStorage {
  static const String _hospedajesKey = 'saved_hospedajes';
  static const String _deviceIdKey = 'device_id';

  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);
    
    if (deviceId == null) {
      deviceId = 'device_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';
      await prefs.setString(_deviceIdKey, deviceId);
    }
    
    return deviceId;
  }

  static Future<void> saveHospedajes(List<Hospedaje> hospedajes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> hospedajesJson = hospedajes.map((h) => json.encode(h.toJson())).toList();
      await prefs.setStringList(_hospedajesKey, hospedajesJson);
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Hospedaje>> loadHospedajes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? hospedajesJson = prefs.getStringList(_hospedajesKey);
    
    if (hospedajesJson == null) {
      return [];
    }
    
    try {
      return hospedajesJson.map((jsonString) {
        final Map<String, dynamic> hospedajeMap = json.decode(jsonString);
        return Hospedaje.fromJson(hospedajeMap);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> addHospedaje(Hospedaje hospedaje) async {
    try {
      final hospedajes = await loadHospedajes();
      hospedajes.add(hospedaje);
      await saveHospedajes(hospedajes);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateHospedaje(int index, Hospedaje hospedaje) async {
    try {
      final hospedajes = await loadHospedajes();
      if (index >= 0 && index < hospedajes.length) {
        hospedajes[index] = hospedaje;
        await saveHospedajes(hospedajes);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> removeHospedaje(int index) async {
    final hospedajes = await loadHospedajes();
    if (index >= 0 && index < hospedajes.length) {
      hospedajes.removeAt(index);
      await saveHospedajes(hospedajes);
    }
  }
}

// Pantalla principal de Servicios de Hospedaje
class PantallaServiciosHospedaje extends StatefulWidget {
  const PantallaServiciosHospedaje({super.key});

  @override
  State<PantallaServiciosHospedaje> createState() => _PantallaServiciosHospedajeState();
}

class _PantallaServiciosHospedajeState extends State<PantallaServiciosHospedaje> {
  List<Hospedaje> hospedajes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarHospedajes();
  }

  Future<void> _cargarHospedajes() async {
    try {
      final loadedHospedajes = await HospedajesStorage.loadHospedajes();
      if (mounted) {
        setState(() {
          hospedajes = loadedHospedajes;
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
            content: Text('Error al cargar hospedajes: $e'),
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
          'Servicios de Hospedaje',
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
            // Botón para agregar nuevo hospedaje
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PantallaAgregarHospedaje(
                      onGuardado: (hospedaje) async {
                        try {
                          await HospedajesStorage.addHospedaje(hospedaje);
                          await _cargarHospedajes();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Hospedaje guardado exitosamente'),
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
                'Agregar Nuevo Hospedaje',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Lista de hospedajes
            Expanded(
              child: hospedajes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hotel,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay hospedajes agregados',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Toca el botón "Agregar Nuevo Hospedaje" para comenzar',
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
                      itemCount: hospedajes.length,
                      itemBuilder: (context, index) {
                        return _buildHospedajeCard(hospedajes[index], index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHospedajeCard(Hospedaje hospedaje, int index) {
    return FutureBuilder<String>(
      future: HospedajesStorage.getDeviceId(),
      builder: (context, snapshot) {
        final currentDeviceId = snapshot.data ?? '';
        final isCreator = currentDeviceId == hospedaje.creadorId;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaDetalleHospedaje(
                    hospedaje: hospedaje,
                    hospedajeIndex: index,
                    onHospedajeUpdated: () => _cargarHospedajes(),
                  ),
                ),
              );
            },
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF2196F3),
                child: hospedaje.logoUrl != null && hospedaje.logoUrl!.isNotEmpty
                    ? ClipOval(
                        child: hospedaje.logoUrl!.startsWith('http')
                            ? Image.network(
                                hospedaje.logoUrl!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.hotel, size: 30, color: Colors.white);
                                },
                              )
                            : Image.file(
                                File(hospedaje.logoUrl!),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.hotel, size: 30, color: Colors.white);
                                },
                              ),
                      )
                    : const Icon(Icons.hotel, size: 30, color: Colors.white),
              ),
              title: Text(
                hospedaje.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hospedaje.telefono,
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (hospedaje.precioPorNoche != null)
                    Text(
                      '\$${hospedaje.precioPorNoche!.toStringAsFixed(0)}/noche',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              trailing: isCreator ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFFFF9800)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Función de editar en desarrollo'),
                          backgroundColor: Color(0xFFFF9800),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Eliminar Hospedaje'),
                          content: Text('¿Estás seguro de eliminar ${hospedaje.nombre}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                try {
                                  await HospedajesStorage.removeHospedaje(index);
                                  await _cargarHospedajes();
                                  if (mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('🗑️ Hospedaje eliminado'),
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
              ) : null,
            ),
          ),
        );
      },
    );
  }
}

// Pantalla para agregar nuevo hospedaje
class PantallaAgregarHospedaje extends StatefulWidget {
  final Function(Hospedaje) onGuardado;

  const PantallaAgregarHospedaje({
    super.key,
    required this.onGuardado,
  });

  @override
  State<PantallaAgregarHospedaje> createState() => _PantallaAgregarHospedajeState();
}

class _PantallaAgregarHospedajeState extends State<PantallaAgregarHospedaje> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _tiktokController = TextEditingController();
  final _direccionController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _capacidadController = TextEditingController();
  final _precioController = TextEditingController();
  
  String? _logoImagePath;
  final ImagePicker _picker = ImagePicker();
  final List<String> _serviciosSeleccionados = [];
  
  final List<String> _serviciosDisponibles = [
    'WiFi',
    'Aire Acondicionado',
    'Calefacción',
    'Cocina',
    'TV',
    'Parrilla',
    'Estacionamiento',
    'Piscina',
    'Desayuno Incluido',
    'Ropa de Cama',
    'Toallas',
    'Limpieza',
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _whatsappController.dispose();
    _tiktokController.dispose();
    _direccionController.dispose();
    _descripcionController.dispose();
    _capacidadController.dispose();
    _precioController.dispose();
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

  Future<void> _guardarHospedaje() async {
    if (_formKey.currentState!.validate()) {
      final deviceId = await HospedajesStorage.getDeviceId();
      
      final hospedaje = Hospedaje(
        nombre: _nombreController.text,
        telefono: _telefonoController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
        logoUrl: _logoImagePath,
        facebook: _facebookController.text.isEmpty ? null : _facebookController.text,
        instagram: _instagramController.text.isEmpty ? null : _instagramController.text,
        whatsapp: _whatsappController.text.isEmpty ? null : _whatsappController.text,
        tiktok: _tiktokController.text.isEmpty ? null : _tiktokController.text,
        direccion: _direccionController.text.isEmpty ? null : _direccionController.text,
        descripcion: _descripcionController.text.isEmpty ? null : _descripcionController.text,
        capacidad: _capacidadController.text.isEmpty ? null : int.tryParse(_capacidadController.text),
        precioPorNoche: _precioController.text.isEmpty ? null : double.tryParse(_precioController.text),
        servicios: _serviciosSeleccionados,
        creadorId: deviceId,
      );

      widget.onGuardado(hospedaje);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agregar Nuevo Hospedaje',
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
                  labelText: 'Nombre del Hospedaje *',
                  prefixIcon: Icon(Icons.hotel),
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
              
              // Dirección
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(
                  labelText: 'Dirección (opcional)',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              // Capacidad y Precio
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _capacidadController,
                      decoration: const InputDecoration(
                        labelText: 'Capacidad',
                        prefixIcon: Icon(Icons.people),
                        border: OutlineInputBorder(),
                        hintText: '4 personas',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _precioController,
                      decoration: const InputDecoration(
                        labelText: 'Precio/Noche',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                        hintText: '5000',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Selector de Logo
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
              
              // Servicios
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
                      'Servicios Disponibles',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _serviciosDisponibles.map((servicio) {
                        final isSelected = _serviciosSeleccionados.contains(servicio);
                        return FilterChip(
                          label: Text(servicio),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _serviciosSeleccionados.add(servicio);
                              } else {
                                _serviciosSeleccionados.remove(servicio);
                              }
                            });
                          },
                          selectedColor: const Color(0xFF2196F3),
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Redes sociales
              TextFormField(
                controller: _whatsappController,
                decoration: const InputDecoration(
                  labelText: 'WhatsApp (opcional)',
                  hintText: '+54 9 11 1234-5678',
                  prefixIcon: Icon(Icons.chat),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _facebookController,
                decoration: const InputDecoration(
                  labelText: 'Facebook (opcional)',
                  hintText: 'https://facebook.com/tu_pagina',
                  prefixIcon: Icon(Icons.facebook),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _instagramController,
                decoration: const InputDecoration(
                  labelText: 'Instagram (opcional)',
                  hintText: 'https://instagram.com/tu_perfil',
                  prefixIcon: Icon(Icons.camera_alt),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _tiktokController,
                decoration: const InputDecoration(
                  labelText: 'TikTok (opcional)',
                  hintText: 'https://tiktok.com/@tu_usuario',
                  prefixIcon: Icon(Icons.video_library),
                  border: OutlineInputBorder(),
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
                      onPressed: _guardarHospedaje,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
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

// Pantalla de detalles del hospedaje
class PantallaDetalleHospedaje extends StatelessWidget {
  final Hospedaje hospedaje;
  final int hospedajeIndex;
  final VoidCallback onHospedajeUpdated;

  const PantallaDetalleHospedaje({
    super.key,
    required this.hospedaje,
    required this.hospedajeIndex,
    required this.onHospedajeUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          hospedaje.nombre,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con logo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                ),
              ),
              child: Column(
                children: [
                  if (hospedaje.logoUrl != null && hospedaje.logoUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: hospedaje.logoUrl!.startsWith('http')
                          ? Image.network(hospedaje.logoUrl!, height: 120, width: 120, fit: BoxFit.cover)
                          : Image.file(File(hospedaje.logoUrl!), height: 120, width: 120, fit: BoxFit.cover),
                    )
                  else
                    const Icon(Icons.hotel, size: 80, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    hospedaje.nombre,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (hospedaje.direccion != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on, color: Colors.white, size: 20),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              hospedaje.direccion!,
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            
            // Información principal
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Capacidad y Precio
                  if (hospedaje.capacidad != null || hospedaje.precioPorNoche != null)
                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (hospedaje.capacidad != null)
                              Column(
                                children: [
                                  const Icon(Icons.people, color: Color(0xFF2196F3), size: 32),
                                  const SizedBox(height: 8),
                                  const Text('Capacidad', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  Text(
                                    '${hospedaje.capacidad} personas',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            if (hospedaje.precioPorNoche != null)
                              Column(
                                children: [
                                  const Icon(Icons.attach_money, color: Color(0xFF4CAF50), size: 32),
                                  const SizedBox(height: 8),
                                  const Text('Precio', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  Text(
                                    '\$${hospedaje.precioPorNoche!.toStringAsFixed(0)}/noche',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4CAF50),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Servicios
                  if (hospedaje.servicios.isNotEmpty)
                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '✨ Servicios Incluidos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: hospedaje.servicios.map((servicio) {
                                return Chip(
                                  label: Text(servicio),
                                  backgroundColor: const Color(0xFF2196F3),
                                  labelStyle: const TextStyle(color: Colors.white, fontSize: 13),
                                  avatar: const Icon(Icons.check_circle, color: Colors.white, size: 18),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Descripción
                  if (hospedaje.descripcion != null && hospedaje.descripcion!.isNotEmpty)
                    Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '📝 Descripción',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              hospedaje.descripcion!,
                              style: const TextStyle(fontSize: 15, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Contacto
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '📞 Contacto',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            leading: const Icon(Icons.phone, color: Color(0xFF2196F3)),
                            title: Text(hospedaje.telefono),
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          if (hospedaje.email != null)
                            ListTile(
                              leading: const Icon(Icons.email, color: Color(0xFF2196F3)),
                              title: Text(hospedaje.email!),
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                        ],
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
}

