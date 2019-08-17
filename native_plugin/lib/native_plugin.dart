import 'package:flutter/services.dart';

class NativePlugin {

  static const MethodChannel channel =const MethodChannel("com.dislux.yshangflutter.native_plugin");


  static void downloadApk(String url){
    channel.invokeMethod("downloadApk",url);
  }

}
