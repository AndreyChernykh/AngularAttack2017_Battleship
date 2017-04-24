import 'package:angular2/core.dart';
import 'package:angularattack2017/components/tile/tile.dart';
import 'package:angularattack2017/model/grid.dart';

@Component(
  selector: 'grid',
  styleUrls: const ['grid.css'],
  templateUrl: 'grid.html',
  directives: const [
    TileComponent
  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class GridComponent {
  @Input() Grid grid;
}
