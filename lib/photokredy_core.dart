import "dart:async";

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef void CameraViewCreatedCallback(CameraController controller);

// Flash value indicates the flash mode to be used.
enum Flash {
  // Flash is always off.
  Off,
  // Flash is always on, working as a torch.
  Torch,
}

class CameraView extends StatefulWidget {
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
        viewType: 'plugins.hramaroson.github.io/photokredy_core/cameraview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text('Unsupported Platform');
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

typedef void CameraOpenedCallback();
typedef void CameraClosedCallback();

class CameraEventListener {
   CameraEventListener({this.onOpened,this.onClosed});

   final CameraOpenedCallback onOpened;
   final CameraClosedCallback onClosed;
}

class CameraController {
  CameraController._(int id)
      :_channel = new MethodChannel(
      'plugins.hramaroson.github.io/photokredy_core/cameraview_$id');
  final MethodChannel _channel;
  CameraEventListener _eventListener;

  void addCameraEventListener(CameraEventListener eventListener){
    if( eventListener == null){
         return;
    }
    _eventListener = eventListener;
    _channel.setMethodCallHandler((MethodCall call) async {
       switch (call.method) {
         case 'opened':
            _eventListener.onOpened();
            break;
         case 'closed':
            _eventListener.onClosed();
            break;
         default:
            break;
       }
    });
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

