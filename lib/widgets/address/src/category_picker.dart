import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_shop/widgets/address/src/base/category_base.dart';
import '../modal/category_result.dart';
import 'mod/picker_popup_route.dart';
import 'show_types.dart';
import 'package:flutter_shop/model/category.dart' show Category;

/// ios city picers
/// provide config height, initLocation and so on
///
/// Sample:
/// ```
/// await CityPicker.showPicker(
///   location: String,
///   height: double
/// );
///
/// ```
class CategoryPickers {
  static Future<CategoryResult> showCategoryPicker({
    @required BuildContext context,
    showType = ShowType.pca,
    double height = 210.0,
    String locationCode = '110000',
    ThemeData theme,
    List<Category> categoryList,
    // CityPickerRoute params
    bool barrierDismissible = true,
    double barrierOpacity = 0.5,
  }) {
    return Navigator.of(context, rootNavigator: true).push(
      new CityPickerRoute(
          theme: theme ?? Theme.of(context),
          canBarrierDismiss: barrierDismissible,
          barrierOpacity: barrierOpacity,
          barrierLabel:
          MaterialLocalizations.of(context).modalBarrierDismissLabel,
          child: BaseView(
              showType: showType,
              height: height,
              datasList: categoryList,
              locationCode: locationCode)),
    );
  }
}
