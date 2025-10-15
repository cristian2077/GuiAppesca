# 📱 GUÍA COMPLETA: GENERAR IPA CON APPLE ID GRATIS

## ✅ **IMPORTANTE: Esto ya está listo en tu proyecto**
- ✅ El archivo `codemagic.yaml` ya está configurado
- ✅ El repositorio ya está en GitHub
- ✅ Solo necesitas seguir los pasos de configuración en Codemagic

---

## 🎯 **PASO 1: REGISTRARSE EN CODEMAGIC**

### 1.1 Crear cuenta
1. Abre tu navegador y ve a: **https://codemagic.io/signup**
2. Haz clic en el botón azul: **"Sign up with GitHub"**
3. Te redirigirá a GitHub para autorizar
4. Haz clic en **"Authorize codemagic-ltd-app"**
5. Espera a que cargue el dashboard de Codemagic

---

## 🚀 **PASO 2: AGREGAR TU APP A CODEMAGIC**

### 2.1 Conectar repositorio
1. En el dashboard de Codemagic, haz clic en **"Add application"**
2. Selecciona **"Flutter App"**
3. En la lista de repositorios, busca: **`GuiAppesca`** o **`cristian2077/GuiAppesca`**
4. Haz clic en el repositorio cuando lo encuentres
5. Haz clic en **"Finish: Add application"**

---

## 🔑 **PASO 3: GENERAR CONTRASEÑA ESPECÍFICA DE APPLE**

### 3.1 Ir a Apple ID
1. Abre una nueva pestaña en tu navegador
2. Ve a: **https://appleid.apple.com**
3. Haz clic en **"Iniciar sesión"**
4. Ingresa tu Apple ID (email) y contraseña
5. Completa la verificación de dos factores si te la pide

### 3.2 Generar contraseña específica
1. Una vez dentro, busca la sección **"Seguridad"** o **"Sign-In and Security"**
2. Busca **"Contraseñas específicas de app"** o **"App-Specific Passwords"**
3. Haz clic en **"Generar contraseña..."** o **"Generate Password..."**
4. En el campo de nombre, escribe: **`Codemagic iOS`**
5. Haz clic en **"Crear"** o **"Create"**
6. ⚠️ **IMPORTANTE:** Aparecerá una contraseña con este formato: `abcd-efgh-ijkl-mnop`
7. **COPIA ESTA CONTRASEÑA** (puedes hacer clic en el botón de copiar)
8. ⚠️ **NO CIERRES ESTA VENTANA** hasta que la hayas guardado en Codemagic

### 3.3 Guardar la contraseña temporalmente
1. Abre el Bloc de notas (Notepad)
2. Pega la contraseña allí temporalmente
3. También anota tu email de Apple ID
4. Ejemplo:
   ```
   Apple ID: tu_email@icloud.com
   Contraseña específica: abcd-efgh-ijkl-mnop
   ```

---

## ⚙️ **PASO 4: CONFIGURAR VARIABLES EN CODEMAGIC**

### 4.1 Acceder a variables de entorno
1. Regresa a la pestaña de Codemagic
2. Deberías estar viendo tu app **GuiAppesca**
3. En el menú de la izquierda, haz clic en **"Environment variables"**
4. Haz clic en **"Add variable group"** (botón verde arriba a la derecha)

### 4.2 Crear el grupo de variables
1. En **"Variable group name"**, escribe: `apple_credentials`
2. Haz clic en **"Add variable"** (aparecerá un formulario)

### 4.3 Agregar la primera variable (APPLE_ID)
1. En **"Variable name"**, escribe exactamente: `APPLE_ID`
2. En **"Variable value"**, pega tu email de Apple ID (ej: `carolina@icloud.com`)
3. ✅ **Marca el checkbox** que dice **"Secure"**
4. Haz clic en **"Add"**

### 4.4 Agregar la segunda variable (CONTRASEÑA)
1. Haz clic nuevamente en **"Add variable"**
2. En **"Variable name"**, escribe exactamente: `APPLE_APP_SPECIFIC_PASSWORD`
3. En **"Variable value"**, pega la contraseña específica que copiaste (ej: `abcd-efgh-ijkl-mnop`)
   - ⚠️ **IMPORTANTE:** Pega SOLO la contraseña, sin guiones extra ni espacios
4. ✅ **Marca el checkbox** que dice **"Secure"**
5. Haz clic en **"Add"**

### 4.5 Guardar el grupo
1. Verifica que tengas 2 variables:
   - `APPLE_ID` (con el icono de candado 🔒)
   - `APPLE_APP_SPECIFIC_PASSWORD` (con el icono de candado 🔒)
2. Haz clic en **"Save"** o **"Add group"**

---

## 🔧 **PASO 5: VERIFICAR CONFIGURACIÓN DEL WORKFLOW**

### 5.1 Ir a configuración del workflow
1. En el menú de la izquierda, haz clic en **"Workflow settings"**
2. En la parte superior, selecciona **"codemagic.yaml"** (debería estar seleccionado por defecto)
3. Verás el contenido del archivo - **NO LO MODIFIQUES**, ya está configurado ✅

---

## ▶️ **PASO 6: INICIAR EL BUILD DEL IPA**

### 6.1 Preparar el build
1. En el menú de la izquierda, haz clic en **"Builds"** o regresa al inicio de tu app
2. Haz clic en **"Start new build"** (botón azul grande)

### 6.2 Configurar el build
1. En **"Specify branch"**, selecciona: `main`
2. En **"Select workflow from codemagic.yaml"**, selecciona: `ios-workflow`
3. Verifica que todo esté correcto:
   - Branch: `main` ✅
   - Workflow: `ios-workflow` ✅
4. Haz clic en **"Start new build"** (botón azul abajo)

### 6.3 Esperar el build
1. Verás una pantalla con el progreso del build
2. Esto tomará aproximadamente **10-15 minutos**
3. Verás diferentes etapas:
   - ⏳ Preparing build machine
   - ⏳ Get Flutter packages
   - ⏳ Install pods
   - ⏳ Flutter build iOS
   - ⏳ Crear IPA
4. ☕ **Toma un café y espera** - puedes dejar la pestaña abierta o revisarla después

### 6.4 Verificar éxito del build
1. Cuando termine, verás un ✅ **verde grande** si todo salió bien
2. O un ❌ **rojo** si algo falló (si falla, avísame y te ayudo)

---

## 📦 **PASO 7: DESCARGAR EL IPA**

### 7.1 Encontrar el archivo
1. Cuando el build termine exitosamente, baja en la página
2. Busca la sección **"Artifacts"** o **"Build artifacts"**
3. Verás un archivo llamado: **`GuiAppesca-v2.0.0-development.ipa`**

### 7.2 Descargar
1. Haz clic en el nombre del archivo o en el botón de descarga
2. El archivo se descargará a tu carpeta de **Descargas**
3. Tamaño aproximado: 30-60 MB

---

## 📲 **PASO 8: INSTALAR EN TU IPHONE**

Tienes **3 opciones** para instalar el IPA en tu iPhone:

---

### **OPCIÓN A: ALTSTORE (Recomendado - Sin Mac)**

#### A.1 Descargar AltStore
1. En tu PC Windows, ve a: **https://altstore.io/**
2. Haz clic en **"Download AltStore for Windows"**
3. Descarga e instala el programa

#### A.2 Instalar iTunes y iCloud
- ⚠️ **IMPORTANTE:** AltStore necesita iTunes e iCloud de Apple
- Si no los tienes:
  1. Ve a: https://www.apple.com/itunes/
  2. Descarga e instala **iTunes para Windows**
  3. Ve a: https://support.apple.com/en-us/HT204283
  4. Descarga e instala **iCloud para Windows**

#### A.3 Configurar AltStore
1. Conecta tu iPhone a la PC con el cable USB
2. Abre **iTunes** y desbloquea tu iPhone
3. En iTunes, haz clic en **"Confiar en este ordenador"** (si te lo pide)
4. En tu iPhone, confirma **"Confiar"** cuando te lo pida
5. En Windows, abre **AltStore** (ícono en la bandeja del sistema)
6. Haz clic derecho en el ícono de AltStore
7. Selecciona **"Install AltStore"** → Selecciona tu iPhone

#### A.4 Instalar el IPA
1. En AltStore (bandeja del sistema), haz clic derecho
2. Selecciona **"Sideload..."**
3. Busca y selecciona el archivo `GuiAppesca-v2.0.0-development.ipa`
4. Espera a que se instale (1-2 minutos)
5. ✅ La app aparecerá en tu iPhone

---

### **OPCIÓN B: 3UTOOLS (Más fácil - Sin Mac)**

#### B.1 Descargar 3uTools
1. Ve a: **http://www.3u.com/**
2. Haz clic en **"Download"**
3. Descarga e instala 3uTools

#### B.2 Instalar el IPA
1. Abre **3uTools**
2. Conecta tu iPhone con el cable USB
3. Desbloquea tu iPhone y confirma **"Confiar en este ordenador"**
4. En 3uTools, ve a la pestaña **"Apps"**
5. Haz clic en **"Install"** (arriba)
6. Busca y selecciona el archivo `GuiAppesca-v2.0.0-development.ipa`
7. Haz clic en **"Install"**
8. Espera a que se instale (1-2 minutos)
9. ✅ La app aparecerá en tu iPhone

---

### **OPCIÓN C: XCODE (Solo si tienes Mac)**

#### C.1 Abrir Xcode
1. Conecta tu iPhone al Mac
2. Abre **Xcode**
3. Ve a **Window** → **Devices and Simulators**

#### C.2 Instalar el IPA
1. Selecciona tu iPhone en la lista de la izquierda
2. En la sección **"Installed Apps"**, arrastra el archivo `.ipa`
3. O haz clic en el botón **"+"** y selecciona el archivo
4. Espera a que se instale
5. ✅ La app aparecerá en tu iPhone

---

## 🔓 **PASO 9: CONFIAR EN EL CERTIFICADO (IMPORTANTE)**

### 9.1 Primera vez que abres la app
1. Cuando intentes abrir la app, verás un mensaje:
   - **"Desarrollador empresarial no confiable"** o
   - **"Untrusted Enterprise Developer"**
2. ❌ **NO PODRÁS ABRIR LA APP TODAVÍA**
3. ✅ Haz clic en **"Cancelar"**

### 9.2 Confiar en el certificado
1. En tu iPhone, ve a: **Configuración** (Settings)
2. Baja y busca: **General**
3. Baja y busca: **Gestión de VPN y dispositivos** o **VPN & Device Management**
4. En la sección **"APPS DE DESARROLLADOR"**, verás tu Apple ID
5. Haz clic en tu Apple ID (ej: `carolina@icloud.com`)
6. Haz clic en el botón azul: **"Confiar en [tu Apple ID]"**
7. Confirma haciendo clic en **"Confiar"** en el diálogo

### 9.3 Abrir la app
1. ✅ Ahora vuelve al Home de tu iPhone
2. ✅ Abre la app **GuiAppesca**
3. ✅ ¡Debería funcionar perfectamente!

---

## ⚠️ **LIMITACIONES DEL CERTIFICADO GRATIS**

### Duración
- ✅ **Funciona durante:** 7 días
- ❌ **Después de 7 días:** La app dejará de abrir
- 🔄 **Solución:** Repetir el proceso (toma 5 minutos):
  1. Ir a Codemagic
  2. Hacer un nuevo build
  3. Descargar el nuevo IPA
  4. Reinstalar en el iPhone

### Limitaciones adicionales
- ❌ No puedes compartir la app con otros iPhones (solo funciona en el tuyo)
- ❌ No puedes subirla a la App Store con este certificado
- ✅ Puedes tener hasta 3 apps instaladas simultáneamente con certificado gratis
- ✅ Todas las funciones de la app funcionan normalmente

---

## 🆘 **SOLUCIÓN DE PROBLEMAS**

### Problema 1: Build falla en Codemagic
**Error:** "Command failed" o "Build failed"

**Solución:**
1. Verifica que las variables estén bien configuradas:
   - Nombre exacto: `APPLE_ID` y `APPLE_APP_SPECIFIC_PASSWORD`
   - Marcadas como "Secure"
2. Verifica que la contraseña específica esté correcta (sin espacios extra)
3. Intenta hacer un nuevo build

### Problema 2: No puedo generar contraseña específica
**Error:** "No veo la opción de contraseñas específicas"

**Solución:**
1. Tu Apple ID debe tener verificación en dos pasos activada
2. Ve a **appleid.apple.com** → **Seguridad**
3. Activa la **"Autenticación de dos factores"**
4. Espera 24 horas e intenta de nuevo

### Problema 3: No puedo confiar en el certificado
**Error:** "No aparece mi Apple ID en Configuración"

**Solución:**
1. Desinstala la app completamente
2. Reinicia tu iPhone
3. Vuelve a instalar el IPA
4. Revisa de nuevo en Configuración → General → Gestión de VPN y dispositivos

### Problema 4: La app se cierra inmediatamente
**Error:** La app abre y se cierra al instante

**Solución:**
1. Verifica que hayas confiado en el certificado (Paso 9)
2. Si ya lo hiciste, desinstala y reinstala la app
3. Reinicia tu iPhone

---

## 📞 **¿NECESITAS AYUDA?**

Si tienes algún problema:
1. Anota en qué paso exacto te quedaste
2. Si hay un mensaje de error, cópialo o toma captura
3. Avísame y te ayudo inmediatamente

---

## ✅ **CHECKLIST RÁPIDO**

Antes de empezar, asegúrate de tener:
- [ ] Cuenta de Apple ID con verificación en dos pasos
- [ ] Conexión a internet estable
- [ ] Cable USB para conectar tu iPhone a la PC
- [ ] iTunes instalado (para AltStore)
- [ ] Espacio en tu iPhone (al menos 200 MB)

---

## 🎉 **¡LISTO!**

Siguiendo esta guía paso a paso, tendrás tu app **GuiAppesca** funcionando en tu iPhone en aproximadamente **30-40 minutos** (incluyendo el tiempo de build).

**¿Comenzamos?** ¡Avísame en qué paso estás y te voy guiando! 🚀

