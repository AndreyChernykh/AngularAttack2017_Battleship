import 'package:angular2/core.dart';
import 'package:angularattack2017/model/fleet.dart';
import 'package:angularattack2017/model/grid.dart';
import 'package:angularattack2017/model/ship.dart';
import 'package:angularattack2017/model/tile.dart';
import 'package:angularattack2017/service/randomizer.dart';

@Injectable()
class FleetGenerator {
  final Randomizer _randomizer;

  FleetGenerator(this._randomizer);

  Fleet generateForGrid(Grid grid) {
    Fleet fleet = create();

    for (var ship in fleet.ships) {
      _placeShip(ship, grid);
    }

    return fleet;
  }

  void _placeShip(Ship ship, Grid grid) {
    List<List<Tile>> places = grid.getTilesMatchingShipSize(ship.size);

    List<Tile> place = places[_randomizer.getRandomInt(places.length)];

    for (var tile in place) {
      tile.isOccupied = true;
    }

    ship.tiles = place.toList(growable: false);
  }

  Fleet create() {
    return new Fleet([
      new Ship(size: 4),
      new Ship(size: 3),
      new Ship(size: 3),
      new Ship(size: 2),
      new Ship(size: 2),
      new Ship(size: 2),
      new Ship(size: 1),
      new Ship(size: 1),
      new Ship(size: 1),
      new Ship(size: 1),
    ]);
  }
}
