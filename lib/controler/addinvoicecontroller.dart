import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:accord/model/invoicemodel.dart';

class AddInvoiceController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final invoiceNumber = ''.obs;
  final invoiceNumberController = TextEditingController();
  final partyName = ''.obs;
  final partyNameController = TextEditingController();
  final date = DateTime.now().obs;
  final items = <InvoiceItem>[].obs;
  final isLoading = false.obs;
  final selectedItem = 'Item 1'.obs;
  final itemOptions = ['Item 1', 'Item 2', 'Item 3', 'Item 4'].obs; 
  final textEditingController = TextEditingController();

  final quantityController = TextEditingController();
  final rateController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers with empty values
    invoiceNumberController.addListener(() {
      invoiceNumber.value = invoiceNumberController.text;
    });
    partyNameController.addListener(() {
      partyName.value = partyNameController.text;
    });
  }

  String? validateInvoiceNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Invoice number is required';
    }
    return null;
  }

  String? validatePartyName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Party name is required';
    }
    if (value.trim().length < 3) {
      return 'Party name must be at least 3 characters';
    }
    return null;
  }

  void addItem() {
    if (quantityController.text.isEmpty || rateController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all item details',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.isDarkMode ? Colors.red[900] : Colors.red[100],
        colorText: Get.isDarkMode ? Colors.white : Colors.black,
      );
      return;
    }

    try {
      final quantity = double.parse(quantityController.text);
      final rate = double.parse(rateController.text);

      if (quantity <= 0 || rate <= 0) {
        throw const FormatException('Values must be greater than 0');
      }

      final newItem = InvoiceItem(
        itemName: selectedItem.value,
        quantity: quantity,
        rate: rate,
        value: quantity * rate,
      );

      items.add(newItem);

      // Clear input fields after adding item
      quantityController.clear();
      rateController.clear();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Please enter valid numbers for quantity and rate',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.isDarkMode ? Colors.red[900] : Colors.red[100],
        colorText: Get.isDarkMode ? Colors.white : Colors.black,
      );
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
    }
  }

  double calculateTotalQuantity() {
    // ignore: avoid_types_as_parameter_names
    return items.fold(0.0, (sum, item) => sum + item.quantity);
  }

  double calculateTotalValue() {
    // ignore: avoid_types_as_parameter_names
    return items.fold(0.0, (sum, item) => sum + item.value);
  }

  Future<void> saveInvoice() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        'Error',
        'Please fill all required fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.isDarkMode ? Colors.red[900] : Colors.red[100],
        colorText: Get.isDarkMode ? Colors.white : Colors.black,
      );
      return;
    }

    if (items.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one item',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.isDarkMode ? Colors.red[900] : Colors.red[100],
        colorText: Get.isDarkMode ? Colors.white : Colors.black,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Calculate totals
      final totalQty = calculateTotalQuantity();
      final totalVal = calculateTotalValue();

      final invoice = InvoiceModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        invoiceNumber: invoiceNumberController.text.trim(),
        date: date.value,
        partyName: partyNameController.text.trim(),
        items: List<InvoiceItem>.from(items),
        totalQuantity: totalQty,
        totalValue: totalVal,
      );

      await FirebaseFirestore.instance
          .collection('invoices')
          .doc(invoice.id)
          .set(invoice.toJson());

      Get.snackbar(
        'Success',
        'Invoice saved successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.isDarkMode ? Colors.green[900] : Colors.green[100],
        colorText: Get.isDarkMode ? Colors.white : Colors.black,
      );

      clearForm();
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save invoice: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.isDarkMode ? Colors.red[900] : Colors.red[100],
        colorText: Get.isDarkMode ? Colors.white : Colors.black,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    formKey.currentState?.reset();
    invoiceNumberController.clear();
    partyNameController.clear();
    date.value = DateTime.now();
    items.clear();
    quantityController.clear();
    rateController.clear();
  }

  @override
  void onClose() {
    invoiceNumberController.dispose();
    partyNameController.dispose();
    quantityController.dispose();
    rateController.dispose();
    super.onClose();
  }

  void initializeForEdit(InvoiceModel invoice) {
    invoiceNumberController.text = invoice.invoiceNumber;
    partyNameController.text = invoice.partyName;
    date.value = invoice.date;
    items.value = List<InvoiceItem>.from(invoice.items);
  }

  void addItemOption(String newItem) {
    if (!itemOptions.contains(newItem)) {
      itemOptions.add(newItem);
      selectedItem.value = newItem;
      // Save the new item option to Firebase
      _saveItemOptionsToFirebase();
    }
  }

  void removeItemOption(String item) {
    if (itemOptions.contains(item)) {
      itemOptions.remove(item);
      if (selectedItem.value == item) {
        selectedItem.value = itemOptions.isNotEmpty ? itemOptions.first : '';
      }
      // Remove the item option from Firebase
      _removeItemOptionFromFirebase(item);
    }
  }

  Future<void> _saveItemOptionsToFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collection('item_options')
          .doc('options')
          .set({'options': itemOptions});
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save item options: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.isDarkMode ? Colors.red[900] : Colors.red[100],
        colorText: Get.isDarkMode ? Colors.white : Colors.black,
      );
    }
  }

  Future<void> _removeItemOptionFromFirebase(String item) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('item_options')
          .doc('options')
          .get();
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data['options'] is List<dynamic>) {
          final options = List<String>.from(data['options']);
          options.remove(item);
          await FirebaseFirestore.instance
              .collection('item_options')
              .doc('options')
              .update({'options': options});
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove item option: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.isDarkMode ? Colors.red[900] : Colors.red[100],
        colorText: Get.isDarkMode ? Colors.white : Colors.black,
      );
    }
  }

  Future<void> loadItemOptions() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('item_options')
          .doc('options')
          .get();
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data['options'] is List<dynamic>) {
          itemOptions.value = List<String>.from(data['options']);
          selectedItem.value = itemOptions.isNotEmpty ? itemOptions.first : '';
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load item options: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.isDarkMode ? Colors.red[900] : Colors.red[100],
        colorText: Get.isDarkMode ? Colors.white : Colors.black,
      );
    }
  }

  @override
  void onReady() {
    super.onReady();
    loadItemOptions();
  }
}