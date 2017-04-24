import 'dart:math';

class Tile {
  final Point position;

  List<Tile> neighbours;

  bool isRevealed = false;
  bool isOccupied = false;
  bool isShot = false;

  bool get isHit => isRevealed && isOccupied && isShot;
  bool get isMissed => isRevealed && !isOccupied && isShot;

  Tile({this.position});

  bool canPlaceShip() {
    return !isOccupied && !hasOccupiedNeighbours();
  }

  bool hasOccupiedNeighbours() {
    return neighbours.where((item) => item.isOccupied).isNotEmpty;
  }

  Iterable<Tile> getUnrevealedDirectNeighbours() {
    return neighbours.where((item) {
      return !item.isRevealed
        && (position.x == item.position.x || position.y == item.position.y);
    });
  }
}
