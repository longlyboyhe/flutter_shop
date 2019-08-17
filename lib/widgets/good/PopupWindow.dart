import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;
const double _kMenuScreenPadding = 0.0;

///
/// 在控件下方弹出的popupwindow（PopupMenuButton改写）
/// @author longlyboyhe
/// @date 2019/1/30
///

class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(
      this.position, this.selectedItemOffset, this.textDirection);

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // The distance from the top of the menu to the middle of selected item.
  //
  // This will be null if there's no item to position in this way.
  final double selectedItemOffset;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest -
        const Offset(_kMenuScreenPadding * 2.0, _kMenuScreenPadding * 2.0));
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    // Find the ideal vertical position.
    double y;
    if (selectedItemOffset == null) {
      y = position.top;
    } else {
      y = position.top +
          (size.height - position.top - position.bottom) / 2.0 -
          selectedItemOffset;
    }

    // Find the ideal horizontal position.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    } else {
      // Menu button is equidistant from both edges, so grow in reading direction.
      assert(textDirection != null);
      switch (textDirection) {
        case TextDirection.rtl:
          x = size.width - position.right - childSize.width;
          break;
        case TextDirection.ltr:
          x = position.left;
          break;
      }
    }

    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
    // edge of the screen in every direction.
    if (x < _kMenuScreenPadding)
      x = _kMenuScreenPadding;
    else if (x + childSize.width > size.width - _kMenuScreenPadding)
      x = size.width - childSize.width - _kMenuScreenPadding;
    if (y < _kMenuScreenPadding)
      y = _kMenuScreenPadding;
    else if (y + childSize.height > size.height - _kMenuScreenPadding)
      y = size.height - childSize.height - _kMenuScreenPadding;
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}

class _PopupMenuRoute<T> extends PopupRoute<T> {
  _PopupMenuRoute(
      {this.position,
      this.builder,
      this.initialValue,
      this.elevation,
      this.theme,
      this.barrierLabel,
      this.semanticLabel,
      this.bgPadding = const EdgeInsets.all(1),
      this.bgPath});

  final RelativeRect position;
  final WidgetBuilder builder;
  final dynamic initialValue;
  final double elevation;
  final ThemeData theme;
  final String semanticLabel;
  final String bgPath;
  final EdgeInsetsGeometry bgPadding;

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
        parent: super.createAnimation(),
        curve: Curves.linear,
        reverseCurve: const Interval(0.0, _kMenuCloseIntervalEnd));
  }

  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    double selectedItemOffset = 0;

    Widget menu = AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return child;
      },
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        removeLeft: true,
        removeRight: true,
        child: CustomSingleChildLayout(
          delegate: _PopupMenuRouteLayout(
            position,
            selectedItemOffset,
            Directionality.of(context),
          ),
          child: Material(child: builder(context)),
        ),
      ),
    );
    if (theme != null) menu = Theme(data: theme, child: menu);
    return menu;
  }
}

Future<T> showMenu<T>({
  @required BuildContext context,
  RelativeRect position,
  @required WidgetBuilder builder,
  T initialValue,
  double elevation = 8.0,
  String semanticLabel,
  String bgPath,
  EdgeInsetsGeometry bgPadding = const EdgeInsets.all(1),
}) {
  assert(context != null);
  assert(builder != null);
  assert(debugCheckHasMaterialLocalizations(context));
  String label = semanticLabel;
  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      label = semanticLabel;
      break;
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
      label =
          semanticLabel ?? MaterialLocalizations.of(context)?.popupMenuLabel;
  }
  return Navigator.push(
      context,
      _PopupMenuRoute<T>(
        position: position,
        builder: builder,
        bgPath: bgPath,
        bgPadding: bgPadding,
        initialValue: initialValue,
        elevation: elevation,
        semanticLabel: label,
        theme: Theme.of(context, shadowThemeOnly: true),
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
      ));
}

typedef PopupMenuOpened = void Function();

class PopupWindow<T> extends StatefulWidget {
  /// Creates a button that shows a popup menu.
  ///
  /// The [itemBuilder] argument must not be null.
  const PopupWindow({
    Key key,
    @required this.builder,
//    this.initialValue,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation = 8.0,
    this.padding = const EdgeInsets.all(8.0),
    this.child,
    this.icon,
    this.offset = Offset.zero,
    this.onOpened,
    this.bgPath,
    this.bgPadding = const EdgeInsets.all(0.0),
  })  : assert(builder != null),
        assert(offset != null),
        assert(!(child != null && icon != null)),
        // fails if passed both parameters
        super(key: key);

  final String bgPath;
  final EdgeInsetsGeometry bgPadding;

  /// Called when the button is pressed to create the items to show in the menu.
  final WidgetBuilder builder;

  /// The value of the menu item, if any, that should be highlighted when the menu opens.
//  final T initialValue;

  /// Called when the user selects a value from the popup menu created by this button.
  ///
  /// If the popup menu is dismissed without selecting a value, [onCanceled] is
  /// called instead.
  final PopupMenuItemSelected<T> onSelected;

  final PopupMenuOpened onOpened;

  /// Called when the user dismisses the popup menu without selecting an item.
  ///
  /// If the user selects a value, [onSelected] is called instead.
  final PopupMenuCanceled onCanceled;

  /// Text that describes the action that will occur when the button is pressed.
  ///
  /// This text is displayed when the user long-presses on the button and is
  /// used for accessibility.
  final String tooltip;

  /// The z-coordinate at which to place the menu when open. This controls the
  /// size of the shadow below the menu.
  ///
  /// Defaults to 8, the appropriate elevation for popup menus.
  final double elevation;

  /// Matches IconButton's 8 dps padding by default. In some cases, notably where
  /// this button appears as the trailing element of a list item, it's useful to be able
  /// to set the padding to zero.
  final EdgeInsetsGeometry padding;

  /// If provided, the widget used for this button.
  final Widget child;

  /// If provided, the icon used for this button.
  final Icon icon;

  /// The offset applied to the Popup Menu Button.
  ///
  /// When not set, the Popup Menu Button will be positioned directly next to
  /// the button that was used to create it.
  final Offset offset;

  @override
  _PopupWindowState<T> createState() => _PopupWindowState<T>();
}

class _PopupWindowState<T> extends State<PopupWindow<T>> {
  void showButtonMenu() {
    final RenderBox button = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(widget.offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu<T>(
      context: context,
      bgPath: widget.bgPath,
      bgPadding: widget.bgPadding,
      elevation: widget.elevation,
      builder: widget.builder,
      position: position,
    ).then<void>((T newValue) {
      if (!mounted) return null;
      if (newValue == null) {
        if (widget.onCanceled != null) widget.onCanceled();
        return null;
      }
      if (widget.onSelected != null) widget.onSelected(newValue);
    }, onError: () {});
    if (widget.onOpened != null) widget.onOpened();
  }

  Icon _getIcon(TargetPlatform platform) {
    assert(platform != null);
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return const Icon(Icons.more_vert);
      case TargetPlatform.iOS:
        return const Icon(Icons.more_horiz);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return widget.child != null
        ? InkWell(
            onTap: showButtonMenu,
            child: widget.child,
          )
        : IconButton(
            icon: widget.icon ?? _getIcon(Theme.of(context).platform),
            padding: widget.padding,
            tooltip: widget.tooltip ??
                MaterialLocalizations.of(context).showMenuTooltip,
            onPressed: showButtonMenu,
          );
  }
}
