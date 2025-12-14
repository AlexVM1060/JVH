import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;

  Future<void> _addProduct() async {
    if (_nameController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _priceController.text.isEmpty) {
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
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text,
        'quantity': int.tryParse(_quantityController.text) ?? 0,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'createdAt': FieldValue.serverTimestamp(),
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
                    controller: _nameController,
                    placeholder: 'Nombre del Producto',
                    padding: const EdgeInsets.all(12.0),
                  ),
                  const SizedBox(height: 16),
                  CupertinoTextField(
                    controller: _quantityController,
                    placeholder: 'Cantidad',
                    keyboardType: TextInputType.number,
                    padding: const EdgeInsets.all(12.0),
                  ),
                  const SizedBox(height: 16),
                  CupertinoTextField(
                    controller: _priceController,
                    placeholder: 'Precio',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    padding: const EdgeInsets.all(12.0),
                  ),
                  const SizedBox(height: 32),
                  CupertinoButton.filled(
                    onPressed: _isLoading ? null : _addProduct,
                    child: const Text('Guardar Producto'),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Center(
                child: CupertinoActivityIndicator(radius: 20),
              ),
          ],
        ),
      ),
    );
  }
}
