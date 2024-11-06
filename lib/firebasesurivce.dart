import 'package:accord/model/invoicemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveInvoice(InvoiceModel invoice) async {
    await _firestore
        .collection('invoices')
        .doc(invoice.id)
        .set(invoice.toJson());
  }

  Future<void> updateInvoice(InvoiceModel invoice) async {
    await _firestore
        .collection('invoices')
        .doc(invoice.id)
        .update(invoice.toJson());
  }

  Future<void> deleteInvoice(String id) async {
    await _firestore.collection('invoices').doc(id).delete();
  }

  Future<List<InvoiceModel>> getInvoices() async {
    final QuerySnapshot snapshot = await _firestore
        .collection('invoices')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => InvoiceModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveItemSuggestion(String itemName) async {
    await _firestore.collection('items').doc(itemName).set({'name': itemName});
  }

  Future<List<String>> getItemSuggestions() async {
    final QuerySnapshot snapshot = await _firestore.collection('items').get();
    return snapshot.docs.map((doc) => doc['name'] as String).toList();
  }
}

// lib/app/utils/validators.dart
class Validators {
  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? number(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  static String? positiveNumber(String? value) {
    final numberError = number(value);
    if (numberError != null) {
      return numberError;
    }
    if (double.parse(value!) <= 0) {
      return 'Please enter a positive number';
    }
    return null;
  }
}