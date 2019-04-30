import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';

typedef void CameraViewCreatedCallback(CameraController controller);

// Flash value indicates the flash mode to be used.
enum Flash {
  // Flash is always off.
  Off,
  // Flash is always on, working as a torch.
  Torch,
}

class CameraView extends StatefulWidget {
  static String viewType = 'plugins.hramaroson.github.io/photokredy_core/cameraview';

  const CameraView({
    Key key,
    this.onCreated}) : super (key: key);

  final CameraViewCreatedCallback onCreated;

  @override
  State<StatefulWidget> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver{
  CameraController _cameraController;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _open();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      _open();
    }
    else if(state == AppLifecycleState.paused){
      _close();
    }
  }

  void _open(){ 
    if(_cameraController != null){
        _cameraController.open();
        setState((){});
    }
  }

  void _close(){
    if(_cameraController != null){
       _cameraController.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
        return AndroidView(
            viewType: CameraView.viewType,
            onPlatformViewCreated: _onPlatformViewCreated,
            gestureRecognizers: Set() 
              ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer())), 
        );
    }
    return Text('$defaultTargetPlatform is not yet supported by this plugin');
  }
  @override
  void dispose(){
    _close();
    super.dispose();
  }

  void _onPlatformViewCreated(int id) {
    _cameraController = new CameraController._(id);
    if (widget.onCreated != null) {
      widget.onCreated(_cameraController);
    }
  }
}

class CameraException implements Exception {
  CameraException(this.code, this.description);

  String code;
  String description;

  @override
  String toString() => '$runtimeType($code, $description)';
}

typedef void CameraNoParamaterCallback();

class CameraEventListener {
   CameraEventListener({
     this.onOpened,
     this.onClosed,  
     this.onFocusStarted, 
     this.onFocusEnded
    });

   final CameraNoParamaterCallback onOpened;
   final CameraNoParamaterCallback onClosed;
   final CameraNoParamaterCallback onFocusStarted ;
   final CameraNoParamaterCallback onFocusEnded;
}

class CameraController {
  final MethodChannel _channel;
  List<CameraEventListener> _eventListeners = new List();

  CameraController._(int id)
      :_channel = new MethodChannel(
      'plugins.hramaroson.github.io/photokredy_core/cameraview_$id'),
      _eventListeners = new List() {
          _channel.setMethodCallHandler((MethodCall call) async {
          switch(call.method) {
            case 'opened':
                for (CameraEventListener listener in _eventListeners) 
                  listener.onOpened();
                break;
            case 'closed':
                for (CameraEventListener listener in _eventListeners) 
                  listener.onClosed();
                break;
            case 'focusStarted':
                for (CameraEventListener listener in _eventListeners) 
                  listener.onFocusStarted();
                break;
            case 'focusEnded':
                for (CameraEventListener listener in _eventListeners) 
                  listener.onFocusEnded();
                break;
            default:
                break;
          }
        });
  }

  void addCameraEventListener(CameraEventListener eventListener){
    if( eventListener == null){
         return;
    }
    _eventListeners.add(eventListener);
  }

  Future<void> open() async {
    try {
      _channel.invokeMethod('open');
    } on PlatformException catch (e){
      throw CameraException(e.code, e.message);
    }
  }

  Future<void> close() async {
    try {
      _channel.invokeMethod('close');
    } on PlatformException catch (e){
      throw CameraException(e.code, e.message);
    }
  }

  Future<void> setFlash(Flash flash) async {
    try {
      _channel.invokeMethod('setFlash', flash.index);
    } on PlatformException catch (e){
      throw CameraException(e.code, e.message);
    }
  }

  Future<Flash> getFlash() async {
    try {
      int _flashIndex = await _channel.invokeMethod('getFlash');
      return Flash.values[_flashIndex];
    } on PlatformException catch (e){
      throw CameraException(e.code, e.message);
    }
  }
}

