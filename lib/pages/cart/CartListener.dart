import 'package:flutter_shop/model/cart_resp.dart';

abstract class CartListener {
  void selectAll();

  void collect();

  void delete();

  void changeNum(Cart model, int num);

  void order();

  void wantToBuy(Cart model);

  void refresh();
}
