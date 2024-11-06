import 'package:accord/model/invoicemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewInvoiceController extends GetxController {
  final isLoading = false.obs;
  final invoices = <InvoiceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInvoices();
  }

  Future<void> loadInvoices() async {
    try {
      isLoading.value = true;
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('invoices')
          .orderBy('date', descending: true)
          .get();

      invoices.value = snapshot.docs
          .map((doc) => InvoiceModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load invoices',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteInvoice(InvoiceModel invoice) async {
    try {
      await FirebaseFirestore.instance
          .collection('invoices')
          .doc(invoice.id)
          .delete();

      invoices.remove(invoice);

      Get.snackbar(
        'Success',
        'Invoice deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete invoice',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    }
  }

  Future<void> clearInvoices() async {
    try {
      for (final invoice in invoices) {
        await FirebaseFirestore.instance
            .collection('invoices')
            .doc(invoice.id)
            .delete();
      }
      invoices.clear();

      Get.snackbar(
        'Success',
        'All invoices cleared successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to clear invoices',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    }
  }

  Future<void> updateInvoice(InvoiceModel invoice) async {
    try {
      await FirebaseFirestore.instance
          .collection('invoices')
          .doc(invoice.id)
          .update(invoice.toJson());

      int index = invoices.indexWhere((i) => i.id == invoice.id);
      invoices[index] = invoice;

      Get.snackbar(
        'Success',
        'Invoice updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update invoice',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    }
  }
}