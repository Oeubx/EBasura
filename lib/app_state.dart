import 'package:flutter/material.dart';
import '/backend/api_requests/api_manager.dart';
import 'backend/supabase/supabase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = FlutterSecureStorage();
    await _safeInitAsync(() async {
      _usersStreetName = await secureStorage.getString('ff_usersStreetName') ??
          _usersStreetName;
    });
    await _safeInitAsync(() async {
      _dateTimeScanOfGuest =
          await secureStorage.read(key: 'ff_dateTimeScanOfGuest') != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  (await secureStorage.getInt('ff_dateTimeScanOfGuest'))!)
              : _dateTimeScanOfGuest;
    });
    await _safeInitAsync(() async {
      _dateTimeScanOfUser =
          await secureStorage.read(key: 'ff_dateTimeScanOfUser') != null
              ? DateTime.fromMillisecondsSinceEpoch(
                  (await secureStorage.getInt('ff_dateTimeScanOfUser'))!)
              : _dateTimeScanOfUser;
    });
    await _safeInitAsync(() async {
      _authCanScan =
          await secureStorage.getBool('ff_authCanScan') ?? _authCanScan;
    });
    await _safeInitAsync(() async {
      _guestCanScan =
          await secureStorage.getBool('ff_guestCanScan') ?? _guestCanScan;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  /// takes Users street name
  String _usersStreetName = '';
  String get usersStreetName => _usersStreetName;
  set usersStreetName(String value) {
    _usersStreetName = value;
    secureStorage.setString('ff_usersStreetName', value);
  }

  void deleteUsersStreetName() {
    secureStorage.delete(key: 'ff_usersStreetName');
  }

  bool _isEditingImageRecord = false;
  bool get isEditingImageRecord => _isEditingImageRecord;
  set isEditingImageRecord(bool value) {
    _isEditingImageRecord = value;
  }

  /// date time when the guest used the scanning feature
  DateTime? _dateTimeScanOfGuest;
  DateTime? get dateTimeScanOfGuest => _dateTimeScanOfGuest;
  set dateTimeScanOfGuest(DateTime? value) {
    _dateTimeScanOfGuest = value;
    value != null
        ? secureStorage.setInt(
            'ff_dateTimeScanOfGuest', value.millisecondsSinceEpoch)
        : secureStorage.remove('ff_dateTimeScanOfGuest');
  }

  void deleteDateTimeScanOfGuest() {
    secureStorage.delete(key: 'ff_dateTimeScanOfGuest');
  }

  /// date time when the user used the scanning feature
  DateTime? _dateTimeScanOfUser;
  DateTime? get dateTimeScanOfUser => _dateTimeScanOfUser;
  set dateTimeScanOfUser(DateTime? value) {
    _dateTimeScanOfUser = value;
    value != null
        ? secureStorage.setInt(
            'ff_dateTimeScanOfUser', value.millisecondsSinceEpoch)
        : secureStorage.remove('ff_dateTimeScanOfUser');
  }

  void deleteDateTimeScanOfUser() {
    secureStorage.delete(key: 'ff_dateTimeScanOfUser');
  }

  bool _authCanScan = false;
  bool get authCanScan => _authCanScan;
  set authCanScan(bool value) {
    _authCanScan = value;
    secureStorage.setBool('ff_authCanScan', value);
  }

  void deleteAuthCanScan() {
    secureStorage.delete(key: 'ff_authCanScan');
  }

  bool _authHasScanned = false;
  bool get authHasScanned => _authHasScanned;
  set authHasScanned(bool value) {
    _authHasScanned = value;
  }

  bool _guestCanScan = false;
  bool get guestCanScan => _guestCanScan;
  set guestCanScan(bool value) {
    _guestCanScan = value;
    secureStorage.setBool('ff_guestCanScan', value);
  }

  void deleteGuestCanScan() {
    secureStorage.delete(key: 'ff_guestCanScan');
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: ListToCsvConverter().convert([value]));
}
