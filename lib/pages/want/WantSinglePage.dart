import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/want/WantToBuy.dart';
import 'package:flutter_shop/widgets/app_bar.dart';

///
/// 跳转过来的求购
/// @author longlyboyhe
/// @date 2019/3/24
///
class WantSinglePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
          context: context, title: "发起求购", bottom: CommonAppBarBottomLine()),
      body: Column(
        children: <Widget>[WantToBuy()],
      ),
    );
  }
}
