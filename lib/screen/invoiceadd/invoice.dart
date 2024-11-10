import 'package:accord/controler/addinvoicecontroller.dart';
import 'package:accord/theme/teheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddInvoiceView extends GetView<AddInvoiceController> {
  const AddInvoiceView({super.key});

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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    decoration: InputDecoration(
                      labelText: 'Invoice Number',
                      prefixIcon: const Icon(Icons.receipt),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
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
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy')
                            .format(controller.date.value),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Date',
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
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
                    decoration: InputDecoration(
                      labelText: 'Party Name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 16,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'Items',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: isDesktop
                            ? 300
                            : isTablet
                                ? 250
                                : 200,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Obx(
                        () => DropdownButton<String>(
                          value: controller.selectedItem.value,
                          items: controller.itemOptions.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: isDesktop
                                      ? 220
                                      : isTablet
                                          ? 170
                                          : 120,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        item,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      constraints: const BoxConstraints(
                                        minWidth: 24,
                                        maxWidth: 24,
                                      ),
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 20,
                                      ),
                                      color: Colors.red,
                                      onPressed: () =>
                                          controller.removeItemOption(item),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedItem.value = value;
                            }
                          },
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          dropdownColor: Colors.white,
                          elevation: 3,
                          underline: const SizedBox(),
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: false,
                          hint: const Text('Select Item'),
                        ),
                      ),
                    ),
                    if (isTablet || isDesktop) ...[
                      // Only show Create Item button for tablet and desktop
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.dialog(
                            AlertDialog(
                              title: const Text('Add New Item'),
                              content: TextField(
                                controller: controller.textEditingController,
                                decoration: InputDecoration(
                                  hintText: 'Enter new item name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final newItem = controller
                                        .textEditingController.text
                                        .trim();
                                    if (newItem.isNotEmpty) {
                                      controller.addItemOption(newItem);
                                      controller.textEditingController.clear();
                                      Get.back();
                                    }
                                  },
                                  child: const Text('Add'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text('Create Item'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ],
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
                  child: _buildCustomDropdown(constraints),
                ),
                SizedBox(
                  width: isDesktop
                      ? (constraints.maxWidth - 80) * 0.2
                      : isTablet
                          ? (constraints.maxWidth - 64) * 0.25
                          : (constraints.maxWidth - 48) * 0.5,
                  child: TextFormField(
                    controller: controller.quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      prefixIcon: const Icon(Icons.numbers),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    textInputAction: TextInputAction.next,
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
                    decoration: InputDecoration(
                      labelText: 'Rate',
                      prefixIcon: const Icon(Icons.currency_rupee),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => controller.addItem(),
                  ),
                ),
                SizedBox(
                  width: isDesktop
                      ? (constraints.maxWidth - 80) * 0.2
                      : constraints.maxWidth - 48,
                  child: ElevatedButton.icon(
                    onPressed: controller.addItem,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Obx(
              () => controller.items.isEmpty
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
                  : Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
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
                                DataCell(
                                    Text('₹${item.value.toStringAsFixed(2)}')),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCustomDropdown(BoxConstraints constraints) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(
        () => DropdownButtonFormField<String>(
          value: controller.selectedItem.value,
          items: controller.itemOptions.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.selectedItem.value = value;
            }
          },
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.inventory),
            suffixIcon: controller.selectedItem.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.selectedItem.value =
                          controller.itemOptions.first;
                    },
                  )
                : null,
          ),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          dropdownColor: Colors.white,
          elevation: 3,
          icon: const Icon(Icons.arrow_drop_down),
          isExpanded: true,
          hint: const Text('Select Item'),
        ),
      ),
    );
  }

  Widget _buildTotalsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 24, color: Colors.blue),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
