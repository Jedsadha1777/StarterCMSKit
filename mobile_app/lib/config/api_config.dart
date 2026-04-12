class ApiConfig {
  // Override via a local config file (preferred — avoids retyping the IP every run):
  //   1. Copy lib/config/local.json.example → lib/config/local.json
  //   2. Edit local.json and set API_BASE_URL to your LAN IP, e.g.:
  //        { "API_BASE_URL": "http://192.168.1.100:5000/user-api" }
  //   3. flutter run --dart-define-from-file=lib/config/local.json
  //
  // Or pass inline (one-off):
  //   flutter run --dart-define=API_BASE_URL=http://192.168.1.100:5000/user-api
  //
  // Production build:
  //   flutter build ipa --dart-define=API_BASE_URL=https://api.example.com/user-api
  //
  // NOTE: The default value (127.0.0.1) only works on a simulator.
  //       Physical devices MUST supply a real LAN/public IP via --dart-define.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:5000/user-api',
  );
}