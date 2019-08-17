import 'package:connectivity/connectivity.dart';


 /**
 * connectivityResult == ConnectivityResult.none  无网
 * connectivityResult == ConnectivityResult.wifi
 * connectivityResult == ConnectivityResult.mobile
 * @author longlyboyhe
 * @date 2018/12/25
 **/

class NetWorkEvent {
  ConnectivityResult connectionType;

  NetWorkEvent(this.connectionType);
}
