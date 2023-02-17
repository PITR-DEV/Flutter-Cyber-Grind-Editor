// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grid_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Cell {
  int get height => throw _privateConstructorUsedError;
  String get prefab => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CellCopyWith<Cell> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CellCopyWith<$Res> {
  factory $CellCopyWith(Cell value, $Res Function(Cell) then) =
      _$CellCopyWithImpl<$Res, Cell>;
  @useResult
  $Res call({int height, String prefab, int index});
}

/// @nodoc
class _$CellCopyWithImpl<$Res, $Val extends Cell>
    implements $CellCopyWith<$Res> {
  _$CellCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? height = null,
    Object? prefab = null,
    Object? index = null,
  }) {
    return _then(_value.copyWith(
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      prefab: null == prefab
          ? _value.prefab
          : prefab // ignore: cast_nullable_to_non_nullable
              as String,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CellCopyWith<$Res> implements $CellCopyWith<$Res> {
  factory _$$_CellCopyWith(_$_Cell value, $Res Function(_$_Cell) then) =
      __$$_CellCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int height, String prefab, int index});
}

/// @nodoc
class __$$_CellCopyWithImpl<$Res> extends _$CellCopyWithImpl<$Res, _$_Cell>
    implements _$$_CellCopyWith<$Res> {
  __$$_CellCopyWithImpl(_$_Cell _value, $Res Function(_$_Cell) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? height = null,
    Object? prefab = null,
    Object? index = null,
  }) {
    return _then(_$_Cell(
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      prefab: null == prefab
          ? _value.prefab
          : prefab // ignore: cast_nullable_to_non_nullable
              as String,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_Cell implements _Cell {
  const _$_Cell(
      {required this.height, required this.prefab, required this.index});

  @override
  final int height;
  @override
  final String prefab;
  @override
  final int index;

  @override
  String toString() {
    return 'Cell(height: $height, prefab: $prefab, index: $index)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Cell &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.prefab, prefab) || other.prefab == prefab) &&
            (identical(other.index, index) || other.index == index));
  }

  @override
  int get hashCode => Object.hash(runtimeType, height, prefab, index);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CellCopyWith<_$_Cell> get copyWith =>
      __$$_CellCopyWithImpl<_$_Cell>(this, _$identity);
}

abstract class _Cell implements Cell {
  const factory _Cell(
      {required final int height,
      required final String prefab,
      required final int index}) = _$_Cell;

  @override
  int get height;
  @override
  String get prefab;
  @override
  int get index;
  @override
  @JsonKey(ignore: true)
  _$$_CellCopyWith<_$_Cell> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CellState {
  bool get isHovered => throw _privateConstructorUsedError;
  bool get isPaintedOver => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CellStateCopyWith<CellState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CellStateCopyWith<$Res> {
  factory $CellStateCopyWith(CellState value, $Res Function(CellState) then) =
      _$CellStateCopyWithImpl<$Res, CellState>;
  @useResult
  $Res call({bool isHovered, bool isPaintedOver});
}

/// @nodoc
class _$CellStateCopyWithImpl<$Res, $Val extends CellState>
    implements $CellStateCopyWith<$Res> {
  _$CellStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isHovered = null,
    Object? isPaintedOver = null,
  }) {
    return _then(_value.copyWith(
      isHovered: null == isHovered
          ? _value.isHovered
          : isHovered // ignore: cast_nullable_to_non_nullable
              as bool,
      isPaintedOver: null == isPaintedOver
          ? _value.isPaintedOver
          : isPaintedOver // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CellStateCopyWith<$Res> implements $CellStateCopyWith<$Res> {
  factory _$$_CellStateCopyWith(
          _$_CellState value, $Res Function(_$_CellState) then) =
      __$$_CellStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isHovered, bool isPaintedOver});
}

/// @nodoc
class __$$_CellStateCopyWithImpl<$Res>
    extends _$CellStateCopyWithImpl<$Res, _$_CellState>
    implements _$$_CellStateCopyWith<$Res> {
  __$$_CellStateCopyWithImpl(
      _$_CellState _value, $Res Function(_$_CellState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isHovered = null,
    Object? isPaintedOver = null,
  }) {
    return _then(_$_CellState(
      isHovered: null == isHovered
          ? _value.isHovered
          : isHovered // ignore: cast_nullable_to_non_nullable
              as bool,
      isPaintedOver: null == isPaintedOver
          ? _value.isPaintedOver
          : isPaintedOver // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_CellState implements _CellState {
  const _$_CellState({required this.isHovered, required this.isPaintedOver});

  @override
  final bool isHovered;
  @override
  final bool isPaintedOver;

  @override
  String toString() {
    return 'CellState(isHovered: $isHovered, isPaintedOver: $isPaintedOver)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CellState &&
            (identical(other.isHovered, isHovered) ||
                other.isHovered == isHovered) &&
            (identical(other.isPaintedOver, isPaintedOver) ||
                other.isPaintedOver == isPaintedOver));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isHovered, isPaintedOver);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CellStateCopyWith<_$_CellState> get copyWith =>
      __$$_CellStateCopyWithImpl<_$_CellState>(this, _$identity);
}

abstract class _CellState implements CellState {
  const factory _CellState(
      {required final bool isHovered,
      required final bool isPaintedOver}) = _$_CellState;

  @override
  bool get isHovered;
  @override
  bool get isPaintedOver;
  @override
  @JsonKey(ignore: true)
  _$$_CellStateCopyWith<_$_CellState> get copyWith =>
      throw _privateConstructorUsedError;
}
