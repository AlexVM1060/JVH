
# Blueprint de la Aplicación

## Visión General

Esta aplicación de inventario permite a los usuarios gestionar una lista de productos. Las características principales incluyen ver la lista de productos y añadir nuevos productos al inventario. La aplicación utiliza Supabase como backend para el almacenamiento de datos.

## Diseño y Estilo

La aplicación sigue un diseño limpio y funcional, utilizando los widgets de Cupertino (iOS-style) de Flutter para una apariencia nativa en dispositivos Apple.

## Arquitectura y Estructura de Datos

*   **Modelo de Datos (`lib/models/product.dart`):** Se ha implementado una estructura de clases en Dart que refleja el esquema relacional de la base de datos. La clase principal `Producto` contiene objetos anidados para sus relaciones (`Articulo`, `Talla`, `Color`, etc.), facilitando un manejo de datos tipado y seguro.
*   **Backend con Supabase:** Toda la gestión de datos se realiza a través de Supabase, aprovechando su capacidad para realizar consultas anidadas y obtener datos relacionales de manera eficiente.

## Características Implementadas

*   **Visualización de Inventario Relacional:** La aplicación muestra una lista de productos, obteniendo no solo los datos de la tabla `producto`, sino también los nombres y detalles de las tablas relacionadas (`articulo`, `color`, `marca`, `talla`) en una sola consulta.
*   **Añadir Producto Simplificado:** Permite a los usuarios añadir nuevos productos al inventario a través de un formulario que, por ahora, solicita los datos esenciales (`nombre_sku` y `id_articulo`).
*   **Navegación con Barra Inferior:** Navegación fluida entre las páginas de "Inicio", "Inventario" y "Ajustes".

## Plan Actual

**¡Adaptación a la nueva estructura de datos completada!**

La aplicación ha sido actualizada para funcionar con el esquema de base de datos relacional proporcionado por el usuario. Se ha refactorizado la forma en que se leen y se escriben los datos para soportar las relaciones entre tablas.

### Pasos Realizados:

1.  **Creado un Modelo de Datos:** Se ha definido un modelo de clases en `lib/models/product.dart` para manejar la estructura de `producto` y sus tablas relacionadas.
2.  **Actualizada la Consulta de Inventario:** Se ha modificado `lib/inventory_page.dart` para usar una consulta anidada de Supabase (`select('*, articulo(*), color(*), ...')`), obteniendo todos los datos necesarios de forma eficiente.
3.  **Ajustada la Interfaz de Usuario:** La vista de inventario ahora muestra los datos relacionales, como el nombre del artículo y el color, en lugar de solo IDs.
4.  **Modificada la Página de Añadir Producto:** El formulario en `lib/add_product_page.dart` ha sido adaptado para permitir la creación de un nuevo `producto` con su SKU y el ID de artículo asociado.
