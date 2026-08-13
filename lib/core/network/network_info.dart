import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnection internetConnection;

  NetworkInfoImpl(this.internetConnection);

  @override
  Future<bool> get isConnected async {
    print('NETWORK INFO: Checking internet connection...');

    try {
      final result =
          await internetConnection.hasInternetAccess.timeout(
        const Duration(seconds: 2),
        onTimeout: () => false,
      );

      print(
        'NETWORK INFO: Internet available = $result',
      );

      return result;
    } catch (e) {
      print(
        'NETWORK INFO: Connection check failed: $e',
      );

      return false;
    }
  }
}