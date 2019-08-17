import 'package:flutter_shop/utils/screen_util.dart';

class Klength {
  ///顶部titlebar高
  static const double topBarHeight = 45;
  ///首页-顶部搜索框高
  static double home_searchtHeight = 46;

  ///爆款排行顶部banner高
  static double home_rankBannerHeight = 100;

  ///爆款排行筛选栏高
  static double home_rankFilterHeight = 40;

  ///爆款底部筛选内容剩余高度
  static double home_rankContentHeight = ScreenUtil.screenHeight -
      ScreenUtil.statusBarHeight -
      13 -
      home_searchtHeight -
      ScreenUtil.tabBarHeight -
      home_rankBannerHeight -
      home_rankFilterHeight;

  ///品牌馆横向筛选顶部banner高
  static double brand_topBannerHeight = 15 + 375 + 15.0;

  ///品牌馆横向筛选顶部banner高
  static double brand_filterHeight = 45;

  ///品牌馆列表热销TOP高  热销高+横划高+间隔线
  static double brand_firstListItemHeight = 120 + 223 + 11.0;

  ///品牌馆列表热销TOP高  包袋高+大图高+横划高+间隔线
  static double brand_listItemHeight = 78 + 200 + 223 + 11.0;
}
