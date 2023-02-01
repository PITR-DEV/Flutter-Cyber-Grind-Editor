import 'package:freezed_annotation/freezed_annotation.dart';

part 'grid_block.freezed.dart';

@freezed
class GridBlock with _$GridBlock {
  const factory GridBlock({
    required int height,
    required String prefab,
    required int index,
  }) = _GridBlock;
}
