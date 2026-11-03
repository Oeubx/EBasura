import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:a_e_basura/flutter_flow/flutter_flow_util.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('EBasura App state initialization smoke test', () {
    final appState = FFAppState();
    expect(appState, isNotNull);
  });
}
