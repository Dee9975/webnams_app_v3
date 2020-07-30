import 'package:connectivity/connectivity.dart';

class ConnectionService {
  Stream<ConnectivityResult> result = Connectivity().onConnectivityChanged;
}