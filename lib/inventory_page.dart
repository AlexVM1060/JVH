import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myapp/models/product.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  late final Future<List<Producto>> _future;

  @override
  void initState() {
    super.initState();
    _future = _getProducts();
  }

  Future<List<Producto>> _getProducts() async {
    // CORRECCIÓN: La consulta ahora pide explícitamente los datos de las tablas relacionadas.
    // La sintaxis `tabla_relacionada(id, nombre)` le dice a Supabase que traiga esos campos.
    final response = await Supabase.instance.client.from('producto').select('''
      id_producto,
      nombre_sku
    ''');

    final List<dynamic> data = response as List<dynamic>;
    return data
        .map((json) => Producto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Inventario')),
      child: FutureBuilder<List<Producto>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }

          if (snapshot.hasError) {
            // Imprime el error en la consola para más detalles de depuración
            print(snapshot.error);
            print(snapshot.stackTrace);
            return Center(child: Text('Ocurrió un error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Aún no hay productos.\n¡Añade uno desde la pantalla de inicio!',
                textAlign: TextAlign.center,
                style: TextStyle(color: CupertinoColors.secondaryLabel),
              ),
            );
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ProductListTile(
                title: Text(product.nombreSku),
                subtitle: Text(
                  '${product.articulo?.nombre ?? 'Artículo desc.'} - ${product.color?.nombre ?? 'Color desc.'} - ${product.marca?.nombre ?? 'Marca desc.'}',
                ),
                trailing: Text(
                  'Talla: ${product.talla?.nombre ?? 'N/A'}',
                  style: const TextStyle(color: CupertinoColors.secondaryLabel),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProductListTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  const ProductListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CupertinoColors.separator, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                  child: title,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  DefaultTextStyle(
                    style: CupertinoTheme.of(
                      context,
                    ).textTheme.tabLabelTextStyle.copyWith(fontSize: 14),
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 16), trailing!],
        ],
      ),
    );
  }
}
