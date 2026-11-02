# Reporta tu Barrio 📍

Aplicación móvil piloto de reporte ciudadano para problemas del espacio público (baches, basura acumulada, alumbrado dañado, fugas de agua y otros) construida en **Flutter** con **Material 3**.

Esta versión corresponde a la **FASE 1 (Diseño e Interfaz con datos simulados en memoria)**, orientada a validar la experiencia de usuario y flujos de punta a punta sin dependencias externas de Firebase ni persistencia local en disco.

---

## 🚀 Cómo Ejecutar la Aplicación

### Requisitos previos
- Flutter SDK (versión >= 3.13) instalado y configurado en el `PATH`.
- Dispositivo Android físico conectado con depuración USB o un Emulador Android (AVD) iniciado.

### Comandos de ejecución
1. **Verificar estado del entorno**:
   ```bash
   flutter doctor
   ```
2. **Descargar dependencias (si es necesario)**:
   ```bash
   flutter pub get
   ```
3. **Ejecutar en modo depuración**:
   ```bash
   flutter run
   ```
4. **Verificar análisis estático de código**:
   ```bash
   flutter analyze
   ```
5. **Ejecutar pruebas smoke**:
   ```bash
   flutter test
   ```

---

## 📁 Estructura del Proyecto

El proyecto sigue una arquitectura por capas estrictamente desacoplada:

```text
lib/
├── main.dart                       # Punto de entrada, inyección de dependencias abstractas
├── app.dart                        # MaterialApp, tema Material 3 y generador de rutas
├── core/
│   ├── theme/
│   │   ├── app_colors.dart         # Paleta de colores (#1E5AA8 y estados: Pendiente, En revisión, En atención, Resuelto, Rechazado)
│   │   └── app_theme.dart          # Configuración Material 3 (radios 12px, botones >=48px, inputs, chips)
│   ├── constants/
│   │   └── app_constants.dart      # Centro del mapa, zoom, credenciales demo y textos fijos
│   └── routes/
│       └── app_routes.dart         # Enrutamiento con rutas nombradas de Navigator
├── data/
│   ├── models/
│   │   ├── categoria_reporte.dart  # Enum de categorías (Bache, Basura, Alumbrado, Fuga de agua, Otros)
│   │   ├── estado_reporte.dart     # Enum de estados con lógica de visibilidad para ciudadanos
│   │   └── reporte.dart            # Modelo de reporte con copyWith, toMap y fromMap (listo para Firestore)
│   ├── repositories/
│   │   ├── reporte_repository.dart       # Contrato abstracto del repositorio de reportes
│   │   ├── mock_reporte_repository.dart  # Implementación simulada en memoria con Stream reactivo
│   │   ├── auth_repository.dart          # Contrato abstracto de autenticación
│   │   └── mock_auth_repository.dart     # Implementación simulada de login municipal
│   └── services/
│       └── conectividad_service.dart     # Servicio abstracto y mock con switch interactivo
├── providers/
│   ├── reportes_provider.dart      # Gestión de reportes, filtrado reactivo y operaciones CRUD
│   ├── auth_provider.dart          # Estado de sesión municipal
│   └── conectividad_provider.dart  # Estado de conexión online/offline simulada
└── presentation/
    ├── screens/
    │   ├── inicio/
    │   │   └── inicio_screen.dart          # Pantalla 1: Selección de rol y switch dev de conectividad
    │   ├── ciudadano/
    │   │   ├── mapa_ciudadano_screen.dart  # Pantalla 2: Mapa OpenStreetMap con marcadores aprobados
    │   │   ├── detalle_reporte_sheet.dart  # Pantalla 3: BottomSheet de solo lectura del reporte
    │   │   ├── nuevo_reporte_screen.dart   # Pantalla 4: Formulario de reporte con foto y mini mapa
    │   │   └── confirmacion_envio_screen.dart # Pantalla 5: Confirmación Variante A (Online) / Variante B (Offline)
    │   └── municipal/
    │       ├── login_municipal_screen.dart # Pantalla 6: Inicio de sesión municipal con credenciales demo
    │       ├── panel_municipal_screen.dart # Pantalla 7: Pestañas Pendientes / Aprobados / Rechazados
    │       ├── revision_reporte_screen.dart# Pantalla 8: Revisión de pendientes (Aprobar o Rechazar)
    │       └── gestion_reporte_screen.dart # Pantalla 9: Gestión de aprobados y eliminación condicional
    └── widgets/
        ├── primary_button.dart     # Botón primario accesible (>=48px alto) con soporte de carga
        ├── secondary_button.dart   # Botón secundario tipo Outlined accesible
        ├── estado_chip.dart        # Chip indicador con punto de color según el estado
        ├── categoria_chip.dart     # Chip interactivo con ícono descriptivo
        ├── reporte_card.dart       # Tarjeta para listados municipales con miniatura
        ├── estado_legend.dart      # Leyenda flotante de estados para el mapa
        ├── empty_state_view.dart   # Vista para listados vacíos
        └── error_banner.dart       # Banner accesible de mensajes de error
```

---

## 🔑 Credenciales Simuladas del Panel Municipal

Para iniciar sesión en el **Panel Municipal** (`/login-muni`):

| Campo | Valor |
| :--- | :--- |
| **Correo electrónico** | `muni@demo.com` |
| **Contraseña** | `123456` |

*Si se ingresa cualquier otra combinación, la interfaz mostrará el mensaje de error accesible: `"Correo o contraseña incorrectos"`.*

---

## 🗺️ Cómo Cambiar el Centro del Mapa

El centro del mapa está centralizado en una única constante de fácil modificación:

- **Archivo**: `lib/core/constants/app_constants.dart`
- **Líneas**: 13 - 15

```dart
// Modifica estas coordenadas para centrar el mapa en tu ciudad o barrio preferido:
static const LatLng centroInicialMapa = LatLng(-16.409047, -71.537451); // Plaza de Armas de Arequipa (por defecto)
static const double zoomInicialMapa = 15.0;
```

**Ejemplos de centros alternativos:**
- **Lima (Plaza Mayor)**: `LatLng(-12.046374, -77.042793)`
- **Bogotá (Plaza de Bolívar)**: `LatLng(4.598056, -74.075833)`
- **Santiago de Chile**: `LatLng(-33.4372, -70.6506)`

Los reportes simulados semilla en `MockReporteRepository` se generan con offsets relativos automáticos alrededor de este centro, por lo que al cambiar la constante, los marcadores se reubicarán coherentemente alrededor de la nueva ubicación.

---

## 📋 Lista de Puntos `// TODO(firebase):` para la Fase 2

La arquitectura de la app está diseñada para que en la **Fase 2** no se requiera alterar ninguna pantalla de la interfaz, reemplazando únicamente las implementaciones de repositorio:

1. **`lib/core/constants/app_constants.dart`**:
   - `// TODO(firebase): Reemplazar credenciales estáticas por Firebase Authentication`
2. **`lib/data/models/reporte.dart`**:
   - `// TODO(firebase): Mapeo directo para colecciones en Cloud Firestore` en el método `toMap()`
   - `// TODO(firebase): Deserialización de DocumentSnapshot de Cloud Firestore` en la factoría `fromMap()`
3. **`lib/data/repositories/reporte_repository.dart`**:
   - Comentario de guía arquitectónica para la futura implementación `FirestoreReporteRepository`.
4. **`lib/data/repositories/mock_reporte_repository.dart`**:
   - `// TODO(firebase): Reemplazar esta implementación por FirestoreReporteRepository utilizando FirebaseFirestore.instance.collection('reportes')`
5. **`lib/data/repositories/auth_repository.dart`**:
   - `// TODO(firebase): Reemplazar por FirebaseAuthRepository en Fase 2.`
6. **`lib/data/repositories/mock_auth_repository.dart`**:
   - `// TODO(firebase): Reemplazar por FirebaseAuth.instance.signInWithEmailAndPassword`
7. **`lib/main.dart`**:
   - `// TODO(firebase): Reemplazar MockReporteRepository por FirestoreReporteRepository`
   - `// TODO(firebase): Reemplazar MockAuthRepository por FirebaseAuthRepository`

---

## 🔄 Flujo Completo Demostrable

1. **Pantalla de Inicio (`/`)**:
   - Elegir "Soy ciudadano" o "Soy municipalidad".
   - Conmutar el **interruptor discreto de desarrollo** ("Conexión: Online" / "Conexión: Offline") para probar la confirmación de envío.
2. **Panel Ciudadano**:
   - Ver el **Mapa interactivo** a pantalla completa con teselas de OpenStreetMap y marcadores con colores según estado (*solo se muestran los reportes aprobados*).
   - Filtrar marcadores con los chips: *Todos, En revisión, En atención, Resuelto*.
   - Tocar un marcador para abrir el **Bottom Sheet de detalle** (solo lectura).
   - Tocar el botón flotante **`+ Reportar`** para abrir el formulario:
     - Selección de categoría con chips e íconos.
     - Descripción con contador de 300 caracteres.
     - Selección de foto (cámara o galería) con vista previa obligatoria.
     - Mini mapa con pin ajustable y botón "Mi ubicación".
     - Al presionar **Enviar reporte**:
       - Si la conexión simulada está encendida -> **Variante A** ("¡Reporte enviado!").
       - Si la conexión simulada está apagada -> **Variante B** ("Reporte guardado en tu teléfono" con nube tachada).
       - El reporte nace en estado **"Pendiente"** y **NO** aparece en el mapa ciudadano.
3. **Panel Municipal**:
   - Desde Inicio, presionar "Soy municipalidad" e iniciar sesión con `muni@demo.com` / `123456`.
   - En el **Panel Principal**:
     - Pestaña **Pendientes**: Muestra el reporte recién enviado por el ciudadano con contador actualizado.
     - Al tocarlo, abre la **Revisión de reporte pendiente**: Foto grande, mapa y botones *Rechazar* (con diálogo modal) y *Aprobar*.
     - Al presionar **Aprobar**: El reporte pasa al estado "En revisión".
     - Al volver al **Mapa ciudadano**, el reporte recién aprobado **ya es visible inmediatamente** para todos los vecinos.
     - En la pestaña **Aprobados**, tocar el reporte para abrir la **Gestión de reporte aprobado**:
       - Cambiar su estado a "En atención" o a "Resuelto".
       - Si el estado no es "Resuelto", el botón **Eliminar reporte** permanece deshabilitado.
       - Al cambiar el estado a **"Resuelto"**, el botón de eliminación se habilita, permitiendo eliminar el reporte definitivamente tras un diálogo de confirmación.
