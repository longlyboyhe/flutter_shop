import 'package:flutter_shop/model/address.dart';

///
/// 地址簿底部操作回调方法
/// @author longlyboyhe
/// @date 2019/2/15
///
abstract class BottomBarListener {
  void addAdress({Address model});

  void selected();

  void selectAll();

  void delete();

  void refresh();
}
