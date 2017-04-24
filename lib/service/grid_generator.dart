import 'dart:math';
import 'package:angular2/core.dart';
import 'package:angularattack2017/model/grid.dart';
import 'package:angularattack2017/model/tile.dart';

@Injectable()
class GridGenerator {
  Grid generateEmptyGrid() {
    Grid grid = new Grid();

    grid.addTiles(_generateCoordinates()
      .map((Point p) => new Tile(position: p)));

    return grid;
  }

  List<Point> _generateCoordinates() {
    List<Point> coordinates = [];

    for (var i = 0; i < Grid.gridSize; i++) {
      int x = i % Grid.gridWidth;
      int y = (i / Grid.gridHeight).floor();

      coordinates.add(new Point(x, y));
    }

    return coordinates;
  }

}
