import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService {
  final StreamController<InternetStatus> _controller =
      StreamController.broadcast();
  Stream<InternetStatus> get connectionChange => _controller.stream;

  ConnectivityService._privateConstructor() {
    InternetConnection().onStatusChange.listen((status) {
      _controller.sink.add(status);
    });

    //needed to get initial status immediately
    InternetConnection().hasInternetAccess.then((connected) {
      _controller.sink.add(
          connected ? InternetStatus.connected : InternetStatus.disconnected);
    });
  }

  static final ConnectivityService _instance =
      ConnectivityService._privateConstructor();

  factory ConnectivityService() => _instance;

  Future<InternetStatus> getConnectionState() async {
    return await InternetConnection().hasInternetAccess
        ? InternetStatus.connected
        : InternetStatus.disconnected;
  }

  void dispose() {
    _controller.close();
  }
}
