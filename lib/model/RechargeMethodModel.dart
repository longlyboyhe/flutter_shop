///
/// 支付方式  type：1对公账户 2支付宝 3微信 4银联卡
/// @author longlyboyhe
/// @date 2019/3/9
///
class RechargeMethodModel {
  int type;
  String name;
  String icon;

  RechargeMethodModel({this.type, this.name, this.icon});
}
