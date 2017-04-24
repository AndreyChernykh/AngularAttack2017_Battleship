import 'package:angular2/core.dart';
import 'package:angularattack2017/model/grid.dart';
import 'package:angularattack2017/model/tile.dart';
import 'package:angularattack2017/service/randomizer.dart';

@Injectable()
class EnemyBehavior {
  final Randomizer _randomizer;

  List<Tile> lastHitTiles = [];

  EnemyBehavior(this._randomizer);

  Tile selectTarget(Grid grid) {
    List<Tile> targets = [];
    if (lastHitTiles.isEmpty) {
      targets = _selectRandomTargets(grid);
    } else {
      targets = _selectCalculatedTargets(grid);
    }

    return targets[_randomizer.getRandomInt(targets.length)];
  }

  List<Tile> _selectRandomTargets(Grid grid) {
    return grid.getPotentialTargets().toList(growable: false);
  }

  List<Tile> _selectCalculatedTargets(Grid grid) {
    List<Tile> targets = [];
    for (var tile in lastHitTiles) {
      targets.addAll(tile.getUnrevealedDirectNeighbours());
    }

    if (lastHitTiles.length > 1) {
      if (lastHitTiles.last.position.x == lastHitTiles.first.position.x) {
        targets = targets.where((tile) => tile.position.x == lastHitTiles.first.position.x).toList(growable: false);
      } else {
        targets = targets.where((tile) => tile.position.y == lastHitTiles.first.position.y).toList(growable: false);
      }
    }

    return targets;
  }
}
