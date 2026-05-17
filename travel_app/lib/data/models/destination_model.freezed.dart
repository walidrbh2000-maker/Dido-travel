// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'destination_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DestinationModel _$DestinationModelFromJson(Map<String, dynamic> json) {
  return _DestinationModel.fromJson(json);
}

/// @nodoc
mixin _$DestinationModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  bool get isPopular => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DestinationModelCopyWith<DestinationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DestinationModelCopyWith<$Res> {
  factory $DestinationModelCopyWith(
          DestinationModel value, $Res Function(DestinationModel) then) =
      _$DestinationModelCopyWithImpl<$Res, DestinationModel>;
  @useResult
  $Res call(
      {int id,
      String name,
      String country,
      String? description,
      String? image,
      bool isPopular});
}

/// @nodoc
class _$DestinationModelCopyWithImpl<$Res, $Val extends DestinationModel>
    implements $DestinationModelCopyWith<$Res> {
  _$DestinationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? country = null,
    Object? description = freezed,
    Object? image = freezed,
    Object? isPopular = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      isPopular: null == isPopular
          ? _value.isPopular
          : isPopular // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DestinationModelImplCopyWith<$Res>
    implements $DestinationModelCopyWith<$Res> {
  factory _$$DestinationModelImplCopyWith(_$DestinationModelImpl value,
          $Res Function(_$DestinationModelImpl) then) =
      __$$DestinationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String country,
      String? description,
      String? image,
      bool isPopular});
}

/// @nodoc
class __$$DestinationModelImplCopyWithImpl<$Res>
    extends _$DestinationModelCopyWithImpl<$Res, _$DestinationModelImpl>
    implements _$$DestinationModelImplCopyWith<$Res> {
  __$$DestinationModelImplCopyWithImpl(_$DestinationModelImpl _value,
      $Res Function(_$DestinationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? country = null,
    Object? description = freezed,
    Object? image = freezed,
    Object? isPopular = null,
  }) {
    return _then(_$DestinationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      isPopular: null == isPopular
          ? _value.isPopular
          : isPopular // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DestinationModelImpl implements _DestinationModel {
  const _$DestinationModelImpl(
      {required this.id,
      required this.name,
      required this.country,
      this.description,
      this.image,
      this.isPopular = false});

  factory _$DestinationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DestinationModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String country;
  @override
  final String? description;
  @override
  final String? image;
  @override
  @JsonKey()
  final bool isPopular;

  @override
  String toString() {
    return 'DestinationModel(id: $id, name: $name, country: $country, description: $description, image: $image, isPopular: $isPopular)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DestinationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.isPopular, isPopular) ||
                other.isPopular == isPopular));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, country, description, image, isPopular);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DestinationModelImplCopyWith<_$DestinationModelImpl> get copyWith =>
      __$$DestinationModelImplCopyWithImpl<_$DestinationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DestinationModelImplToJson(
      this,
    );
  }
}

abstract class _DestinationModel implements DestinationModel {
  const factory _DestinationModel(
      {required final int id,
      required final String name,
      required final String country,
      final String? description,
      final String? image,
      final bool isPopular}) = _$DestinationModelImpl;

  factory _DestinationModel.fromJson(Map<String, dynamic> json) =
      _$DestinationModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get country;
  @override
  String? get description;
  @override
  String? get image;
  @override
  bool get isPopular;
  @override
  @JsonKey(ignore: true)
  _$$DestinationModelImplCopyWith<_$DestinationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
