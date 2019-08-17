import 'package:jpush_flutter/jpush_flutter.dart';
class PushPage {

  static JPush jpush = new JPush();

  static void init(){
    jpush.addEventHandler(
      // 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
      },
      // 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
      },
      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
      },
    );

    jpush.setup(
      appKey: "45b2b43ee06ff32b3c570556",
      channel: "theChannel",
      production: false,
      debug: false, // 设置是否打印 debug 日志
    );

    jpush.getRegistrationID().then((rid) {
        print(rid+"--------------------------------------------->");
    });

//    jpush.setAlias("lyman").then((map) {
//
//    });

//    jpush.applyPushAuthority(new NotificationSettingsIOS(
//        sound: true,
//        alert: true,
//        badge: true));
  }

}
