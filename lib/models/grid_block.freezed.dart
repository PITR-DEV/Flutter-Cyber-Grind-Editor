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
mixin _$GridBlock {
  int get height => throw _privateConstructorUsedError;
  String get prefab => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GridBlockCopyWith<GridBlock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GridBlockCopyWith<$Res> {
  factory $GridBlockCopyWith(GridBlock value, $Res Function(GridBlock) then) =
      _$GridBlockCopyWithImpl<$Res, GridBlock>;
  @useResult
  $Res call({int height, String prefab, int index});
}

/// @nodoc
class _$GridBlockCopyWithImpl<$Res, $Val extends GridBlock>
    implements $GridBlockCopyWith<$Res> {
  _$GridBlockCopyWithImpl(this._value, this._then);

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
abstract class _$$_GridBlockCopyWith<$Res> implements $GridBlockCopyWith<$Res> {
  factory _$$_GridBlockCopyWith(
          _$_GridBlock value, $Res Function(_$_GridBlock) then) =
      __$$_GridBlockCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int height, String prefab, int index});
}

/// @nodoc
class __$$_GridBlockCopyWithImpl<$Res>
    extends _$GridBlockCopyWithImpl<$Res, _$_GridBlock>
    implements _$$_GridBlockCopyWith<$Res> {
  __$$_GridBlockCopyWithImpl(
      _$_GridBlock _value, $Res Function(_$_GridBlock) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? height = null,
    Object? prefab = null,
    Object? index = null,
  }) {
    return _then(_$_GridBlock(
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

class _$_GridBlock implements _GridBlock {
  const _$_GridBlock(
      {required this.height, required this.prefab, required this.index});

  @override
  final int height;
  @override
  final String prefab;
  @override
  final int index;

  @override
  String toString() {
    return 'GridBlock(height: $height, prefab: $prefab, index: $index)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GridBlock &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.prefab, prefab) || other.prefab == prefab) &&
            (identical(other.index, index) || other.index == index));
  }

  @override
  int get hashCode => Object.hash(runtimeType, height, prefab, index);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GridBlockCopyWith<_$_GridBlock> get copyWith =>
      __$$_GridBlockCopyWithImpl<_$_GridBlock>(this, _$identity);
}

abstract class _GridBlock implements GridBlock {
  const factory _GridBlock(
      {required final int height,
      required final String prefab,
      required final int index}) = _$_GridBlock;

  @override
  int get height;
  @override
  String get prefab;
  @override
  int get index;
  @override
  @JsonKey(ignore: true)
  _$$_GridBlockCopyWith<_$_GridBlock> get copyWith =>
      throw _privateConstructorUsedError;
}
