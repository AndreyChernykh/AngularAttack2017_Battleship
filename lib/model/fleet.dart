import 'package:angularattack2017/model/ship.dart';
import 'package:angularattack2017/model/tile.dart';

class Fleet {
  List<Ship> ships = [];

  Fleet([this.ships = const []]);

  bool isDestroyed() {
    return ships.where((ship) => !ship.isDestroyed()).isEmpty;
  }

  Ship findSheepByTile(Tile tile) {
    return ships.firstWhere((Ship ship) => ship.tiles.contains(tile));
  }
}
