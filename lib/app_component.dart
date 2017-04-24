import 'package:angular2/core.dart';
import 'package:angularattack2017/components/enemy_grid/grid.dart';
import 'package:angularattack2017/components/grid/grid.dart';
import 'package:angularattack2017/model/game.dart';
import 'package:angularattack2017/model/game_state.dart';
import 'package:angularattack2017/service/enemy_behavior.dart';
import 'package:angularattack2017/service/fleet_generator.dart';
import 'package:angularattack2017/service/game_controller.dart';
import 'package:angularattack2017/service/grid_generator.dart';
import 'package:angularattack2017/service/randomizer.dart';

@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [
    GridComponent,
    EnemyGridComponent
  ],
  providers: const [
    GameController,
    Randomizer,
    EnemyBehavior,
    GridGenerator,
    FleetGenerator
  ]
)
class AppComponent {
  Game game;

  final GameController controller;

  String captainMessageHeader;
  String captainMessageLine1;
  String captainMessageLine2;
  String icon = "pirate-1";

  AppComponent(this.controller) {
    controller.start();
    game = controller.game;

    controller.onStateChange.listen((_) {
      switch (game.state) {
        case GameState.Defeat:
          setDefeatMessage();
          break;
        case GameState.Victory:
          setVictoryMessage();
          break;
        case GameState.Battle:
          setBattleMessage();
          break;
      }
    });

    setBattleMessage();
  }

  void setBattleMessage() {
    captainMessageHeader = "Ahoy, ye salty sea dog!";
    captainMessageLine1 = "Our foes hide t'er fleet in fog like cowardly rats! Yarrr!";
    captainMessageLine2 = "Run a shot across the bow! T'is time to blow them down!";
    icon = "pirate-1";
  }

  void setVictoryMessage() {
    captainMessageHeader = "Yarrr! Victory!";
    captainMessageLine1 = "Treasure and glory await us!";
    captainMessageLine2 = "Prrress thee but'n, if ye wants to fight once again.";
    icon = "pirate";
  }

  void setDefeatMessage() {
    captainMessageHeader = "Arr! Ye been defeated!";
    captainMessageLine1 = "Ye have to try once again, mate!";
    captainMessageLine2 = "Prrress thee but'n!";
    icon = "skull-1";
  }

  void resetGame() {
    controller.reset();
  }
}
