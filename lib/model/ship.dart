import 'package:angularattack2017/model/tile.dart';

class Ship {
  int size = 1;

  Ship({this.size: 1});

  List<Tile> tiles = [];

  bool isDestroyed() {
    return tiles.where((item) => !item.isShot).isEmpty;
  }
}
