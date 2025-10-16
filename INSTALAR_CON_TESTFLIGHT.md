# 📱 SOLUCIÓN SIMPLE: TESTFLIGHT (OFICIAL DE APPLE)

## 🎯 **LA MEJOR OPCIÓN: TESTFLIGHT**

TestFlight es la plataforma **OFICIAL de Apple** para probar apps. Es:
- ✅ **100% Gratis**
- ✅ **Sin cables** - Todo desde el iPhone
- ✅ **90 días** - No necesitas renovar cada 7 días
- ✅ **Oficial** - Creado por Apple
- ✅ **Simple** - Solo instalas una app y listo

---

## 📋 **REQUISITOS**

1. Una cuenta de **Apple Developer** (GRATIS)
2. La app **TestFlight** en tu iPhone (gratis en App Store)
3. Subir tu app a **App Store Connect**

---

## 🚀 **PASO A PASO**

### **PASO 1: Crear cuenta Apple Developer (SI NO LA TIENES)**

1. Ve a: **https://developer.apple.com/**
2. Haz clic en **"Account"** (arriba derecha)
3. Inicia sesión con tu Apple ID
4. Acepta los términos y condiciones
5. ¡Listo! Ya tienes cuenta developer **GRATIS**

⚠️ **Nota:** La cuenta GRATIS te permite usar TestFlight. Solo necesitas pagar $99/año si quieres publicar en la App Store.

---

### **PASO 2: Instalar TestFlight en tu iPhone**

1. Abre la **App Store** en tu iPhone
2. Busca **"TestFlight"**
3. Descarga e instala la app (es oficial de Apple)
4. Abre TestFlight

---

### **PASO 3: Configurar App Store Connect**

1. Ve a: **https://appstoreconnect.apple.com/**
2. Inicia sesión con tu Apple ID
3. Haz clic en **"Mis Apps"** o **"My Apps"**
4. Haz clic en el botón **"+"** (arriba izquierda)
5. Selecciona **"Nueva app"** o **"New App"**

---

### **PASO 4: Registrar tu app**

Completa la información:

1. **Plataformas:** Selecciona **iOS**
2. **Nombre:** `GuiAppesca`
3. **Idioma principal:** Español
4. **Bundle ID:** 
   - Haz clic en el dropdown
   - Si no ves ninguno, necesitas crear uno primero (ver abajo)
5. **SKU:** `guiappesca` (puede ser cualquier texto único)
6. **Acceso de usuario:** Full Access
7. Haz clic en **"Crear"**

---

### **PASO 5: Crear Bundle ID (SI NO LO TIENES)**

1. Ve a: **https://developer.apple.com/account/resources/identifiers/list**
2. Haz clic en el botón **"+"** (junto a "Identifiers")
3. Selecciona **"App IDs"** → **"Continue"**
4. Selecciona **"App"** → **"Continue"**
5. Completa:
   - **Description:** `GuiAppesca`
   - **Bundle ID:** Selecciona **"Explicit"**
   - **Bundle ID:** `com.tuapellido.guiappesca` (ejemplo: `com.garcia.guiappesca`)
6. **Capabilities:** No necesitas seleccionar nada especial
7. Haz clic en **"Continue"** → **"Register"**
8. Regresa al **PASO 4** y completa el registro de la app

---

### **PASO 6: Actualizar el Bundle ID en tu proyecto**

Necesitas actualizar el código para que coincida con tu nuevo Bundle ID:

1. Abre el archivo `ios/Runner.xcodeproj/project.pbxproj`
2. Busca `PRODUCT_BUNDLE_IDENTIFIER`
3. Cámbialo a tu Bundle ID (ejemplo: `com.garcia.guiappesca`)

O más fácil, ejecuta este comando en la terminal:

```bash
cd ios
sed -i 's/com.guiappesca.app/com.TUAPELLIDO.guiappesca/g' Runner.xcodeproj/project.pbxproj
cd ..
```

(Reemplaza `TUAPELLIDO` con tu apellido)

---

### **PASO 7: Usar Codemagic para subir a TestFlight**

Voy a actualizar tu `codemagic.yaml` para que suba automáticamente a TestFlight.

Necesitarás crear un **App-Specific Password** y una **API Key**.

#### **7.1 Crear App-Specific Password:**

1. Ve a: **https://appleid.apple.com/**
2. Inicia sesión
3. En **"Seguridad"**, busca **"Contraseñas de aplicaciones"**
4. Haz clic en **"Generar contraseña..."**
5. Nombre: `Codemagic`
6. Copia la contraseña (formato: `xxxx-xxxx-xxxx-xxxx`)
7. **Guárdala** - la necesitarás después

#### **7.2 Crear API Key de App Store Connect:**

1. Ve a: **https://appstoreconnect.apple.com/access/api**
2. En **"Keys"**, haz clic en **"+"** o **"Generate API Key"**
3. **Name:** `Codemagic`
4. **Access:** Selecciona **"App Manager"** o **"Developer"**
5. Haz clic en **"Generate"**
6. **Descarga** el archivo `.p8` (solo lo puedes descargar UNA VEZ)
7. Copia y guarda:
   - **Issuer ID** (arriba de la tabla)
   - **Key ID** (en la columna de la tabla)

---

### **PASO 8: Configurar Codemagic con tus credenciales**

1. Ve a **Codemagic** → Tu proyecto
2. Ve a **"Environment variables"** o **"Variable groups"**
3. Crea un grupo llamado **`app_store_credentials`**
4. Agrega estas variables:

**Variable 1:**
- **Key:** `APP_STORE_CONNECT_ISSUER_ID`
- **Value:** (El Issuer ID que copiaste)
- ☑️ **Secure**

**Variable 2:**
- **Key:** `APP_STORE_CONNECT_KEY_IDENTIFIER`  
- **Value:** (El Key ID que copiaste)
- ☑️ **Secure**

**Variable 3:**
- **Key:** `APP_STORE_CONNECT_PRIVATE_KEY`
- **Value:** (Abre el archivo .p8 con un editor de texto y copia TODO el contenido)
- ☑️ **Secure**

**Variable 4:**
- **Key:** `CERTIFICATE_PRIVATE_KEY`
- **Value:** (Dejar en blanco por ahora)
- ☑️ **Secure**

5. Guarda el grupo

---

### **PASO 9: Actualizar codemagic.yaml**

(Te lo actualizo yo - espera un momento)

---

### **PASO 10: Ejecutar el build**

1. En Codemagic, haz clic en **"Start new build"**
2. Selecciona el workflow **"iOS Workflow (TestFlight)"**
3. Haz clic en **"Start build"**
4. **Espera 20-30 minutos**
5. Si todo sale bien, tu app se subirá automáticamente a TestFlight

---

### **PASO 11: Instalar desde TestFlight**

1. Te llegará un **email** de TestFlight diciendo "Estás invitado a probar GuiAppesca"
2. Abre el email en tu iPhone
3. Toca **"Ver en TestFlight"** o **"Empezar a probar"**
4. Se abrirá la app TestFlight
5. Toca **"Aceptar"** → **"Instalar"**
6. ¡Listo! La app se instalará en tu iPhone

---

## 🎉 **VENTAJAS DE TESTFLIGHT**

✅ **90 días** - No necesitas renovar cada 7 días  
✅ **Sin cables** - Todo desde el iPhone  
✅ **Oficial** - Creado por Apple  
✅ **Actualizaciones fáciles** - Solo tocas "Actualizar" en TestFlight  
✅ **Múltiples dispositivos** - Puedes instalar en hasta 100 iPhones  
✅ **Para equipos** - Puedes invitar a otras personas (hasta 10,000)  

---

## 🆘 **ALTERNATIVA MÁS RÁPIDA: EXPO.DEV (SIN CONFIGURACIÓN)**

Si TestFlight te parece complicado, existe **Expo Application Services (EAS)**:

1. Es como TestFlight pero sin necesidad de configurar App Store Connect
2. Solo subes tu IPA y obtienes un link
3. Abres el link en tu iPhone y se instala
4. Dura **30 días**

¿Quieres que te ayude con TestFlight o prefieres probar Expo? 🤔

---

**Mi recomendación:** TestFlight es lo mejor a largo plazo. Vale la pena configurarlo una vez y olvidarte por 90 días.

