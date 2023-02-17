import 'package:freezed_annotation/freezed_annotation.dart';

part 'grid_block.freezed.dart';

@freezed
class Cell with _$Cell {
  const factory Cell({
    required int height,
    required String prefab,
    required int index,
  }) = _Cell;
}

@freezed
class CellState with _$CellState {
  const factory CellState({
    required bool isHovered,
    required bool isPaintedOver,
  }) = _CellState;
}
