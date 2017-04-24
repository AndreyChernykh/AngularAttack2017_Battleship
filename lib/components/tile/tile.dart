import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angularattack2017/model/tile.dart';
import 'package:angularattack2017/service/game_controller.dart';

@Component(
  selector: 'tile',
  styleUrls: const ['tile.css'],
  templateUrl: 'tile.html',
  directives: const [

  ],
  changeDetection: ChangeDetectionStrategy.OnPush
)
class TileComponent implements AfterViewInit, OnDestroy {
  @Input() Tile tile;

  @HostBinding('class.occupied') get isOccupied => tile.isOccupied;
  @HostBinding('class.hit') get isHit => tile.isHit;
  @HostBinding('class.miss') get isMiss => tile.isMissed;
  @HostBinding('class.revealed') get isRevealed => tile.isRevealed;

  @ViewChild('message') ElementRef messageRef;

  ChangeDetectorRef _cd;

  StreamSubscription onShotListener;

  TileComponent(this._cd, GameController controller) {
    onShotListener = controller.onChanges.where((ChangeEvent event) => event.tiles.contains(tile)).listen((event) {
      _cd.detectChanges();
      _cd.markForCheck();
    });
  }

  @override
  void ngAfterViewInit() {
    new Future.delayed(const Duration(milliseconds: 10), () {
      messageRef?.nativeElement?.classes?.add('fade');
    });
  }

  @override
  void ngOnDestroy() {
    onShotListener.cancel();
  }
}
