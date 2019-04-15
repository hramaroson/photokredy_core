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

  void _init(){ 
    if(_cameraController != null){
        _cameraController.open();
        setState((){});
    }
  }

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed){
      _init();
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
class CameraEventListener {
   CameraEventListener({this.onOpened});

   final  CameraOpenedCallback onOpened;
}

class CameraController {
  CameraController._(int id)
      :_channel = new MethodChannel(
      'plugins.hramaroson.github.io/photokredy_core/cameraview_$id');
  final MethodChannel _channel;

  void addCameraEventListener(CameraEventListener eventListener){
    if( eventListener == null){
         return;
    }
    _channel.setMethodCallHandler((MethodCall call) async {
       switch (call.method) {
         case 'opened':
            eventListener.onOpened();
            break;
         default:
            break;
       }
    });
  }

  Future<bool> open() async {
    try {
      return _channel.invokeMethod('open');
    } on PlatformException catch (e){
      throw CameraException(e.code, e.message);
    }
  }

  Future<bool> setFlash(Flash flash) async {
    try {
      return _channel.invokeMethod('setFlash', flash.index);
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

