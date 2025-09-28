# ProductApp

Aplicación Flutter – CRUD con API REST, Navegación y Control de Estado

## Descripción

ProductApp es una aplicación móvil desarrollada en Flutter que permite gestionar productos de una tienda en línea, conectándose a la API pública [DummyJSON](https://dummyjson.com/). La app implementa el ciclo completo de CRUD (Crear, Leer, Actualizar, Eliminar), navegación entre pantallas, control de estado, validación de formularios y una interfaz atractiva y responsive.

---

## Estructura del proyecto

```
lib/
  components/
    product_card.dart
    product_search_delegate.dart
    select_product_dialog.dart
  models/
    product_model.dart
  providers/
    product_provider.dart
  screens/
    product_list_page.dart
    product_detail_page.dart
    product_form_page.dart
    product_create_page.dart
  services/
    product_service.dart
  utils/
    api_constants.dart
    product_filter_sheet.dart
  main.dart
android/
ios/
linux/
macos/
web/
windows/
test/
coverage/
```

---

## Explicación de carpetas y archivos

### lib/
- **main.dart**  
  Punto de entrada de la app. Inicializa el tema y la pantalla principal ([ProductListPage](lib/screens/product_list_page.dart)).

#### components/
- **product_card.dart**  
  Widget visual para mostrar la información resumida de un producto en la lista.
- **product_search_delegate.dart**  
  Implementa el buscador de productos por nombre.
- **select_product_dialog.dart**  
  Diálogo para seleccionar productos a editar.

#### models/
- **product_model.dart**  
  Define la clase `Product` y sus submodelos (`Dimensions`, `Review`, `Meta`), representando la estructura de los datos recibidos de la API.

#### providers/
- **product_provider.dart**  
  Gestiona el estado global de los productos usando `ChangeNotifier`.

#### screens/
- **product_list_page.dart**  
  Pantalla principal con la lista de productos, buscador, filtros y navegación.  
  - Scroll infinito para cargar más productos al bajar.
  - Botón de búsqueda (lupa) en la esquina superior derecha para buscar productos por nombre.
  - AppBar inferior con opciones para editar, crear y filtrar productos.
  - Filtrado por precio y categoría.
- **product_detail_page.dart**  
  Muestra los detalles completos de un producto seleccionado.  
  - Botón flotante para eliminar el producto.
  - Al eliminar, regresa a la lista principal.
- **product_form_page.dart**  
  Formulario para editar productos existentes, con validaciones.
- **product_create_page.dart**  
  Formulario para crear nuevos productos, con validaciones.

#### services/
- **product_service.dart**  
  Encapsula la comunicación con la API REST ([DummyJSON](https://dummyjson.com/)):
  - Métodos para obtener, crear, editar y eliminar productos.
  - Métodos para buscar, filtrar y obtener categorías.

#### utils/
- **api_constants.dart**  
  Define las rutas y endpoints de la API REST.
- **product_filter_sheet.dart**  
  Widget para filtrar productos por precio y categoría.

---

## Librerías utilizadas

- **http**  
  Para realizar peticiones HTTP a la API REST.
- **provider**  
  Para la gestión de estado y actualización de la interfaz.
- **intl**  
  Para el formato de fechas.
- **flutter/material.dart**  
  Para la construcción de la interfaz de usuario.
- **flutter_test**  
  Para pruebas unitarias y de widgets.

---

## Funcionalidades principales

- **Pantalla de lista:**  
  Muestra todos los productos con scroll infinito.  
  Buscador por nombre en la esquina superior derecha.  
  AppBar inferior con opciones de editar, crear y filtrar productos.
- **Pantalla de detalle:**  
  Al seleccionar un producto, se muestra su información completa.  
  Botón flotante para eliminar el producto.
- **Pantalla de formulario:**  
  Permite crear o editar productos, con validaciones de campos obligatorios.
- **Filtrado:**  
  Filtra productos por precio y categoría desde la pantalla principal.
- **Buscador:**  
  Busca productos por nombre usando la lupa en la pantalla principal.

---

## API utilizada

- **DummyJSON**: [https://dummyjson.com/](https://dummyjson.com/)
  - Permite realizar operaciones CRUD sobre productos, categorías y más.
  - Endpoints principales usados:
    - `/products` (GET, POST)
    - `/products/{id}` (GET, PUT, DELETE)
    - `/products/search?q={query}` (GET)
    - `/products/categories` (GET)

---

## Instalación y ejecución

1. Clona el repositorio:
   ```sh
   git clone https://github.com/tuusuario/productapp.git
   cd productapp
   ```
2. Instala dependencias:
   ```sh
   flutter pub get
   ```
3. Ejecuta la app:
   ```sh
   flutter run
   ```

---

## Video demostrativo

[Enlace al video de demostración](https://tu-enlace-al-video.com)

---

## Licencia

TODOS LOS DERECHOS RESERVADOS, ESTA ES UNA MARCA REGISTRADA, PROHIBIDO SU USO SIN PREVIO AVISO O CONSENTIMIENTO ©.