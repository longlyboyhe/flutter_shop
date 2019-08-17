import 'package:flutter/material.dart';

///IndexBar touch callback IndexModel.
typedef void IndexBarTouchCallback(IndexBarDetails model);

///
/// 所有item平均分高度
/// @author longlyboyhe
/// @date 2019/1/31
///
///IndexModel.
class IndexBarDetails {
  String tag; //current touch tag.
  int position; //current touch position.
  bool isTouchDown; //is touch down.

  IndexBarDetails({this.tag, this.position, this.isTouchDown});
}

///Default Index data.
const List<String> INDEX_DATA_DEF = const [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
  "#"
];

class IndexBar extends StatefulWidget {
  IndexBar(
      {Key key,
      this.data: INDEX_DATA_DEF,
      @required this.onTouch,
      this.width: 20,
      this.curTag = 'A',
      this.color = Colors.transparent,
      this.textStyle =
          const TextStyle(fontSize: 13.0, color: Color(0xFFBCBCBC)),
      this.touchDownColor = Colors.transparent,
      this.touchDownTextStyle = const TextStyle(
          fontSize: 13.0,
          color: Color(0xFF1D1E1F),
          fontWeight: FontWeight.w500)});

  final String curTag;

  ///index data.
  final List<String> data;

  ///IndexBar width(def:30).
  final int width;

  /// Background color
  final Color color;

  ///IndexBar touch down color.
  final Color touchDownColor;

  ///IndexBar text style.
  final TextStyle textStyle;

  final TextStyle touchDownTextStyle;

  ///Item touch callback.
  final IndexBarTouchCallback onTouch;

  @override
  _SuspensionListViewIndexBarState createState() =>
      _SuspensionListViewIndexBarState();
}

class _SuspensionListViewIndexBarState extends State<IndexBar> {
  bool _isTouchDown = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: _isTouchDown ? widget.touchDownColor : widget.color,
      width: widget.width.toDouble(),
      child: _IndexBar(
        data: widget.data,
        width: widget.width,
        curTag: widget.curTag,
        textStyle: widget.textStyle,
        touchDownTextStyle: widget.touchDownTextStyle,
        onTouch: (details) {
          if (widget.onTouch != null) {
            if (_isTouchDown != details.isTouchDown) {
              setState(() {
                _isTouchDown = details.isTouchDown;
              });
            }
            widget.onTouch(details);
          }
        },
      ),
    );
  }
}

/// Base IndexBar.
class _IndexBar extends StatefulWidget {
  final String curTag;

  ///index data.
  final List<String> data;

  ///IndexBar width(def:30).
  final int width;

  ///IndexBar text style.
  final TextStyle textStyle;

  final TextStyle touchDownTextStyle;

  ///Item touch callback.
  final IndexBarTouchCallback onTouch;

  _IndexBar(
      {Key key,
      this.data: INDEX_DATA_DEF,
      this.curTag = 'A',
      @required this.onTouch,
      this.width: 30,
      this.textStyle,
      this.touchDownTextStyle})
      : assert(onTouch != null),
        super(key: key);

  @override
  _IndexBarState createState() => _IndexBarState();
}

class _IndexBarState extends State<_IndexBar> {
  List<double> _indexSectionList = List();
  List<GlobalKey> _keyList = List();
  List<double> _itemHeights = List();
  int _widgetTop = -1;
  int _lastIndex = 0;
  bool _widgetTopChange = false;
  bool _isTouchDown = false;
  IndexBarDetails _indexModel = IndexBarDetails();

  ///get index.
  int _getIndex(int offset) {
    for (int i = 0, length = _indexSectionList.length; i < length - 1; i++) {
      double a = _indexSectionList[i];
      double b = _indexSectionList[i + 1];
      if (offset >= a && offset < b) {
        return i;
      }
    }
    return -1;
  }

  void _init() {
    _widgetTopChange = true;
    _indexSectionList.clear();
    _indexSectionList.add(0);
    double tempHeight = 0;
    _itemHeights?.forEach((value) {
      tempHeight = tempHeight + value;
      _indexSectionList.add(tempHeight);
    });

    _indexModel.tag = widget.curTag;
    _indexModel.isTouchDown = true;
  }

  _triggerTouchEvent() {
    if (widget.onTouch != null) {
      widget.onTouch(_indexModel);
    }
  }

  @override
  void initState() {
    super.initState();
    _keyList = widget.data.map((var data) => GlobalKey()).toList();
    _itemHeights = widget.data.map((var tab) => 15.0).toList();

    _indexModel.tag = widget.curTag;
    _indexModel.isTouchDown = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
  }

  void _onAfterRendering(Duration timeStamp) {
    //这里编写获取元素大小和位置的方法
    for (int i = 0; i < _keyList.length; i++) {
      GlobalKey<State<StatefulWidget>> state = _keyList[i];
      BuildContext currentContext = state.currentContext;
      if (currentContext != null && currentContext.size != null) {
        _itemHeights[i] = currentContext.size.height;
      }
    }
    setState(() {
      _init();
    });
  }

  @override
  void didUpdateWidget(_IndexBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _style = widget.textStyle;
    TextStyle _touchDownStyle = widget.touchDownTextStyle;

    List<Widget> children = List();
    for (int i = 0; i < widget.data.length; i++) {
      children.add(Expanded(
          key: _keyList[i],
          child: SizedBox(
            width: widget.width.toDouble(),
            child: Text(widget.data[i],
                textAlign: TextAlign.center,
                style: _indexModel.tag == widget.data[i]
                    ? _touchDownStyle
                    : _style),
          )));
    }

    return GestureDetector(
      onTapDown: (detail) {
        _indexModel.isTouchDown = true;
        _triggerTouchEvent();
      },
      onVerticalDragDown: (DragDownDetails details) {
        if (_widgetTop == -1 || _widgetTopChange) {
          _widgetTopChange = false;
          RenderBox box = context.findRenderObject();
          Offset topLeftPosition = box.localToGlobal(Offset.zero);
          _widgetTop = topLeftPosition.dy.toInt();
        }
        int offset = details.globalPosition.dy.toInt() - _widgetTop;
        int index = _getIndex(offset);
        if (index != -1) {
          _lastIndex = index;
          _indexModel.position = index;
          _indexModel.tag = widget.data[index];
          _indexModel.isTouchDown = true;
          _triggerTouchEvent();
        }
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        int offset = details.globalPosition.dy.toInt() - _widgetTop;
        int index = _getIndex(offset);
        if (index != -1 && _lastIndex != index) {
          _lastIndex = index;
          _indexModel.position = index;
          _indexModel.tag = widget.data[index];
          _indexModel.isTouchDown = true;
          _triggerTouchEvent();
        }
      },
      onVerticalDragEnd: (DragEndDetails details) {
        _indexModel.isTouchDown = false;
        _triggerTouchEvent();
      },
      onTapUp: (detail) {
        _indexModel.isTouchDown = false;
        _triggerTouchEvent();
      },
      onTapCancel: () {
        _indexModel.isTouchDown = false;
        _triggerTouchEvent();
      },
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
