import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:accord/model/invoicemodel.dart';

class InvoiceDetailsPage extends StatelessWidget {
  final InvoiceModel invoice;

  const InvoiceDetailsPage({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Colors.black,
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 1024;
            final isTablet = constraints.maxWidth > 768 && constraints.maxWidth <= 1024;
            final isMobile = constraints.maxWidth <= 768;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildInvoiceHeader(),
                    const SizedBox(height: 32),
                    _buildInvoiceItemsTable(constraints, isDesktop, isMobile, isTablet),
                    const SizedBox(height: 32),
                    _buildInvoiceSummary(constraints, isDesktop, isTablet, isMobile),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Invoice Details'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildInvoiceHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Invoice #${invoice.invoiceNumber}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Party Name: ${invoice.partyName}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Date: ${DateFormat('dd-MM-yyyy').format(invoice.date)}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceItemsTable(BoxConstraints constraints, bool isDesktop, bool isMobile, bool isTablet) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isDesktop
            ? constraints.maxWidth * 0.8
            : (isTablet ? constraints.maxWidth * 0.9 : constraints.maxWidth - 48),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Items',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 24,
                  // ignore: deprecated_member_use
                  dataRowHeight: 64,
                  headingRowColor: WidgetStateProperty.all(Colors.grey[800]),
                  columns: const [
                    DataColumn(label: Text('S No', style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text('Item', style: TextStyle(color:Colors.white))), 
                    DataColumn(label: Text('Qty', style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text('Rate', style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text('Value', style: TextStyle(color: Colors.white))),
                    DataColumn(label: Text('Total', style: TextStyle(color: Colors.white))),
                  ],
                  rows: invoice.items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(Text('${index + 1}', style: const TextStyle(color: Color.fromARGB(255, 4, 4, 4)))),
                        DataCell(Text(item.itemName, style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)))),
                        DataCell(Text(item.quantity.toString(), style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)))),
                        DataCell(Text('₹${item.rate.toStringAsFixed(2)}', style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)))),
                        DataCell(Text('₹${item.value.toStringAsFixed(2)}', style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)))),
                        DataCell(Text('₹${(item.quantity * item.rate).toStringAsFixed(2)}', style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)))),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceSummary(BoxConstraints constraints, bool isDesktop, bool isTablet, bool isMobile) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isDesktop
            ? constraints.maxWidth * 0.8
            : (isTablet ? constraints.maxWidth * 0.9 : constraints.maxWidth - 48),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildSummaryItem(
                    'Total Items',
                    invoice.items.length.toString(),
                    Icons.list_alt,
                  ),
                  _buildSummaryItem(
                    'Total Quantity',
                    invoice.totalQuantity.toStringAsFixed(0),
                    Icons.shopping_cart,
                  ),
                  _buildSummaryItem(
                    'Total Value',
                    '₹${NumberFormat('#,##,###.##').format(invoice.totalValue)}',
                    Icons.currency_rupee,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Card(
      elevation: 0,
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 24, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }
}