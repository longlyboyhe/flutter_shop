const List<Point> EmptyArray = [];
const NoName = "";

///  use National Bureau of Statistics's data, build tree, the [point] is trees's node
class Point {
  int code;
  List<Point> child;
  int depth;
  String name = NoName;

  Point({this.code = 0, this.child = EmptyArray, this.depth, this.name});

  /// add node for Point, the node's type must is [Point]
  addChild(Point node) {
    this.child.add(node);
  }

  @override
  String toString() {
    return "{code: $code, name: $name, child: Array & length = ${child == null ? 0 : child.length}";
  }
}
