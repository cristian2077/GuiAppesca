# Configuración del Widget de Clima

## 📋 Requisitos

Para que el widget de clima funcione con datos reales, necesitas configurar una API key de OpenWeatherMap.

## 🔑 Obtener API Key

1. Ve a [OpenWeatherMap](https://openweathermap.org/api)
2. Crea una cuenta gratuita
3. Ve a "API keys" en tu perfil
4. Copia tu API key

## ⚙️ Configuración

1. Abre el archivo `lib/config/weather_config.dart`
2. Reemplaza `'YOUR_API_KEY_HERE'` con tu API key real:

```dart
static const String apiKey = 'tu_api_key_aqui';
```

## 📱 Permisos Configurados

### Android
- ✅ `ACCESS_FINE_LOCATION` - Ubicación precisa
- ✅ `ACCESS_COARSE_LOCATION` - Ubicación aproximada
- ✅ `ACCESS_BACKGROUND_LOCATION` - Ubicación en segundo plano
- ✅ `INTERNET` - Acceso a internet
- ✅ `ACCESS_NETWORK_STATE` - Estado de red

### iOS
- ✅ `NSLocationWhenInUseUsageDescription` - Ubicación cuando la app está en uso
- ✅ `NSLocationAlwaysAndWhenInUseUsageDescription` - Ubicación siempre y cuando está en uso
- ✅ `NSLocationAlwaysUsageDescription` - Ubicación siempre

## 🎯 Funcionalidades

### Widget Principal
- 🌡️ **Temperatura actual** en tiempo real
- 📍 **Ubicación** del dispositivo o por defecto
- 💧 **Humedad** actual
- 💨 **Velocidad del viento**
- ☀️ **Estado del clima** con iconos
- 🔄 **Actualización automática**

### Pantalla de Pronóstico
- 📅 **Pronóstico de 10 días**
- 📊 **Datos detallados** por día
- 🎨 **Interfaz atractiva**

## 🔄 Fallback

Si no se puede obtener la ubicación o hay problemas con la API:
- Se usa ubicación por defecto: **Paraná, Argentina**
- Se muestran datos de ejemplo
- La app sigue funcionando normalmente

## 🚀 Uso

Una vez configurada la API key:

1. **Primer uso**: La app pedirá permisos de ubicación
2. **Widget principal**: Muestra clima actual automáticamente
3. **Toca el widget**: Abre pronóstico de 10 días
4. **Sin internet**: Muestra datos por defecto

## 🔧 Personalización

Puedes cambiar la ubicación por defecto en `weather_config.dart`:

```dart
static const String defaultLocation = 'Tu Ciudad, Tu País';
static const double defaultLatitude = -31.7413;
static const double defaultLongitude = -60.5115;
```

## 📝 Notas Importantes

- ⚠️ **API Key gratuita**: Tiene límites de uso (1000 llamadas/día)
- 🔒 **Seguridad**: No compartas tu API key
- 📱 **Permisos**: El usuario puede denegar ubicación
- 🌐 **Internet**: Requiere conexión para datos reales
- 🔄 **Actualización**: Los datos se actualizan al abrir la app

## 🐛 Solución de Problemas

### Widget no muestra datos
1. Verifica que la API key esté configurada
2. Revisa la conexión a internet
3. Asegúrate de que los permisos estén otorgados

### Error de ubicación
1. Verifica que la ubicación esté habilitada en el dispositivo
2. Otorga permisos cuando la app los solicite
3. La app funcionará con ubicación por defecto

### API no responde
1. Verifica tu límite de uso en OpenWeatherMap
2. Revisa que la API key sea válida
3. La app mostrará datos por defecto como fallback
