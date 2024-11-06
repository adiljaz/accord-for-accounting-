import 'package:accord/model/invoicemodel.dart';
import 'package:accord/controler/viewinvoicecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InvoiceEditPage extends StatefulWidget {
  final InvoiceModel invoice;

  // ignore: use_key_in_widget_constructors
  const InvoiceEditPage({required this.invoice});

  @override
  // ignore: library_private_types_in_public_api
  _InvoiceEditPageState createState() => _InvoiceEditPageState();
}

class _InvoiceEditPageState extends State<InvoiceEditPage> {
  late TextEditingController _invoiceNumberController;
  late TextEditingController _partyNameController;
  late TextEditingController _totalValueController;
  late DateTime _invoiceDate;
  final _invoiceItemsController = <TextEditingController>[];

  @override
  void initState() {
    super.initState();
    _invoiceNumberController = TextEditingController(text: widget.invoice.invoiceNumber.toString());
    _partyNameController = TextEditingController(text: widget.invoice.partyName);
    _totalValueController = TextEditingController(text: widget.invoice.totalValue.toString());
    _invoiceDate = widget.invoice.date;

    // Initialize the invoice items controllers
    _invoiceItemsController.clear();
    for (final item in widget.invoice.items) {
      final itemNameController = TextEditingController(text: item.itemName);
      final itemQuantityController = TextEditingController(text: item.quantity.toString());
      final itemRateController = TextEditingController(text: item.rate.toString());
      final itemValueController = TextEditingController(text: item.value.toString());
      _invoiceItemsController.add(itemNameController);
      _invoiceItemsController.add(itemQuantityController);
      _invoiceItemsController.add(itemRateController);
      _invoiceItemsController.add(itemValueController);
    }
  }

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _partyNameController.dispose();
    _totalValueController.dispose();
    for (final controller in _invoiceItemsController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Invoice'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _invoiceNumberController,
              decoration: const InputDecoration(
                labelText: 'Invoice Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _partyNameController,
              decoration: const InputDecoration(
                labelText: 'Party Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _totalValueController,
              decoration: const InputDecoration(
                labelText: 'Total Value',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _invoiceDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null && pickedDate != _invoiceDate) {
                  setState(() {
                    _invoiceDate = pickedDate;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: TextEditingController(
                    text: DateFormat('yyyy-MM-dd').format(_invoiceDate),
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Invoice Date',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: widget.invoice.items.length,
                itemBuilder: (context, index) {
                  final itemIndex = index * 4;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Item ${index + 1}'),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _invoiceItemsController[itemIndex],
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _invoiceItemsController[itemIndex + 1],
                              decoration: const InputDecoration(
                                labelText: 'Quantity',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: TextField(
                              controller: _invoiceItemsController[itemIndex + 2],
                              decoration: const InputDecoration(
                                labelText: 'Rate',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: TextField(
                              controller: _invoiceItemsController[itemIndex + 3],
                              decoration: const InputDecoration(
                                labelText: 'Value',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final updatedInvoice = InvoiceModel(
                  id: widget.invoice.id,
                  invoiceNumber: _invoiceNumberController.text.trim(),
                  partyName: _partyNameController.text.trim(),
                  date: _invoiceDate,
                  totalValue: double.parse(_totalValueController.text.trim()),
                  items: List.generate(
                    widget.invoice.items.length,
                    (index) => InvoiceItem(
                      itemName: _invoiceItemsController[index * 4].text.trim(),
                      quantity: double.parse(_invoiceItemsController[index * 4 + 1].text.trim()),
                      rate: double.parse(_invoiceItemsController[index * 4 + 2].text.trim()),
                      value: double.parse(_invoiceItemsController[index * 4 + 3].text.trim()),
                    ),
                  ),
                  totalQuantity: widget.invoice.totalQuantity,
                );

                Get.find<ViewInvoiceController>().updateInvoice(updatedInvoice);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Update Invoice'),
            ),
          ],
        ),
      ),
    );
  }
}