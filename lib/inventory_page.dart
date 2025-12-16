import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myapp/models/product.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late final Future<List<Producto>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _getProducts();
  }

  Future<List<Producto>> _getProducts() async {
    try {
      final response = await Supabase.instance.client.from('producto').select(
        '''
        id_producto,
        nombre_sku,
        articulo:id_articulo ( id_articulo, nombre_articulo ),
        talla:id_talla ( id_talla, nombre_talla ),
        temporada:id_temporada ( id_temporada, nombre_temporada ),
        color:id_color ( id_color, nombre_color ),
        marca:id_marca ( id_marca, nombre_marca )
      ''',
      );

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => Producto.fromJson(json)).toList();
    } catch (e) {
      print('Error al obtener productos: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Inventario de Productos'),
      ),
      child: FutureBuilder<List<Producto>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay productos en el inventario.'),
            );
          }

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => _buildProductCard(products[index]),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Producto product) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemGroupedBackground.resolveFrom(
          context,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.nombreSku,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          // 2. MOSTRAMOS la descripción si existe
          if (product.descripcion != null && product.descripcion!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                product.descripcion!,
                style: const TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
            ),
          const SizedBox(height: 4),
          _buildInfoRow(
            CupertinoIcons.tag_solid,
            'Artículo',
            product.articulo?.nombre,
          ),
          _buildInfoRow(
            CupertinoIcons.textformat_size,
            'Talla',
            product.talla?.nombre,
          ),
          _buildInfoRow(
            CupertinoIcons.calendar,
            'Temporada',
            product.temporada?.nombre,
          ),
          _buildInfoRow(
            CupertinoIcons.color_filter,
            'Color',
            product.color?.nombre,
          ),
          _buildInfoRow(
            CupertinoIcons.bookmark_solid,
            'Marca',
            product.marca?.nombre,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Row(
        children: [
          Icon(icon, color: CupertinoColors.secondaryLabel, size: 18),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
