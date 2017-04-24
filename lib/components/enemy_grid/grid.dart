import 'dart:html';
import 'package:angular2/core.dart';
import 'package:angularattack2017/components/tile/tile.dart';
import 'package:angularattack2017/model/grid.dart';
import 'package:angularattack2017/model/tile.dart';
import 'package:angularattack2017/service/game_controller.dart';

@Component(
    selector: 'enemy-grid',
    styleUrls: const ['grid.css'],
    templateUrl: 'grid.html',
    directives: const [
      TileComponent
    ],
    changeDetection: ChangeDetectionStrategy.OnPush
)
class EnemyGridComponent {
  @Input() Grid grid;

  GameController controller;

  EnemyGridComponent(this.controller);

  void onTileClick(MouseEvent e, Tile tile) {
    controller.shot(tile, grid);
  }
}
