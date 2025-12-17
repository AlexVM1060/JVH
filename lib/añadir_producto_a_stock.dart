import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Modelo simplificado para las opciones de los desplegables
class Option {
  final int id;
  final String name;
  Option({required this.id, required this.name});
}

class AddStockPage extends StatefulWidget {
  const AddStockPage({super.key});

  @override
  State<AddStockPage> createState() => _AddStockPageState();
}

class _AddStockPageState extends State<AddStockPage> {
  final _skuController = TextEditingController();
  // 1. Añadimos un controlador para el nuevo campo de descripción
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  List<Option> _articulos = [];
  List<Option> _tallas = [];
  List<Option> _temporadas = [];
  List<Option> _colores = [];
  List<Option> _marcas = [];

  int? _selectedArticuloId;
  int? _selectedTallaId;
  int? _selectedTemporadaId;
  int? _selectedColorId;
  int? _selectedMarcaId;

  String? _selectedArticuloName;
  String? _selectedTallaName;
  String? _selectedTemporadaName;
  String? _selectedColorName;
  String? _selectedMarcaName;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    setState(() => _isLoading = true);
    try {
      final responses = await Future.wait([
        Supabase.instance.client
            .from('articulo')
            .select('id_articulo, nombre_articulo'),
        Supabase.instance.client.from('talla').select('id_talla, nombre_talla'),
        Supabase.instance.client
            .from('temporada')
            .select('id_temporada, nombre_temporada'),
        Supabase.instance.client.from('color').select('id_color, nombre_color'),
        Supabase.instance.client.from('marca').select('id_marca, nombre_marca'),
      ]);

      if (!mounted) return;

      setState(() {
        _articulos = (responses[0] as List)
            .map(
              (item) => Option(
                id: item['id_articulo'],
                name: item['nombre_articulo'],
              ),
            )
            .toList();
        _tallas = (responses[1] as List)
            .map(
              (item) =>
                  Option(id: item['id_talla'], name: item['nombre_talla']),
            )
            .toList();
        _temporadas = (responses[2] as List)
            .map(
              (item) => Option(
                id: item['id_temporada'],
                name: item['nombre_temporada'],
              ),
            )
            .toList();
        _colores = (responses[3] as List)
            .map(
              (item) =>
                  Option(id: item['id_color'], name: item['nombre_color']),
            )
            .toList();
        _marcas = (responses[4] as List)
            .map(
              (item) =>
                  Option(id: item['id_marca'], name: item['nombre_marca']),
            )
            .toList();
      });
    } catch (e) {
      if (mounted) _showErrorDialog('Error al cargar las opciones: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addProduct() async {
    if (_skuController.text.isEmpty ||
        _selectedArticuloId == null ||
        _selectedTallaId == null ||
        _selectedTemporadaId == null ||
        _selectedColorId == null ||
        _selectedMarcaId == null) {
      _showErrorDialog('Por favor, completa todos los campos obligatorios.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.from('producto').insert({
        'nombre_sku': _skuController.text,
        // 2. Añadimos la descripción al objeto que se inserta en la base de datos
        // 'descripcion': _descriptionController.text,
        'id_articulo': _selectedArticuloId,
        'id_talla': _selectedTallaId,
        'id_temporada': _selectedTemporadaId,
        'id_color': _selectedColorId,
        'id_marca': _selectedMarcaId,
      });

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) _showErrorDialog('Error al guardar el producto: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Añadir Stock')),
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CupertinoTextField(
                    controller: _skuController,
                    placeholder: 'Ingrese el ID del Producto en la etiqueta',
                    padding: const EdgeInsets.all(12.0),
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton.filled(
                    onPressed: _isLoading ? null : _addProduct,
                    child: const Text('Buscar Producto'),
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

  // --- Widgets auxiliares (sin cambios) ---
  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerButton(
    String title,
    String? selectedName,
    List<Option> options,
    void Function(int, String) onSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: CupertinoButton(
        color: CupertinoColors.secondarySystemFill,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        onPressed: () => _showPicker(title, options, onSelected),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedName ?? 'Seleccionar $title',
              style: TextStyle(
                color: selectedName != null
                    ? CupertinoColors.label.resolveFrom(context)
                    : CupertinoColors.placeholderText.resolveFrom(context),
                fontWeight: FontWeight.normal,
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_down,
              size: 20,
              color: CupertinoColors.secondaryLabel,
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(
    String title,
    List<Option> options,
    void Function(int, String) onSelected,
  ) {
    if (options.isEmpty) return;
    int selectedIndex = 0;
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              color: CupertinoColors.secondarySystemBackground.resolveFrom(
                context,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancelar'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: const Text(
                      'Aceptar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      onSelected(
                        options[selectedIndex].id,
                        options[selectedIndex].name,
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 32,
                onSelectedItemChanged: (index) => selectedIndex = index,
                children: options
                    .map((option) => Center(child: Text(option.name)))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
