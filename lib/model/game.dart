import 'package:angularattack2017/model/fleet.dart';
import 'package:angularattack2017/model/game_state.dart';
import 'package:angularattack2017/model/grid.dart';

class Game {
  GameState state = GameState.Battle;

  Fleet playerFleet;
  Fleet enemyFleet;

  Grid playerGrid;
  Grid enemyGrid;

  bool isPlayerTurn = true;
}
