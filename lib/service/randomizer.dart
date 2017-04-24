import 'dart:math';
import 'package:angular2/core.dart';

@Injectable()
class Randomizer {
  int getRandomInt(int max) {
    return new Random(new DateTime.now().microsecondsSinceEpoch).nextInt(max);
  }
}
