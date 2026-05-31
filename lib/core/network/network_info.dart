import 'package:connectivity_plus/connectivity_plus.dart';

/// Reports whether the device has a network connection. Checked before
/// API calls so offline errors surface fast instead of timing out.
abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// `connectivity_plus` reports the *type* of connection, not real reachability
  /// — but "not none" is a good cheap pre-check. Any non-[ConnectivityResult.none]
  /// result counts as connected.
  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }
}
