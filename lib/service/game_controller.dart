import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angularattack2017/model/fleet.dart';
import 'package:angularattack2017/model/game.dart';
import 'package:angularattack2017/model/game_state.dart';
import 'package:angularattack2017/model/grid.dart';
import 'package:angularattack2017/model/ship.dart';
import 'package:angularattack2017/model/tile.dart';
import 'package:angularattack2017/service/enemy_behavior.dart';
import 'package:angularattack2017/service/fleet_generator.dart';
import 'package:angularattack2017/service/grid_generator.dart';

enum ShotResult {
  Miss,
  Hit,
  Destroy
}

class ChangeEvent {
  Iterable<Tile> tiles;

  ChangeEvent(this.tiles);
}

@Injectable()
class GameController {
  final EnemyBehavior _enemyBehavior;
  final GridGenerator _gridGenerator;
  final FleetGenerator _fleetGenerator;

  StreamController<Null> _gameStateChange = new StreamController.broadcast();
  Stream<Null> get onStateChange => _gameStateChange.stream;

  StreamController<ChangeEvent> _changes = new StreamController.broadcast();
  Stream<ChangeEvent> get onChanges => _changes.stream;

  GameController(this._enemyBehavior, this._gridGenerator, this._fleetGenerator);

  Game game;

  void start() {
    game = new Game();
    game.state = GameState.Battle;

    _resetPlayerState();
    _resetEnemyState();
  }

  void _checkForGameOver() {
    if (game.enemyFleet.isDestroyed()) {
      game.state = GameState.Victory;
      _enemyBehavior.lastHitTiles.clear();
      _gameStateChange.add(null);
    }

    if (game.playerFleet.isDestroyed()) {
      game.state = GameState.Defeat;
      _enemyBehavior.lastHitTiles.clear();
      _gameStateChange.add(null);
    }
  }

  void shot(Tile target, Grid grid) {
    if (!target.isRevealed && grid == game.enemyGrid && game.isPlayerTurn) {
      _playerMove(target);
    }
  }

  Timer enemyTimer;

  void passTurn() {
    game.isPlayerTurn = !game.isPlayerTurn;

    enemyTimer?.cancel();

    _checkForGameOver();

    if (!game.isPlayerTurn && game.state == GameState.Battle) {
      enemyTimer = new Timer.periodic(const Duration(milliseconds: 1000), (Timer timer) {
        _checkForGameOver();
        if (game.state != GameState.Battle) {
          timer.cancel();
        } else {
          _enemyMove();
        }
      });
    }
  }

  void _playerMove(Tile target) {
    ShotResult result = _shot(target, game.enemyFleet);

    List<Tile> changedTiles = [
      target
    ];

    switch (result) {
      case ShotResult.Hit:
        break;
      case ShotResult.Destroy:
        Ship hitShip = game.enemyFleet.findSheepByTile(target);
        changedTiles.addAll(hitShip.tiles);
        break;
      case ShotResult.Miss:
        passTurn();
        break;
    }

    _checkForGameOver();

    _changes.add(new ChangeEvent(changedTiles));
  }

  void _enemyMove() {
    Tile target = _enemyBehavior.selectTarget(game.playerGrid);
    ShotResult result = _shot(target, game.playerFleet);

    List<Tile> changedTiles = [
      target
    ];

    switch (result) {
      case ShotResult.Hit:
        _enemyBehavior.lastHitTiles.add(target);
        break;
      case ShotResult.Destroy:
        Ship hitShip = game.playerFleet.findSheepByTile(target);
        _enemyBehavior.lastHitTiles.clear();
        changedTiles.addAll(hitShip.tiles);
        break;
      case ShotResult.Miss:
        passTurn();
        break;
    }

    _changes.add(new ChangeEvent(changedTiles));
  }

  ShotResult _shot(Tile target, Fleet fleet) {
    ShotResult result = ShotResult.Miss;

    target.isRevealed = true;
    target.isShot = true;

    if (target.isHit) {
      Ship hitShip = fleet.findSheepByTile(target);

      if (hitShip.isDestroyed()) {
        _revealShip(hitShip);
        result = ShotResult.Destroy;
      } else {
        result = ShotResult.Hit;
      }
    }

    return result;
  }

  void _revealShip(Ship ship) {
    for (var tile in ship.tiles) {
      tile.isRevealed = true;
      for (var adjacentTile in tile.neighbours) {
        adjacentTile.isRevealed = true;
      }
    }
  }

  void reset() {
    game.state = GameState.Battle;
    _resetPlayerState();
    _resetEnemyState();
  }

  void _resetPlayerState() {
    game.playerGrid = _gridGenerator.generateEmptyGrid();
    game.playerFleet = _fleetGenerator.generateForGrid(game.playerGrid);
    _enemyBehavior.lastHitTiles.clear();
  }

  void _resetEnemyState() {
    game.enemyGrid = _gridGenerator.generateEmptyGrid();
    game.enemyFleet = _fleetGenerator.generateForGrid(game.enemyGrid);
  }
}
