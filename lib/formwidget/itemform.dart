import 'package:accord/controler/addinvoicecontroller.dart';
import 'package:accord/model/invoicemodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


// ignore: must_be_immutable
class ItemForm extends GetView<AddInvoiceController> {
  final formKey = GlobalKey<FormState>();
  var itemNameController = TextEditingController();
  final quantityController = TextEditingController();
  final rateController = TextEditingController();

  ItemForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Autocomplete<String>(
          //   optionsBuilder: (TextEditingValue textEditingValue) {
          //     if (textEditingValue.text == '') {
          //       return const Iterable<String>.empty();
          //     }
          //     return controller.suggestions.where((String option) {
          //       return option.toLowerCase()
          //           .contains(textEditingValue.text.toLowerCase());
          //     });
          //   },
          //   onSelected: (String selection) {
          //     itemNameController.text = selection;
          //   },
          //   fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          //     itemNameController = controller;
          //     return TextFormField(
          //       controller: controller,
          //       focusNode: focusNode,
          //       decoration: InputDecoration(
          //         labelText: 'Item Name',
          //         border: OutlineInputBorder(),
          //       ),
          //       validator: (value) =>
          //           value?.isEmpty ?? true ? 'Required field' : null,
          //     );
          //   },
          // ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required field';
                    if (double.tryParse(value!) == null) return 'Invalid number';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: rateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Rate',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required field';
                    if (double.tryParse(value!) == null) return 'Invalid number';
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addItem,
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }

  void _addItem() {
    if (formKey.currentState!.validate()) {
      final quantity = double.parse(quantityController.text);
      final rate = double.parse(rateController.text);
      
      // ignore: unused_local_variable
      final item = InvoiceItem(
        itemName: itemNameController.text,
        quantity: quantity,
        rate: rate,
        value: quantity * rate,
      );

      controller.addItem(); 
      
      // Clear form
      itemNameController.clear();
      quantityController.clear();
      rateController.clear();
    }
  }
}

