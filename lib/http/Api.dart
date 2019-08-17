class Api {
  static const String BASE_URL = "http://gateway.flutter.shop/";
  static const String BASE_IMG =
      "http://yunsharon.oss-cn-beijing.aliyuncs.com/";

  static const String SUCCESS = '1';
  static const String FAILED = '0';

  // 登陆
  static const String USER_LOGIN = "auth?method=auth.account.login";

  //
  static const String ORDER_LOGISTICS =
      "trade?method=trade.order.logistics";

  //退出登录
  static const String USER_LOGOUT =
      BASE_URL + "auth?method=auth.account.loginout";

  // 注册
//  static const String USER_REGISTER = BASE_URL + "/action/openapi/news_detail";

  // 找回密码
  static const String USER_FIND_PASSWORD =
      BASE_URL + "/action/openapi/tweet_list";

  //一级类目 parent=0
  static const String CATEGORY =
      BASE_URL + "category?method=category.cat.parent.page";

  //二三级类目 parent = 一级了类目id
  static const String CATEGORY_TREE =
      BASE_URL + "category?method=category.parent.tree";

  //获取热门关键词列表
  static const String KEYWORD =
      BASE_URL + "keyword?method=keyword.top&version=1.0.0";

  //获取热门关键词列表
  static const String BUYOFFER =
      BASE_URL + "buyoffer?method=buyoffer.publisher.page&version=1.0.0";

  //分类-品牌
  static const String BRAND_LIST_FORCHAR =
      "category?method=category.brands.group.search";

  //首页cms接口page_type= 1	首页2	品牌精选3	爆款排行4	活动页
  static const String CMS =
      "setting?method=setting.page.index.data.page";

  //获取后台类目信息（求购里面的分类）
  static const String category =
      "category?method=category.cats.parent.tree&parent_id=0";

  //单张图片上传
  static const String IMAGE_UPLOAD =
      "file?method=file.image.upload.stream";

  //多张图片上传
  static const String IMAGES_UPLOAD =
      "file?method=file.images.upload.stream";

  //求购
  static const String WANT_BUY_OFFER =
      "buyoffer?method=buyoffer.create&version=v1";

  //搜索
  static const String SEARCH = "item?method=item.search.page";

  //地址列表
  static const String ADDRESS_LIST =
      "trade?method=trade.address.get&times=1";

  //添加地址
  static const String ADD_ADDRESS = "trade?method=trade.address.add";

  //编辑地址
  static const String EDIT_ADDRESS = "trade?method=trade.address.edit";

  //删除多个地址
  static const String DELETE_MUTIL_ADDRESS =
      "trade?method=trade.address.batch.delete";

  //设置支付密码
  static const String SET_PAY_PASSWORD =
      "auth?method=auth.account.paypwd.reset";

  //购物车列表
  static const String CARD_GOODS_LIST = "trade?method=trade.cart.page";

  //更改购物车的商品数量
  static const String EDIT_CARD_GOODS_NUBER =
      "trade?method=trade.cart.update";

  //购物车删除商品
  static const String DELTE_CARD_GOODS =
      "trade?method=trade.cart.batch.delete";

  //清空购物车
  static const String CLEAR_CARD_GOODS = "trade?method=trade.cart.empty";

  //添加购物车商品
  static const String ADD_CART_GOODS = "trade?method=trade.cart.muti.add";

  //商品详情页
  static const String GOOD_DETAIL = "item?method=item.detail.get";

  //获取该用户未处理的充值金额统计
  static const String PAYCENTER_AMOUNT =
      "paycenter?method=paycenter.charge.amount.get&version=1.0";

  //用户创建余额充值单
  static const String PAYCENTER_CHARGE =
      "paycenter?method=paycenter.payment.charge&version=1.0";

  //app版本获取接口
  static const String GET_VERSION = "auth?method=auth.app.setting.get";

  static const String PAYCENTER =
      "paycenter?method=paycenter.charge.amount.get&version=1.0";

  //购物车商品到结算中心
  static const String CART_TO_SETTLEMENT =
      "trade?method=trade.cart.settle";

  //商品详情立即购买进入到结算中心
  static const String ORDER_NOW ="trade?method=trade.simple.settle";

  //获取订单列表
  static const String MY_ORDER = "trade?method=trade.order.page";

  //从购物车创建订单
  static const String CART_TO_CREATE_ORDER = "trade?method=trade.create.cartorder";

  //从商品详情页创建订单
  static const String DETAILS_CREATE_ORDER = "trade?method=trade.create.direct";

  //发起支付
  static const String PAY_MONEY ="paycenter?method=paycenter.payment.pay";

  //获取用户信息
  static const String GET_USER_INFO =
      "user?method=user.company.simple.get";

  //修改头像
  static const String CHANGE_HEAD = "user?method=user.avatar.update";

  //账户余额
  static const String ACCOUNT_BALANCE =
      "fundaccount?method=fundaccount.account.get";

  //确认收货
  static const String CONFIRM_RECEIPT =
      "trade?method=trade.logistics.sign";

  //通过订单号查询，校验账号信息
  static const String CHECK_PAY_AVAILABE ="trade?method=trade.order.pay.available";
}
