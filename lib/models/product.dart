class Articulo {
  final int id;
  final String nombre;

  Articulo({required this.id, required this.nombre});

  factory Articulo.fromJson(Map<String, dynamic> json) {
    return Articulo(
      id: json['id_articulo'] ?? 0,
      nombre: json['nombre_articulo'] ?? 'Sin Articulo',
    );
  }
}

class Talla {
  final int id;
  final String nombre;

  Talla({required this.id, required this.nombre});

  factory Talla.fromJson(Map<String, dynamic> json) {
    return Talla(
      id: json['id_talla'] ?? 0,
      nombre: json['nombre_talla'] ?? 'Sin Talla',
    );
  }
}

class Temporada {
  final int id;
  final String nombre;

  Temporada({required this.id, required this.nombre});

  factory Temporada.fromJson(Map<String, dynamic> json) {
    return Temporada(
      id: json['id_temporada'] ?? 0,
      nombre: json['nombre_temporada'] ?? 'Sin Temporada',
    );
  }
}

class Color {
  final int id;
  final String nombre;

  Color({required this.id, required this.nombre});

  factory Color.fromJson(Map<String, dynamic> json) {
    return Color(
      id: json['id_color'] ?? 0,
      nombre: json['nombre_color'] ?? 'Sin Color',
    );
  }
}

class Marca {
  final int id;
  final String nombre;

  Marca({required this.id, required this.nombre});

  factory Marca.fromJson(Map<String, dynamic> json) {
    return Marca(
      id: json['id_marca'] ?? 0,
      nombre: json['nombre_marca'] ?? 'Sin Marca',
    );
  }
}

class Producto {
  final int id;
  final String nombreSku;
  final String? descripcion; // <-- AÑADIDO
  final Articulo? articulo;
  final Talla? talla;
  final Temporada? temporada;
  final Color? color;
  final Marca? marca;

  Producto({
    required this.id,
    required this.nombreSku,
    this.descripcion, // <-- AÑADIDO
    this.articulo,
    this.talla,
    this.temporada,
    this.color,
    this.marca,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id_producto'] ?? 0,
      nombreSku: json['nombre_sku'] ?? 'SKU Desconocido',
      descripcion: json['descripcion'], // <-- AÑADIDO
      articulo: json['articulo'] != null ? Articulo.fromJson(json['articulo']) : null,
      talla: json['talla'] != null ? Talla.fromJson(json['talla']) : null,
      temporada: json['temporada'] != null ? Temporada.fromJson(json['temporada']) : null,
      color: json['color'] != null ? Color.fromJson(json['color']) : null,
      marca: json['marca'] != null ? Marca.fromJson(json['marca']) : null,
    );
  }
}
