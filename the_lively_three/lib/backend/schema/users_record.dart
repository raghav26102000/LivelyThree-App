import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "age" field.
  int? _age;
  int get age => _age ?? 0;
  bool hasAge() => _age != null;

  // "height" field.
  double? _height;
  double get height => _height ?? 0.0;
  bool hasHeight() => _height != null;

  // "weight" field.
  double? _weight;
  double get weight => _weight ?? 0.0;
  bool hasWeight() => _weight != null;

  // "region" field.
  String? _region;
  String get region => _region ?? '';
  bool hasRegion() => _region != null;

  // "gender" field.
  String? _gender;
  String get gender => _gender ?? '';
  bool hasGender() => _gender != null;

  // "country" field.
  String? _country;
  String get country => _country ?? '';
  bool hasCountry() => _country != null;

  // "selectedplants" field.
  List<DocumentReference>? _selectedplants;
  List<DocumentReference> get selectedplants => _selectedplants ?? const [];
  bool hasSelectedplants() => _selectedplants != null;

  // "last_update" field.
  DateTime? _lastUpdate;
  DateTime? get lastUpdate => _lastUpdate;
  bool hasLastUpdate() => _lastUpdate != null;

  // "dsgeneraloptin" field.
  bool? _dsgeneraloptin;
  bool get dsgeneraloptin => _dsgeneraloptin ?? false;
  bool hasDsgeneraloptin() => _dsgeneraloptin != null;

  // "firstname" field.
  String? _firstname;
  String get firstname => _firstname ?? '';
  bool hasFirstname() => _firstname != null;

  // "lastname" field.
  String? _lastname;
  String get lastname => _lastname ?? '';
  bool hasLastname() => _lastname != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _photoUrl = snapshotData['photo_url'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _age = castToType<int>(snapshotData['age']);
    _height = castToType<double>(snapshotData['height']);
    _weight = castToType<double>(snapshotData['weight']);
    _region = snapshotData['region'] as String?;
    _gender = snapshotData['gender'] as String?;
    _country = snapshotData['country'] as String?;
    _selectedplants = getDataList(snapshotData['selectedplants']);
    _lastUpdate = snapshotData['last_update'] as DateTime?;
    _dsgeneraloptin = snapshotData['dsgeneraloptin'] as bool?;
    _firstname = snapshotData['firstname'] as String?;
    _lastname = snapshotData['lastname'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? photoUrl,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  int? age,
  double? height,
  double? weight,
  String? region,
  String? gender,
  String? country,
  DateTime? lastUpdate,
  bool? dsgeneraloptin,
  String? firstname,
  String? lastname,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'age': age,
      'height': height,
      'weight': weight,
      'region': region,
      'gender': gender,
      'country': country,
      'last_update': lastUpdate,
      'dsgeneraloptin': dsgeneraloptin,
      'firstname': firstname,
      'lastname': lastname,
    }.withoutNulls,
  );

  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.photoUrl == e2?.photoUrl &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.age == e2?.age &&
        e1?.height == e2?.height &&
        e1?.weight == e2?.weight &&
        e1?.region == e2?.region &&
        e1?.gender == e2?.gender &&
        e1?.country == e2?.country &&
        listEquality.equals(e1?.selectedplants, e2?.selectedplants) &&
        e1?.lastUpdate == e2?.lastUpdate &&
        e1?.dsgeneraloptin == e2?.dsgeneraloptin &&
        e1?.firstname == e2?.firstname &&
        e1?.lastname == e2?.lastname;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.photoUrl,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.age,
        e?.height,
        e?.weight,
        e?.region,
        e?.gender,
        e?.country,
        e?.selectedplants,
        e?.lastUpdate,
        e?.dsgeneraloptin,
        e?.firstname,
        e?.lastname
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
