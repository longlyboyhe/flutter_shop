import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/cart/CartPage.dart';

///
/// 跳转过来的进货单
/// @author longlyboyhe
/// @date 2019/3/24
///
class CartSinglePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CartPage(
        existBackIcon: true,
      ),
    );
  }
}
