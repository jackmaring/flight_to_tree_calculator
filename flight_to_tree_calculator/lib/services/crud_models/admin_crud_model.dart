import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:sustainibility_project/providers/admin.dart';
import 'package:sustainibility_project/services/api.dart';

class AdminCRUDModel extends ChangeNotifier {
  Api _api = Api('/admin_entries');

  // get admin data entries
  Future<List<AdminDataTableEntry>> fetchAdminDataEntries() async {
    List<AdminDataTableEntry> adminDataEntries;
    var result = await _api.getDataCollection();
    adminDataEntries = result.documents
        .map((doc) => AdminDataTableEntry.fromMap(doc.data))
        .toList();
    return adminDataEntries;
  }

  Stream<List<AdminDataTableEntry>> getAdminEntries() {
    return _api.streamDataCollection().map((snapshot) => snapshot.documents
        .map((document) => AdminDataTableEntry.fromMap(document.data))
        .toList());
  }

  // stream admin data entries
  Stream<QuerySnapshot> fetchAdminDataEntriesAsStream() {
    return _api.streamDataCollection();
  }

  // get admin data entry by id
  Future<AdminDataTableEntry> getAdminDataEntriesById(String id) async {
    var doc = await _api.getDocumentById(id);
    return AdminDataTableEntry.fromMap(doc.data);
  }

  // remove admin data entry
  Future removeAdminDataEntry(String id) async {
    await _api.removeDocument(id);
    return;
  }

  // update admin data entry
  // Future updateAdminDataEntry(AdminDataTableEntry data, String id) async {
  //   await _api.updateDocument(data.toMap(docRef.documentID), id);
  //   return;
  // }

  // add admin data entry
  Future addAdminDataEntry(AdminDataTableEntry data) async {
    await _api
        .addDocument(data.toMap())
        .then((result) => {
              data.id = result.documentID,
              result.setData({'id': data.id}, merge: true)
            })
        .catchError((e) => {print(e.message)});
  }
}
