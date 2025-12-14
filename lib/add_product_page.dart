import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _skuController = TextEditingController();
  final _articleIdController = TextEditingController();
  bool _isLoading = false;

  Future<void> _addProduct() async {
    if (_skuController.text.isEmpty) {
      // Muestra un error si los campos están vacíos
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Campos incompletos'),
          content: const Text('Por favor, rellena todos los campos.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Supabase.instance.client.from('producto').insert({
        'nombre_sku': _skuController.text,
        'id_articulo': null,
        // int.tryParse(_articleIdController.text),
        // Por ahora, los demás campos los dejaremos en null
        'id_talla': null,
        'id_temporada': null,
        'id_color': null,
        'id_marca': null,
      });

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text('Ocurrió un error al guardar el producto: $e'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Añadir Producto'),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CupertinoTextField(
                    controller: _skuController,
                    placeholder: 'Nombre SKU',
                    padding: const EdgeInsets.all(12.0),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 32),
                  CupertinoButton.filled(
                    onPressed: _isLoading ? null : _addProduct,
                    child: const Text('Guardar Producto'),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Center(child: CupertinoActivityIndicator(radius: 20)),
          ],
        ),
      ),
    );
  }
}
