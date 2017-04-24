import 'dart:math';
import 'package:angularattack2017/model/tile.dart';

class Grid {
  static const int gridHeight = 10;
  static const int gridWidth = 10;
  static const int gridSize = gridWidth * gridHeight;

  Map<Point, Tile> _tiles = {};
  Iterable<Tile> get tiles => _tiles.values;

  Iterable<Tile> getPotentialTargets() {
    return tiles.where((item) => !item.isRevealed);
  }

  void addTiles(Iterable<Tile> items) {
    _tiles = new Map.fromIterable(items,
      key: (Tile item) => item.position,
      value: (Tile item) => item
    );

    _calculateNeighbours();
  }

  List<List<Tile>> getTilesMatchingShipSize(int shipSize) {
    List<List<Tile>> places = [];

    for (var i = 0; i < gridWidth; i++) {
      places.addAll(findPlacesInRow(i, shipSize));
      places.addAll(findPlacesInCol(i, shipSize));
    }

    return places;
  }

  List<List<Tile>> findPlacesInRow(int rowNumber, int shipSize) {
    List<Tile> line = tiles.where((tile) => tile.position.y == rowNumber).toList(growable: false);

    return findPlacesInLine(line, shipSize);
  }

  List<List<Tile>> findPlacesInCol(int colNumber, int shipSize) {
    List<Tile> line = tiles.where((tile) => tile.position.x == colNumber).toList(growable: false);

    return findPlacesInLine(line, shipSize);
  }

  List<List<Tile>> findPlacesInLine(List<Tile> line, int shipSize) {
    List<List<Tile>> places = [];

    for (var tiles in _findPotentialPositions(line, shipSize)) {
      if (tiles.where((tile) => !tile.canPlaceShip()).isEmpty) {
        places.add(tiles);
      }
    }

    return places;
  }

  List<List<Tile>> _findPotentialPositions(List<Tile> line, int shipSize) {
    int numberOfPositions = line.length - shipSize + 1;
    List<List<Tile>> positions = [];

    for (var i = 0; i < numberOfPositions; i++) {
      positions.add(new List.generate(shipSize, (index) => line[i + index]));
    }

    return positions;
  }

  void _calculateNeighbours() {
    for (var tile in tiles) {
      tile.neighbours = _getNeighbours(tile);
    }
  }

  Iterable<Tile> _getNeighbours(Tile tile) {
    List<Tile> neighbours = [];

    var position = tile.position;

    List<Point> adjacentPositions = [
      new Point(position.x - 1, position.y - 1),
      new Point(position.x, position.y - 1),
      new Point(position.x + 1, position.y - 1),
      new Point(position.x - 1, position.y),
      new Point(position.x + 1, position.y),
      new Point(position.x - 1, position.y + 1),
      new Point(position.x, position.y + 1),
      new Point(position.x + 1, position.y + 1),
    ];

    for (var adjacentPosition in adjacentPositions) {
      var neighbour = _tiles[adjacentPosition];
      if (neighbour != null) {
        neighbours.add(neighbour);
      }
    }

    return neighbours;
  }
}
