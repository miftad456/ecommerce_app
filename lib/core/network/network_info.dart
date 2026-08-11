import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    try {
      final result = await connectivity.checkConnectivity();

      return result.any(
        (connection) =>
            connection != ConnectivityResult.none,
      );
    } catch (e) {
      // If the platform connectivity service fails
      // (for example, Linux DBus/NetworkManager),
      // safely treat the device as offline.
      print(
        'Network connectivity check failed: $e',
      );

      return false;
    }
  }
}