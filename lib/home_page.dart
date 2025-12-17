import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/a%C3%B1adir_producto_a_stock.dart';
import 'package:myapp/add_product_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        middle: Text(
          'Dashboard',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSummarySection(context),
            const SizedBox(height: 24),
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
        return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen del Inventario',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: const [
            Expanded(
              child: SummaryCard(
                title: 'Total de Productos',
                value: '1,240',
                icon: CupertinoIcons.archivebox_fill,
                color: CupertinoColors.activeBlue,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: SummaryCard(
                title: 'Alertas de Stock',
                value: '15',
                icon: CupertinoIcons.exclamationmark_triangle_fill,
                color: CupertinoColors.systemOrange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: CupertinoTheme.of(
            context,
          ).textTheme.navTitleTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ActionCard(
              title: 'Añadir Producto',
              icon: CupertinoIcons.plus_app_fill,
              color: CupertinoColors.systemGreen,
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) => const AddProductPage()),
                );
              },
            ),
            ActionCard(
              title: 'Añadir Stock',
              icon: CupertinoIcons.plus_app_fill,
              color: CupertinoColors.systemBlue,
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) => const AddStockPage()),
                );
              },
            ),
            const ActionCard(
              title: 'Buscar',
              icon: CupertinoIcons.search,
              color: CupertinoColors.systemIndigo,
            ),
            const ActionCard(
              title: 'Escanear Código',
              icon: CupertinoIcons.barcode_viewfinder,
              color: CupertinoColors.systemPink,
            ),
            const ActionCard(
              title: 'Ver Reportes',
              icon: CupertinoIcons.chart_bar_square_fill,
              color: CupertinoColors.systemPurple,
            ),
          ],
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(color: color, fontSize: 32),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
