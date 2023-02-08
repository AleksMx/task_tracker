import 'dart:async';

enum AppStreamEvent {
  reloadData
}

class App {
  App._privateConstructor();
  static final App _instance = App._privateConstructor();

  static final _streamController = StreamController<bool>.broadcast();
  static final _stream = _streamController.stream;

  late final StreamController<AppStreamEvent> _appStreamController = new StreamController<AppStreamEvent>.broadcast();
  late final Stream<AppStreamEvent> _appStream = _appStreamController.stream;

  factory App() {
    return _instance;
  }

  bool _haveUpdateListener = false;
  StreamSubscription<dynamic> subscribeUpdateEvent(Function(bool) cb) {
    if (_haveUpdateListener) {
      throw "already init";
    }
    _haveUpdateListener = true;
    return _stream.listen(cb);
  }

  Future<bool> init() async {
    return true;
  }

  void update() {
    _streamController.add(true);
  }

  StreamSubscription<dynamic> subscribeAppEvent(Function(AppStreamEvent) cb) {
    return _appStream.listen(cb);
  }

  void appTriggerEvent(AppStreamEvent appStreamEvent) {
    _appStreamController.add(appStreamEvent);
  }
}