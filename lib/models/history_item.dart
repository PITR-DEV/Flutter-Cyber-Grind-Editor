import 'package:cgef/models/enums.dart';
import 'package:cgef/models/grid_block.dart';

class HistoryEvent {
  Map<int, Delta> deltas;

  HistoryEvent(this.deltas);
}

class Delta {
  Cell newState;
  Cell oldState;
  Tool tool;

  Delta(this.newState, this.oldState, this.tool);
}
