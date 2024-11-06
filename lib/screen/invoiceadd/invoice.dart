import 'package:accord/controler/addinvoicecontroller.dart';
import 'package:accord/theme/teheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddInvoiceView extends GetView<AddInvoiceController> {
  // ignore: use_super_parameters
  const AddInvoiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Invoice'),
     
      ),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      constraints.maxWidth > ThemeManager.kDesktopBreakpoint
                          ? constraints.maxWidth * 0.1
                          : 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInvoiceHeader(constraints),
                    const SizedBox(height: 24),
                    _buildItemsSection(constraints),
                    const SizedBox(height: 24),
                    _buildTotalsSection(),
                    const SizedBox(height: 32),
                    _buildSaveButton(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceHeader(BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > ThemeManager.kDesktopBreakpoint;
    final isTablet = constraints.maxWidth > ThemeManager.kTabletBreakpoint;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Invoice Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: isDesktop
                      ? (constraints.maxWidth - 80) / 3
                      : isTablet
                          ? (constraints.maxWidth - 64) / 2
                          : constraints.maxWidth - 48,
                  child: TextFormField(
                    controller: controller.invoiceNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Invoice Number',
                      prefixIcon: Icon(Icons.receipt),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    enableInteractiveSelection: true,
                    autofocus: false,
                    validator: controller.validateInvoiceNumber,
                    onChanged: (value) =>
                        controller.invoiceNumber.value = value,
                  ),
                ),
                SizedBox(
                  width: isDesktop
                      ? (constraints.maxWidth - 80) / 3
                      : isTablet
                          ? (constraints.maxWidth - 64) / 2
                          : constraints.maxWidth - 48,
                  child: Obx(
                    () => TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      initialValue: DateFormat('dd/MM/yyyy')
                          .format(controller.date.value),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: Get.context!,
                          initialDate: controller.date.value,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          controller.date.value = picked;
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: isDesktop
                      ? (constraints.maxWidth - 80) / 3
                      : constraints.maxWidth - 48,
                  child: TextFormField(
                    controller: controller.partyNameController,
                    decoration: const InputDecoration(
                      labelText: 'Party Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: controller.validatePartyName,
                    onChanged: (value) => controller.partyName.value = value,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSection(BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > ThemeManager.kDesktopBreakpoint;
    final isTablet = constraints.maxWidth > ThemeManager.kTabletBreakpoint;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Items',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: controller.addItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: isDesktop
                      ? (constraints.maxWidth - 80) * 0.4
                      : isTablet
                          ? (constraints.maxWidth - 64) * 0.5
                          : constraints.maxWidth - 48,
                  child: TextFormField(
                    controller: controller.itemNameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
                      prefixIcon: Icon(Icons.inventory),
                    ),
                    // Added text input properties
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    enableInteractiveSelection: true,
                    autofocus: false,
                  ),
                ),
                SizedBox(
                  width: isDesktop
                      ? (constraints.maxWidth - 80) * 0.2
                      : isTablet
                          ? (constraints.maxWidth - 64) * 0.25
                          : (constraints.maxWidth - 48) * 0.5,
                  child: TextFormField(
                    controller: controller.quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    // Added proper keyboard configuration
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    textInputAction: TextInputAction.next,
                    enableInteractiveSelection: true,
                    autofocus: false,
                  ),
                ),
                SizedBox(
                  width: isDesktop
                      ? (constraints.maxWidth - 80) * 0.2
                      : isTablet
                          ? (constraints.maxWidth - 64) * 0.25
                          : (constraints.maxWidth - 48) * 0.5,
                  child: TextFormField(
                    controller: controller.rateController,
                    decoration: const InputDecoration(
                      labelText: 'Rate',
                      prefixIcon: Icon(Icons.currency_rupee),
                    ),
                    // Added proper keyboard configuration
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    textInputAction: TextInputAction.done,
                    enableInteractiveSelection: true,
                    autofocus: false,
                    onFieldSubmitted: (_) => controller.addItem(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Obx(() => controller.items.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items added yet',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    child: Theme(
                      data: Theme.of(Get.context!).copyWith(
                        cardTheme: Theme.of(Get.context!).cardTheme.copyWith(
                              elevation: 0,
                            ),
                      ),
                      child: Card(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            columns: const [
                              DataColumn(label: Text('S No')),
                              DataColumn(label: Text('Item Name')),
                              DataColumn(label: Text('Quantity')),
                              DataColumn(label: Text('Rate')),
                              DataColumn(label: Text('Value')),
                              DataColumn(label: Text('Action')),
                            ],
                            rows: controller.items.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return DataRow(
                                cells: [
                                  DataCell(Text('${index + 1}')),
                                  DataCell(Text(item.itemName)),
                                  DataCell(Text(item.quantity.toString())),
                                  DataCell(
                                      Text('₹${item.rate.toStringAsFixed(2)}')),
                                  DataCell(Text(
                                      '₹${item.value.toStringAsFixed(2)}')),
                                  DataCell(
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      color: Colors.red,
                                      onPressed: () =>
                                          controller.removeItem(index),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTotalItem(
                    'Total Items',
                    controller.items.length.toString(),
                    Icons.list_alt,
                  ),
                  _buildTotalItem(
                    'Total Quantity',
                    controller.calculateTotalQuantity().toString(),
                    Icons.shopping_cart,
                  ),
                  _buildTotalItem(
                    'Total Value',
                    '₹${controller.calculateTotalValue().toStringAsFixed(2)}',
                    Icons.currency_rupee,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalItem(String label, String value, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Obx(
      () => ElevatedButton.icon(
        onPressed: controller.isLoading.value ? null : controller.saveInvoice,
        icon: controller.isLoading.value
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.save),
        label: Text(
          controller.isLoading.value ? 'Saving...' : 'Save Invoice',
          style: const TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
    );
  }
}
