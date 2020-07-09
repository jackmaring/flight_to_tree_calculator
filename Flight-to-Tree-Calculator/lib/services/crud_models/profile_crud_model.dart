import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:sustainibility_project/providers/profile.dart';
import 'package:sustainibility_project/services/api.dart';

class ProfileCRUDModel extends ChangeNotifier {
  Api _api = Api('/profile_entries');

  List<ProfileDataTableEntry> profileDataEntries;

  // get profile data entries
  Future<List<ProfileDataTableEntry>> fetchProfileDataEntries() async {
    var result = await _api.getDataCollection();
    profileDataEntries = result.documents
        .map((doc) => ProfileDataTableEntry.fromMap(doc.data))
        .toList();
    return profileDataEntries;
  }

  Stream<List<ProfileDataTableEntry>> getProfileEntries() {
    return _api.streamDataCollection().map((snapshot) => snapshot.documents
        .map((document) => ProfileDataTableEntry.fromMap(document.data))
        .toList());
  }

  // stream profile data entries
  Stream<QuerySnapshot> fetchProfileDataEntriesAsStream() {
    return _api.streamDataCollection();
  }

  // get profile entry by id
  Future<ProfileDataTableEntry> getProfileDataEntriesById(String id) async {
    var doc = await _api.getDocumentById(id);
    return ProfileDataTableEntry.fromMap(doc.data);
  }

  // remove profile data entry
  Future removeProfileDataEntry(String id) async {
    await _api.removeDocument(id);
    return;
  }

  // update profile data entry
  // Future updateProfileDataEntry(ProfileDataTableEntry data, String id) async {
  //   await _api.updateDocument(data.toMap(docRef.documentID), id);
  //   return;
  // }

  // add profile data entry
  Future<void> addProfileDataEntry(ProfileDataTableEntry data) async {
    await _api
        .addDocument(data.toMap())
        .then((result) => {
              data.id = result.documentID,
              result.setData({'id': data.id}, merge: true)
            })
        .catchError((e) => {print(e.message)});
        print('added entry');
    return;
  }
}
