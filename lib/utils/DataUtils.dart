import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_shop/model/login_model.dart';

class DataUtils {
  static final String SP_AC_TOKEN = "accessToken";
  static final String SP_MEMBER_ID = "memberId";
  static final String SP_UID = "uid";
  static final String SP_IS_LOGIN = "isLogin";
  static final String SP_MEMBER_CER_STATE =
      "memberCertificationState"; //'1'  用户认证状态 0待审核,1审核通过,2审核拒绝3,未认证(比原来多返回的)

  static const String USER_INFO = "userInfo";
  static const String TOKEN_INFO = "token";
  static const String USER_HEADIMG = "headimg";
  static const String USER_COMPANY_NAME = "company_name";

  ///分享全局加价
  static final String SP_SHARE_GLOBALPRICE = "globalPrice";

  ///版本更新提示时间
  static final String SP_GET_NEWVERSION = "getNewVersion";

  static Future<bool> setGetVersionTime() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setInt(
        SP_GET_NEWVERSION, (DateTime.now().millisecondsSinceEpoch));
  }

  //两天弹一次
  static Future<bool> isTimeToPromp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    int oldTime =
        sp.getInt(SP_GET_NEWVERSION) != null ? sp.getInt(SP_GET_NEWVERSION) : 0;
    DateTime now = DateTime.now();
    DateTime date = DateTime.fromMillisecondsSinceEpoch(oldTime);
    Duration diff = now.difference(date);
    if (diff.inDays >= 2) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> setGlobalPrice(double globalPrice) async {
    if (globalPrice != null && globalPrice > 0) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      return await sp.setDouble(SP_SHARE_GLOBALPRICE, globalPrice);
    }
    return false;
  }

  static Future<double> getGlobalPrice() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    double d = sp.getDouble(SP_SHARE_GLOBALPRICE);
    return d == null ? 0 : d;
  }

  static Future<bool> setUserHeadImg(String img) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(USER_HEADIMG, img);
  }

  static Future<String> getUserHeadImg() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(USER_HEADIMG);
  }

  static Future<bool> setCompanyName(String name) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return await sp.setString(USER_COMPANY_NAME, name);
  }

  static Future<String> getCompanyName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(USER_COMPANY_NAME);
  }

  // 保存用户登录信息，data中包含了token等信息
  static void saveLoginInfo(Token token) async {
    if (token != null) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString(TOKEN_INFO, jsonEncode(token));
    }
  }

  // 清除登录信息
  static clearLoginInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(TOKEN_INFO, "");
    await sp.setString(USER_INFO, "");
    await sp.setInt(SP_MEMBER_CER_STATE, -1);
    await sp.setBool(SP_IS_LOGIN, false);
  }

  // 保存用户个人信息
  static void saveUserInfo(User data) async {
    if (data != null) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString(USER_INFO, jsonEncode(data));
    }
  }

  // 获取用户信息
  static Future<User> getUserInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool isLogin = sp.getBool(SP_IS_LOGIN);
    if (isLogin == null || !isLogin) {
      return null;
    }
    String json = sp.getString(USER_INFO);
    User user = User.fromJson(jsonDecode(json));
    return user;
  }

  // 是否登录
  static Future<bool> isLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    bool b = sp.getBool(SP_IS_LOGIN);
    return b != null && b;
  }

  static void setLoginSuccess(bool isLogin) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(SP_IS_LOGIN, isLogin);
    if (isLogin == false) {
      clearLoginInfo();
    }
  }

  static Future<Token> getTokenInfo() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String tokenJson = sp.getString(TOKEN_INFO);
    if (tokenJson != null && tokenJson.isNotEmpty) {
      return await Token.fromJson(jsonDecode(tokenJson));
    } else {
      return null;
    }
  }
}
