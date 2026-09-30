// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PlacesTable extends Places with TableInfo<$PlacesTable, Place> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SurfaceType, String> surface =
      GeneratedColumn<String>(
        'surface',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SurfaceType>($PlacesTable.$convertersurface);
  static const VerificationMeta _isIndoorMeta = const VerificationMeta(
    'isIndoor',
  );
  @override
  late final GeneratedColumn<bool> isIndoor = GeneratedColumn<bool>(
    'is_indoor',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_indoor" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    surface,
    isIndoor,
    createdAt,
    lastUsedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'places';
  @override
  VerificationContext validateIntegrity(
    Insertable<Place> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_indoor')) {
      context.handle(
        _isIndoorMeta,
        isIndoor.isAcceptableOrUnknown(data['is_indoor']!, _isIndoorMeta),
      );
    } else if (isInserting) {
      context.missing(_isIndoorMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Place map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Place(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      surface: $PlacesTable.$convertersurface.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}surface'],
        )!,
      ),
      isIndoor: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_indoor'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      )!,
    );
  }

  @override
  $PlacesTable createAlias(String alias) {
    return $PlacesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SurfaceType, String, String> $convertersurface =
      const EnumNameConverter<SurfaceType>(SurfaceType.values);
}

class Place extends DataClass implements Insertable<Place> {
  final int id;

  /// 같은 이름의 장소를 두 번 등록하지 못하게 막는다.
  final String name;
  final SurfaceType surface;
  final bool isIndoor;
  final DateTime createdAt;

  /// 작성 화면의 "최근 사용 순" 장소 칩 정렬에 쓴다.
  final DateTime lastUsedAt;
  const Place({
    required this.id,
    required this.name,
    required this.surface,
    required this.isIndoor,
    required this.createdAt,
    required this.lastUsedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['surface'] = Variable<String>(
        $PlacesTable.$convertersurface.toSql(surface),
      );
    }
    map['is_indoor'] = Variable<bool>(isIndoor);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    return map;
  }

  PlacesCompanion toCompanion(bool nullToAbsent) {
    return PlacesCompanion(
      id: Value(id),
      name: Value(name),
      surface: Value(surface),
      isIndoor: Value(isIndoor),
      createdAt: Value(createdAt),
      lastUsedAt: Value(lastUsedAt),
    );
  }

  factory Place.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Place(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      surface: $PlacesTable.$convertersurface.fromJson(
        serializer.fromJson<String>(json['surface']),
      ),
      isIndoor: serializer.fromJson<bool>(json['isIndoor']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastUsedAt: serializer.fromJson<DateTime>(json['lastUsedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'surface': serializer.toJson<String>(
        $PlacesTable.$convertersurface.toJson(surface),
      ),
      'isIndoor': serializer.toJson<bool>(isIndoor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastUsedAt': serializer.toJson<DateTime>(lastUsedAt),
    };
  }

  Place copyWith({
    int? id,
    String? name,
    SurfaceType? surface,
    bool? isIndoor,
    DateTime? createdAt,
    DateTime? lastUsedAt,
  }) => Place(
    id: id ?? this.id,
    name: name ?? this.name,
    surface: surface ?? this.surface,
    isIndoor: isIndoor ?? this.isIndoor,
    createdAt: createdAt ?? this.createdAt,
    lastUsedAt: lastUsedAt ?? this.lastUsedAt,
  );
  Place copyWithCompanion(PlacesCompanion data) {
    return Place(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      surface: data.surface.present ? data.surface.value : this.surface,
      isIndoor: data.isIndoor.present ? data.isIndoor.value : this.isIndoor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Place(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('surface: $surface, ')
          ..write('isIndoor: $isIndoor, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, surface, isIndoor, createdAt, lastUsedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Place &&
          other.id == this.id &&
          other.name == this.name &&
          other.surface == this.surface &&
          other.isIndoor == this.isIndoor &&
          other.createdAt == this.createdAt &&
          other.lastUsedAt == this.lastUsedAt);
}

class PlacesCompanion extends UpdateCompanion<Place> {
  final Value<int> id;
  final Value<String> name;
  final Value<SurfaceType> surface;
  final Value<bool> isIndoor;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastUsedAt;
  const PlacesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.surface = const Value.absent(),
    this.isIndoor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
  });
  PlacesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required SurfaceType surface,
    required bool isIndoor,
    this.createdAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
  }) : name = Value(name),
       surface = Value(surface),
       isIndoor = Value(isIndoor);
  static Insertable<Place> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? surface,
    Expression<bool>? isIndoor,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastUsedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (surface != null) 'surface': surface,
      if (isIndoor != null) 'is_indoor': isIndoor,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
    });
  }

  PlacesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<SurfaceType>? surface,
    Value<bool>? isIndoor,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastUsedAt,
  }) {
    return PlacesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      surface: surface ?? this.surface,
      isIndoor: isIndoor ?? this.isIndoor,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (surface.present) {
      map['surface'] = Variable<String>(
        $PlacesTable.$convertersurface.toSql(surface.value),
      );
    }
    if (isIndoor.present) {
      map['is_indoor'] = Variable<bool>(isIndoor.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('surface: $surface, ')
          ..write('isIndoor: $isIndoor, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt')
          ..write(')'))
        .toString();
  }
}

class $CuesTable extends Cues with TableInfo<$CuesTable, Cue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cueTextMeta = const VerificationMeta(
    'cueText',
  );
  @override
  late final GeneratedColumn<String> cueText = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [id, cueText, createdAt, lastUsedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cues';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('text')) {
      context.handle(
        _cueTextMeta,
        cueText.isAcceptableOrUnknown(data['text']!, _cueTextMeta),
      );
    } else if (isInserting) {
      context.missing(_cueTextMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cue(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cueText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      )!,
    );
  }

  @override
  $CuesTable createAlias(String alias) {
    return $CuesTable(attachedDatabase, alias);
  }
}

class Cue extends DataClass implements Insertable<Cue> {
  final int id;
  final String cueText;
  final DateTime createdAt;
  final DateTime lastUsedAt;
  const Cue({
    required this.id,
    required this.cueText,
    required this.createdAt,
    required this.lastUsedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['text'] = Variable<String>(cueText);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    return map;
  }

  CuesCompanion toCompanion(bool nullToAbsent) {
    return CuesCompanion(
      id: Value(id),
      cueText: Value(cueText),
      createdAt: Value(createdAt),
      lastUsedAt: Value(lastUsedAt),
    );
  }

  factory Cue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cue(
      id: serializer.fromJson<int>(json['id']),
      cueText: serializer.fromJson<String>(json['cueText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastUsedAt: serializer.fromJson<DateTime>(json['lastUsedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cueText': serializer.toJson<String>(cueText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastUsedAt': serializer.toJson<DateTime>(lastUsedAt),
    };
  }

  Cue copyWith({
    int? id,
    String? cueText,
    DateTime? createdAt,
    DateTime? lastUsedAt,
  }) => Cue(
    id: id ?? this.id,
    cueText: cueText ?? this.cueText,
    createdAt: createdAt ?? this.createdAt,
    lastUsedAt: lastUsedAt ?? this.lastUsedAt,
  );
  Cue copyWithCompanion(CuesCompanion data) {
    return Cue(
      id: data.id.present ? data.id.value : this.id,
      cueText: data.cueText.present ? data.cueText.value : this.cueText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cue(')
          ..write('id: $id, ')
          ..write('cueText: $cueText, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, cueText, createdAt, lastUsedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cue &&
          other.id == this.id &&
          other.cueText == this.cueText &&
          other.createdAt == this.createdAt &&
          other.lastUsedAt == this.lastUsedAt);
}

class CuesCompanion extends UpdateCompanion<Cue> {
  final Value<int> id;
  final Value<String> cueText;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastUsedAt;
  const CuesCompanion({
    this.id = const Value.absent(),
    this.cueText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
  });
  CuesCompanion.insert({
    this.id = const Value.absent(),
    required String cueText,
    this.createdAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
  }) : cueText = Value(cueText);
  static Insertable<Cue> custom({
    Expression<int>? id,
    Expression<String>? cueText,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastUsedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cueText != null) 'text': cueText,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
    });
  }

  CuesCompanion copyWith({
    Value<int>? id,
    Value<String>? cueText,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastUsedAt,
  }) {
    return CuesCompanion(
      id: id ?? this.id,
      cueText: cueText ?? this.cueText,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cueText.present) {
      map['text'] = Variable<String>(cueText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CuesCompanion(')
          ..write('id: $id, ')
          ..write('cueText: $cueText, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SessionType, String> sessionType =
      GeneratedColumn<String>(
        'session_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(SessionType.game.name),
      ).withConverter<SessionType>($SessionsTable.$convertersessionType);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinutesMeta = const VerificationMeta(
    'startMinutes',
  );
  @override
  late final GeneratedColumn<int> startMinutes = GeneratedColumn<int>(
    'start_minutes',
    aliasedName,
    true,
    check: () => ComparableExpr(startMinutes).isBetweenValues(360, 1440),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endMinutesMeta = const VerificationMeta(
    'endMinutes',
  );
  @override
  late final GeneratedColumn<int> endMinutes = GeneratedColumn<int>(
    'end_minutes',
    aliasedName,
    true,
    check: () => ComparableExpr(endMinutes).isBetweenValues(360, 1440),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<int> placeId = GeneratedColumn<int>(
    'place_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES places (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SurfaceType?, String>
  surfaceSnapshot = GeneratedColumn<String>(
    'surface_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<SurfaceType?>($SessionsTable.$convertersurfaceSnapshotn);
  static const VerificationMeta _isIndoorSnapshotMeta = const VerificationMeta(
    'isIndoorSnapshot',
  );
  @override
  late final GeneratedColumn<bool> isIndoorSnapshot = GeneratedColumn<bool>(
    'is_indoor_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_indoor_snapshot" IN (0, 1))',
    ),
  );
  static const VerificationMeta _placeNameSnapshotMeta = const VerificationMeta(
    'placeNameSnapshot',
  );
  @override
  late final GeneratedColumn<String> placeNameSnapshot =
      GeneratedColumn<String>(
        'place_name_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _conditionScoreMeta = const VerificationMeta(
    'conditionScore',
  );
  @override
  late final GeneratedColumn<int> conditionScore = GeneratedColumn<int>(
    'condition_score',
    aliasedName,
    true,
    check: () => ComparableExpr(conditionScore).isBetweenValues(1, 3),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LastMealBucket?, String>
  lastMealBucket = GeneratedColumn<String>(
    'last_meal_bucket',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<LastMealBucket?>($SessionsTable.$converterlastMealBucketn);
  static const VerificationMeta _cueIdMeta = const VerificationMeta('cueId');
  @override
  late final GeneratedColumn<int> cueId = GeneratedColumn<int>(
    'cue_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cues (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CueApplied?, String> cueApplied =
      GeneratedColumn<String>(
        'cue_applied',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<CueApplied?>($SessionsTable.$convertercueAppliedn);
  @override
  late final GeneratedColumnWithTypeConverter<SessionStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(SessionStatus.draft.name),
      ).withConverter<SessionStatus>($SessionsTable.$converterstatus);
  static const VerificationMeta _tagReviewedMeta = const VerificationMeta(
    'tagReviewed',
  );
  @override
  late final GeneratedColumn<bool> tagReviewed = GeneratedColumn<bool>(
    'tag_reviewed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("tag_reviewed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionType,
    date,
    startMinutes,
    endMinutes,
    placeId,
    surfaceSnapshot,
    isIndoorSnapshot,
    placeNameSnapshot,
    conditionScore,
    lastMealBucket,
    cueId,
    cueApplied,
    status,
    tagReviewed,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('start_minutes')) {
      context.handle(
        _startMinutesMeta,
        startMinutes.isAcceptableOrUnknown(
          data['start_minutes']!,
          _startMinutesMeta,
        ),
      );
    }
    if (data.containsKey('end_minutes')) {
      context.handle(
        _endMinutesMeta,
        endMinutes.isAcceptableOrUnknown(data['end_minutes']!, _endMinutesMeta),
      );
    }
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
      );
    }
    if (data.containsKey('is_indoor_snapshot')) {
      context.handle(
        _isIndoorSnapshotMeta,
        isIndoorSnapshot.isAcceptableOrUnknown(
          data['is_indoor_snapshot']!,
          _isIndoorSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('place_name_snapshot')) {
      context.handle(
        _placeNameSnapshotMeta,
        placeNameSnapshot.isAcceptableOrUnknown(
          data['place_name_snapshot']!,
          _placeNameSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('condition_score')) {
      context.handle(
        _conditionScoreMeta,
        conditionScore.isAcceptableOrUnknown(
          data['condition_score']!,
          _conditionScoreMeta,
        ),
      );
    }
    if (data.containsKey('cue_id')) {
      context.handle(
        _cueIdMeta,
        cueId.isAcceptableOrUnknown(data['cue_id']!, _cueIdMeta),
      );
    }
    if (data.containsKey('tag_reviewed')) {
      context.handle(
        _tagReviewedMeta,
        tagReviewed.isAcceptableOrUnknown(
          data['tag_reviewed']!,
          _tagReviewedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionType: $SessionsTable.$convertersessionType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}session_type'],
        )!,
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      startMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minutes'],
      ),
      endMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minutes'],
      ),
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}place_id'],
      ),
      surfaceSnapshot: $SessionsTable.$convertersurfaceSnapshotn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}surface_snapshot'],
        ),
      ),
      isIndoorSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_indoor_snapshot'],
      ),
      placeNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_name_snapshot'],
      ),
      conditionScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}condition_score'],
      ),
      lastMealBucket: $SessionsTable.$converterlastMealBucketn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}last_meal_bucket'],
        ),
      ),
      cueId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cue_id'],
      ),
      cueApplied: $SessionsTable.$convertercueAppliedn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}cue_applied'],
        ),
      ),
      status: $SessionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      tagReviewed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}tag_reviewed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SessionType, String, String> $convertersessionType =
      const EnumNameConverter<SessionType>(SessionType.values);
  static JsonTypeConverter2<SurfaceType, String, String>
  $convertersurfaceSnapshot = const EnumNameConverter<SurfaceType>(
    SurfaceType.values,
  );
  static JsonTypeConverter2<SurfaceType?, String?, String?>
  $convertersurfaceSnapshotn = JsonTypeConverter2.asNullable(
    $convertersurfaceSnapshot,
  );
  static JsonTypeConverter2<LastMealBucket, String, String>
  $converterlastMealBucket = const EnumNameConverter<LastMealBucket>(
    LastMealBucket.values,
  );
  static JsonTypeConverter2<LastMealBucket?, String?, String?>
  $converterlastMealBucketn = JsonTypeConverter2.asNullable(
    $converterlastMealBucket,
  );
  static JsonTypeConverter2<CueApplied, String, String> $convertercueApplied =
      const EnumNameConverter<CueApplied>(CueApplied.values);
  static JsonTypeConverter2<CueApplied?, String?, String?>
  $convertercueAppliedn = JsonTypeConverter2.asNullable($convertercueApplied);
  static JsonTypeConverter2<SessionStatus, String, String> $converterstatus =
      const EnumNameConverter<SessionStatus>(SessionStatus.values);
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final SessionType sessionType;

  /// 날짜만 의미가 있는 값. 로컬 자정으로 정규화해서 넣는다.
  final DateTime date;

  /// 자정 기준 분. 예: 18:00 → 1080. 범위는 06:00(360)~24:00(1440).
  final int? startMinutes;
  final int? endMinutes;
  final int? placeId;
  final SurfaceType? surfaceSnapshot;
  final bool? isIndoorSnapshot;
  final String? placeNameSnapshot;

  /// 1=별로, 2=쏘쏘, 3=굿
  final int? conditionScore;
  final LastMealBucket? lastMealBucket;
  final int? cueId;

  /// 큐를 게임 중 의식적으로 적용했는지
  final CueApplied? cueApplied;
  final SessionStatus status;

  /// 태그·평가 확인(2단계) 완료 여부
  final bool tagReviewed;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Session({
    required this.id,
    required this.sessionType,
    required this.date,
    this.startMinutes,
    this.endMinutes,
    this.placeId,
    this.surfaceSnapshot,
    this.isIndoorSnapshot,
    this.placeNameSnapshot,
    this.conditionScore,
    this.lastMealBucket,
    this.cueId,
    this.cueApplied,
    required this.status,
    required this.tagReviewed,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['session_type'] = Variable<String>(
        $SessionsTable.$convertersessionType.toSql(sessionType),
      );
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || startMinutes != null) {
      map['start_minutes'] = Variable<int>(startMinutes);
    }
    if (!nullToAbsent || endMinutes != null) {
      map['end_minutes'] = Variable<int>(endMinutes);
    }
    if (!nullToAbsent || placeId != null) {
      map['place_id'] = Variable<int>(placeId);
    }
    if (!nullToAbsent || surfaceSnapshot != null) {
      map['surface_snapshot'] = Variable<String>(
        $SessionsTable.$convertersurfaceSnapshotn.toSql(surfaceSnapshot),
      );
    }
    if (!nullToAbsent || isIndoorSnapshot != null) {
      map['is_indoor_snapshot'] = Variable<bool>(isIndoorSnapshot);
    }
    if (!nullToAbsent || placeNameSnapshot != null) {
      map['place_name_snapshot'] = Variable<String>(placeNameSnapshot);
    }
    if (!nullToAbsent || conditionScore != null) {
      map['condition_score'] = Variable<int>(conditionScore);
    }
    if (!nullToAbsent || lastMealBucket != null) {
      map['last_meal_bucket'] = Variable<String>(
        $SessionsTable.$converterlastMealBucketn.toSql(lastMealBucket),
      );
    }
    if (!nullToAbsent || cueId != null) {
      map['cue_id'] = Variable<int>(cueId);
    }
    if (!nullToAbsent || cueApplied != null) {
      map['cue_applied'] = Variable<String>(
        $SessionsTable.$convertercueAppliedn.toSql(cueApplied),
      );
    }
    {
      map['status'] = Variable<String>(
        $SessionsTable.$converterstatus.toSql(status),
      );
    }
    map['tag_reviewed'] = Variable<bool>(tagReviewed);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      sessionType: Value(sessionType),
      date: Value(date),
      startMinutes: startMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(startMinutes),
      endMinutes: endMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(endMinutes),
      placeId: placeId == null && nullToAbsent
          ? const Value.absent()
          : Value(placeId),
      surfaceSnapshot: surfaceSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(surfaceSnapshot),
      isIndoorSnapshot: isIndoorSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(isIndoorSnapshot),
      placeNameSnapshot: placeNameSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(placeNameSnapshot),
      conditionScore: conditionScore == null && nullToAbsent
          ? const Value.absent()
          : Value(conditionScore),
      lastMealBucket: lastMealBucket == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMealBucket),
      cueId: cueId == null && nullToAbsent
          ? const Value.absent()
          : Value(cueId),
      cueApplied: cueApplied == null && nullToAbsent
          ? const Value.absent()
          : Value(cueApplied),
      status: Value(status),
      tagReviewed: Value(tagReviewed),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      sessionType: $SessionsTable.$convertersessionType.fromJson(
        serializer.fromJson<String>(json['sessionType']),
      ),
      date: serializer.fromJson<DateTime>(json['date']),
      startMinutes: serializer.fromJson<int?>(json['startMinutes']),
      endMinutes: serializer.fromJson<int?>(json['endMinutes']),
      placeId: serializer.fromJson<int?>(json['placeId']),
      surfaceSnapshot: $SessionsTable.$convertersurfaceSnapshotn.fromJson(
        serializer.fromJson<String?>(json['surfaceSnapshot']),
      ),
      isIndoorSnapshot: serializer.fromJson<bool?>(json['isIndoorSnapshot']),
      placeNameSnapshot: serializer.fromJson<String?>(
        json['placeNameSnapshot'],
      ),
      conditionScore: serializer.fromJson<int?>(json['conditionScore']),
      lastMealBucket: $SessionsTable.$converterlastMealBucketn.fromJson(
        serializer.fromJson<String?>(json['lastMealBucket']),
      ),
      cueId: serializer.fromJson<int?>(json['cueId']),
      cueApplied: $SessionsTable.$convertercueAppliedn.fromJson(
        serializer.fromJson<String?>(json['cueApplied']),
      ),
      status: $SessionsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      tagReviewed: serializer.fromJson<bool>(json['tagReviewed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionType': serializer.toJson<String>(
        $SessionsTable.$convertersessionType.toJson(sessionType),
      ),
      'date': serializer.toJson<DateTime>(date),
      'startMinutes': serializer.toJson<int?>(startMinutes),
      'endMinutes': serializer.toJson<int?>(endMinutes),
      'placeId': serializer.toJson<int?>(placeId),
      'surfaceSnapshot': serializer.toJson<String?>(
        $SessionsTable.$convertersurfaceSnapshotn.toJson(surfaceSnapshot),
      ),
      'isIndoorSnapshot': serializer.toJson<bool?>(isIndoorSnapshot),
      'placeNameSnapshot': serializer.toJson<String?>(placeNameSnapshot),
      'conditionScore': serializer.toJson<int?>(conditionScore),
      'lastMealBucket': serializer.toJson<String?>(
        $SessionsTable.$converterlastMealBucketn.toJson(lastMealBucket),
      ),
      'cueId': serializer.toJson<int?>(cueId),
      'cueApplied': serializer.toJson<String?>(
        $SessionsTable.$convertercueAppliedn.toJson(cueApplied),
      ),
      'status': serializer.toJson<String>(
        $SessionsTable.$converterstatus.toJson(status),
      ),
      'tagReviewed': serializer.toJson<bool>(tagReviewed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Session copyWith({
    int? id,
    SessionType? sessionType,
    DateTime? date,
    Value<int?> startMinutes = const Value.absent(),
    Value<int?> endMinutes = const Value.absent(),
    Value<int?> placeId = const Value.absent(),
    Value<SurfaceType?> surfaceSnapshot = const Value.absent(),
    Value<bool?> isIndoorSnapshot = const Value.absent(),
    Value<String?> placeNameSnapshot = const Value.absent(),
    Value<int?> conditionScore = const Value.absent(),
    Value<LastMealBucket?> lastMealBucket = const Value.absent(),
    Value<int?> cueId = const Value.absent(),
    Value<CueApplied?> cueApplied = const Value.absent(),
    SessionStatus? status,
    bool? tagReviewed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Session(
    id: id ?? this.id,
    sessionType: sessionType ?? this.sessionType,
    date: date ?? this.date,
    startMinutes: startMinutes.present ? startMinutes.value : this.startMinutes,
    endMinutes: endMinutes.present ? endMinutes.value : this.endMinutes,
    placeId: placeId.present ? placeId.value : this.placeId,
    surfaceSnapshot: surfaceSnapshot.present
        ? surfaceSnapshot.value
        : this.surfaceSnapshot,
    isIndoorSnapshot: isIndoorSnapshot.present
        ? isIndoorSnapshot.value
        : this.isIndoorSnapshot,
    placeNameSnapshot: placeNameSnapshot.present
        ? placeNameSnapshot.value
        : this.placeNameSnapshot,
    conditionScore: conditionScore.present
        ? conditionScore.value
        : this.conditionScore,
    lastMealBucket: lastMealBucket.present
        ? lastMealBucket.value
        : this.lastMealBucket,
    cueId: cueId.present ? cueId.value : this.cueId,
    cueApplied: cueApplied.present ? cueApplied.value : this.cueApplied,
    status: status ?? this.status,
    tagReviewed: tagReviewed ?? this.tagReviewed,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      sessionType: data.sessionType.present
          ? data.sessionType.value
          : this.sessionType,
      date: data.date.present ? data.date.value : this.date,
      startMinutes: data.startMinutes.present
          ? data.startMinutes.value
          : this.startMinutes,
      endMinutes: data.endMinutes.present
          ? data.endMinutes.value
          : this.endMinutes,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      surfaceSnapshot: data.surfaceSnapshot.present
          ? data.surfaceSnapshot.value
          : this.surfaceSnapshot,
      isIndoorSnapshot: data.isIndoorSnapshot.present
          ? data.isIndoorSnapshot.value
          : this.isIndoorSnapshot,
      placeNameSnapshot: data.placeNameSnapshot.present
          ? data.placeNameSnapshot.value
          : this.placeNameSnapshot,
      conditionScore: data.conditionScore.present
          ? data.conditionScore.value
          : this.conditionScore,
      lastMealBucket: data.lastMealBucket.present
          ? data.lastMealBucket.value
          : this.lastMealBucket,
      cueId: data.cueId.present ? data.cueId.value : this.cueId,
      cueApplied: data.cueApplied.present
          ? data.cueApplied.value
          : this.cueApplied,
      status: data.status.present ? data.status.value : this.status,
      tagReviewed: data.tagReviewed.present
          ? data.tagReviewed.value
          : this.tagReviewed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('sessionType: $sessionType, ')
          ..write('date: $date, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('placeId: $placeId, ')
          ..write('surfaceSnapshot: $surfaceSnapshot, ')
          ..write('isIndoorSnapshot: $isIndoorSnapshot, ')
          ..write('placeNameSnapshot: $placeNameSnapshot, ')
          ..write('conditionScore: $conditionScore, ')
          ..write('lastMealBucket: $lastMealBucket, ')
          ..write('cueId: $cueId, ')
          ..write('cueApplied: $cueApplied, ')
          ..write('status: $status, ')
          ..write('tagReviewed: $tagReviewed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionType,
    date,
    startMinutes,
    endMinutes,
    placeId,
    surfaceSnapshot,
    isIndoorSnapshot,
    placeNameSnapshot,
    conditionScore,
    lastMealBucket,
    cueId,
    cueApplied,
    status,
    tagReviewed,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.sessionType == this.sessionType &&
          other.date == this.date &&
          other.startMinutes == this.startMinutes &&
          other.endMinutes == this.endMinutes &&
          other.placeId == this.placeId &&
          other.surfaceSnapshot == this.surfaceSnapshot &&
          other.isIndoorSnapshot == this.isIndoorSnapshot &&
          other.placeNameSnapshot == this.placeNameSnapshot &&
          other.conditionScore == this.conditionScore &&
          other.lastMealBucket == this.lastMealBucket &&
          other.cueId == this.cueId &&
          other.cueApplied == this.cueApplied &&
          other.status == this.status &&
          other.tagReviewed == this.tagReviewed &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<SessionType> sessionType;
  final Value<DateTime> date;
  final Value<int?> startMinutes;
  final Value<int?> endMinutes;
  final Value<int?> placeId;
  final Value<SurfaceType?> surfaceSnapshot;
  final Value<bool?> isIndoorSnapshot;
  final Value<String?> placeNameSnapshot;
  final Value<int?> conditionScore;
  final Value<LastMealBucket?> lastMealBucket;
  final Value<int?> cueId;
  final Value<CueApplied?> cueApplied;
  final Value<SessionStatus> status;
  final Value<bool> tagReviewed;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.sessionType = const Value.absent(),
    this.date = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.placeId = const Value.absent(),
    this.surfaceSnapshot = const Value.absent(),
    this.isIndoorSnapshot = const Value.absent(),
    this.placeNameSnapshot = const Value.absent(),
    this.conditionScore = const Value.absent(),
    this.lastMealBucket = const Value.absent(),
    this.cueId = const Value.absent(),
    this.cueApplied = const Value.absent(),
    this.status = const Value.absent(),
    this.tagReviewed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    this.sessionType = const Value.absent(),
    required DateTime date,
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.placeId = const Value.absent(),
    this.surfaceSnapshot = const Value.absent(),
    this.isIndoorSnapshot = const Value.absent(),
    this.placeNameSnapshot = const Value.absent(),
    this.conditionScore = const Value.absent(),
    this.lastMealBucket = const Value.absent(),
    this.cueId = const Value.absent(),
    this.cueApplied = const Value.absent(),
    this.status = const Value.absent(),
    this.tagReviewed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : date = Value(date);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<String>? sessionType,
    Expression<DateTime>? date,
    Expression<int>? startMinutes,
    Expression<int>? endMinutes,
    Expression<int>? placeId,
    Expression<String>? surfaceSnapshot,
    Expression<bool>? isIndoorSnapshot,
    Expression<String>? placeNameSnapshot,
    Expression<int>? conditionScore,
    Expression<String>? lastMealBucket,
    Expression<int>? cueId,
    Expression<String>? cueApplied,
    Expression<String>? status,
    Expression<bool>? tagReviewed,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionType != null) 'session_type': sessionType,
      if (date != null) 'date': date,
      if (startMinutes != null) 'start_minutes': startMinutes,
      if (endMinutes != null) 'end_minutes': endMinutes,
      if (placeId != null) 'place_id': placeId,
      if (surfaceSnapshot != null) 'surface_snapshot': surfaceSnapshot,
      if (isIndoorSnapshot != null) 'is_indoor_snapshot': isIndoorSnapshot,
      if (placeNameSnapshot != null) 'place_name_snapshot': placeNameSnapshot,
      if (conditionScore != null) 'condition_score': conditionScore,
      if (lastMealBucket != null) 'last_meal_bucket': lastMealBucket,
      if (cueId != null) 'cue_id': cueId,
      if (cueApplied != null) 'cue_applied': cueApplied,
      if (status != null) 'status': status,
      if (tagReviewed != null) 'tag_reviewed': tagReviewed,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<SessionType>? sessionType,
    Value<DateTime>? date,
    Value<int?>? startMinutes,
    Value<int?>? endMinutes,
    Value<int?>? placeId,
    Value<SurfaceType?>? surfaceSnapshot,
    Value<bool?>? isIndoorSnapshot,
    Value<String?>? placeNameSnapshot,
    Value<int?>? conditionScore,
    Value<LastMealBucket?>? lastMealBucket,
    Value<int?>? cueId,
    Value<CueApplied?>? cueApplied,
    Value<SessionStatus>? status,
    Value<bool>? tagReviewed,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      sessionType: sessionType ?? this.sessionType,
      date: date ?? this.date,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      placeId: placeId ?? this.placeId,
      surfaceSnapshot: surfaceSnapshot ?? this.surfaceSnapshot,
      isIndoorSnapshot: isIndoorSnapshot ?? this.isIndoorSnapshot,
      placeNameSnapshot: placeNameSnapshot ?? this.placeNameSnapshot,
      conditionScore: conditionScore ?? this.conditionScore,
      lastMealBucket: lastMealBucket ?? this.lastMealBucket,
      cueId: cueId ?? this.cueId,
      cueApplied: cueApplied ?? this.cueApplied,
      status: status ?? this.status,
      tagReviewed: tagReviewed ?? this.tagReviewed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionType.present) {
      map['session_type'] = Variable<String>(
        $SessionsTable.$convertersessionType.toSql(sessionType.value),
      );
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (startMinutes.present) {
      map['start_minutes'] = Variable<int>(startMinutes.value);
    }
    if (endMinutes.present) {
      map['end_minutes'] = Variable<int>(endMinutes.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<int>(placeId.value);
    }
    if (surfaceSnapshot.present) {
      map['surface_snapshot'] = Variable<String>(
        $SessionsTable.$convertersurfaceSnapshotn.toSql(surfaceSnapshot.value),
      );
    }
    if (isIndoorSnapshot.present) {
      map['is_indoor_snapshot'] = Variable<bool>(isIndoorSnapshot.value);
    }
    if (placeNameSnapshot.present) {
      map['place_name_snapshot'] = Variable<String>(placeNameSnapshot.value);
    }
    if (conditionScore.present) {
      map['condition_score'] = Variable<int>(conditionScore.value);
    }
    if (lastMealBucket.present) {
      map['last_meal_bucket'] = Variable<String>(
        $SessionsTable.$converterlastMealBucketn.toSql(lastMealBucket.value),
      );
    }
    if (cueId.present) {
      map['cue_id'] = Variable<int>(cueId.value);
    }
    if (cueApplied.present) {
      map['cue_applied'] = Variable<String>(
        $SessionsTable.$convertercueAppliedn.toSql(cueApplied.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $SessionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (tagReviewed.present) {
      map['tag_reviewed'] = Variable<bool>(tagReviewed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('sessionType: $sessionType, ')
          ..write('date: $date, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('placeId: $placeId, ')
          ..write('surfaceSnapshot: $surfaceSnapshot, ')
          ..write('isIndoorSnapshot: $isIndoorSnapshot, ')
          ..write('placeNameSnapshot: $placeNameSnapshot, ')
          ..write('conditionScore: $conditionScore, ')
          ..write('lastMealBucket: $lastMealBucket, ')
          ..write('cueId: $cueId, ')
          ..write('cueApplied: $cueApplied, ')
          ..write('status: $status, ')
          ..write('tagReviewed: $tagReviewed, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $GamesTable extends Games with TableInfo<$GamesTable, Game> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<GameFormat, String> format =
      GeneratedColumn<String>(
        'format',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<GameFormat>($GamesTable.$converterformat);
  static const VerificationMeta _myScoreMeta = const VerificationMeta(
    'myScore',
  );
  @override
  late final GeneratedColumn<int> myScore = GeneratedColumn<int>(
    'my_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _opponentScoreMeta = const VerificationMeta(
    'opponentScore',
  );
  @override
  late final GeneratedColumn<int> opponentScore = GeneratedColumn<int>(
    'opponent_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    format,
    myScore,
    opponentScore,
    orderIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(
    Insertable<Game> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('my_score')) {
      context.handle(
        _myScoreMeta,
        myScore.isAcceptableOrUnknown(data['my_score']!, _myScoreMeta),
      );
    }
    if (data.containsKey('opponent_score')) {
      context.handle(
        _opponentScoreMeta,
        opponentScore.isAcceptableOrUnknown(
          data['opponent_score']!,
          _opponentScoreMeta,
        ),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Game(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      format: $GamesTable.$converterformat.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}format'],
        )!,
      ),
      myScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}my_score'],
      ),
      opponentScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opponent_score'],
      ),
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GameFormat, String, String> $converterformat =
      const EnumNameConverter<GameFormat>(GameFormat.values);
}

class Game extends DataClass implements Insertable<Game> {
  final int id;
  final int sessionId;
  final GameFormat format;

  /// 둘 다 null 허용 ("스코어 모름")
  final int? myScore;
  final int? opponentScore;
  final int orderIndex;
  const Game({
    required this.id,
    required this.sessionId,
    required this.format,
    this.myScore,
    this.opponentScore,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    {
      map['format'] = Variable<String>(
        $GamesTable.$converterformat.toSql(format),
      );
    }
    if (!nullToAbsent || myScore != null) {
      map['my_score'] = Variable<int>(myScore);
    }
    if (!nullToAbsent || opponentScore != null) {
      map['opponent_score'] = Variable<int>(opponentScore);
    }
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      format: Value(format),
      myScore: myScore == null && nullToAbsent
          ? const Value.absent()
          : Value(myScore),
      opponentScore: opponentScore == null && nullToAbsent
          ? const Value.absent()
          : Value(opponentScore),
      orderIndex: Value(orderIndex),
    );
  }

  factory Game.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Game(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      format: $GamesTable.$converterformat.fromJson(
        serializer.fromJson<String>(json['format']),
      ),
      myScore: serializer.fromJson<int?>(json['myScore']),
      opponentScore: serializer.fromJson<int?>(json['opponentScore']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'format': serializer.toJson<String>(
        $GamesTable.$converterformat.toJson(format),
      ),
      'myScore': serializer.toJson<int?>(myScore),
      'opponentScore': serializer.toJson<int?>(opponentScore),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  Game copyWith({
    int? id,
    int? sessionId,
    GameFormat? format,
    Value<int?> myScore = const Value.absent(),
    Value<int?> opponentScore = const Value.absent(),
    int? orderIndex,
  }) => Game(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    format: format ?? this.format,
    myScore: myScore.present ? myScore.value : this.myScore,
    opponentScore: opponentScore.present
        ? opponentScore.value
        : this.opponentScore,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  Game copyWithCompanion(GamesCompanion data) {
    return Game(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      format: data.format.present ? data.format.value : this.format,
      myScore: data.myScore.present ? data.myScore.value : this.myScore,
      opponentScore: data.opponentScore.present
          ? data.opponentScore.value
          : this.opponentScore,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('format: $format, ')
          ..write('myScore: $myScore, ')
          ..write('opponentScore: $opponentScore, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, format, myScore, opponentScore, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.format == this.format &&
          other.myScore == this.myScore &&
          other.opponentScore == this.opponentScore &&
          other.orderIndex == this.orderIndex);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<GameFormat> format;
  final Value<int?> myScore;
  final Value<int?> opponentScore;
  final Value<int> orderIndex;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.format = const Value.absent(),
    this.myScore = const Value.absent(),
    this.opponentScore = const Value.absent(),
    this.orderIndex = const Value.absent(),
  });
  GamesCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required GameFormat format,
    this.myScore = const Value.absent(),
    this.opponentScore = const Value.absent(),
    required int orderIndex,
  }) : sessionId = Value(sessionId),
       format = Value(format),
       orderIndex = Value(orderIndex);
  static Insertable<Game> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? format,
    Expression<int>? myScore,
    Expression<int>? opponentScore,
    Expression<int>? orderIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (format != null) 'format': format,
      if (myScore != null) 'my_score': myScore,
      if (opponentScore != null) 'opponent_score': opponentScore,
      if (orderIndex != null) 'order_index': orderIndex,
    });
  }

  GamesCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<GameFormat>? format,
    Value<int?>? myScore,
    Value<int?>? opponentScore,
    Value<int>? orderIndex,
  }) {
    return GamesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      format: format ?? this.format,
      myScore: myScore ?? this.myScore,
      opponentScore: opponentScore ?? this.opponentScore,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(
        $GamesTable.$converterformat.toSql(format.value),
      );
    }
    if (myScore.present) {
      map['my_score'] = Variable<int>(myScore.value);
    }
    if (opponentScore.present) {
      map['opponent_score'] = Variable<int>(opponentScore.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('format: $format, ')
          ..write('myScore: $myScore, ')
          ..write('opponentScore: $opponentScore, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }
}

class $MemosTable extends Memos with TableInfo<$MemosTable, Memo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MemoEvaluation?, String>
  evaluation = GeneratedColumn<String>(
    'evaluation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<MemoEvaluation?>($MemosTable.$converterevaluationn);
  @override
  late final GeneratedColumnWithTypeConverter<EvaluationStatus?, String>
  evaluationStatus = GeneratedColumn<String>(
    'evaluation_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<EvaluationStatus?>($MemosTable.$converterevaluationStatusn);
  static const VerificationMeta _lastTaggedContentMeta = const VerificationMeta(
    'lastTaggedContent',
  );
  @override
  late final GeneratedColumn<String> lastTaggedContent =
      GeneratedColumn<String>(
        'last_tagged_content',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    content,
    orderIndex,
    evaluation,
    evaluationStatus,
    lastTaggedContent,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Memo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('last_tagged_content')) {
      context.handle(
        _lastTaggedContentMeta,
        lastTaggedContent.isAcceptableOrUnknown(
          data['last_tagged_content']!,
          _lastTaggedContentMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Memo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Memo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      evaluation: $MemosTable.$converterevaluationn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}evaluation'],
        ),
      ),
      evaluationStatus: $MemosTable.$converterevaluationStatusn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}evaluation_status'],
        ),
      ),
      lastTaggedContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_tagged_content'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MemosTable createAlias(String alias) {
    return $MemosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MemoEvaluation, String, String>
  $converterevaluation = const EnumNameConverter<MemoEvaluation>(
    MemoEvaluation.values,
  );
  static JsonTypeConverter2<MemoEvaluation?, String?, String?>
  $converterevaluationn = JsonTypeConverter2.asNullable($converterevaluation);
  static JsonTypeConverter2<EvaluationStatus, String, String>
  $converterevaluationStatus = const EnumNameConverter<EvaluationStatus>(
    EvaluationStatus.values,
  );
  static JsonTypeConverter2<EvaluationStatus?, String?, String?>
  $converterevaluationStatusn = JsonTypeConverter2.asNullable(
    $converterevaluationStatus,
  );
}

class Memo extends DataClass implements Insertable<Memo> {
  final int id;
  final int sessionId;
  final String content;
  final int orderIndex;
  final MemoEvaluation? evaluation;

  /// evaluation이 null이면 이 값도 null이다.
  final EvaluationStatus? evaluationStatus;

  /// 자동 태그·평가 추천을 마지막으로 돌린 시점의 content.
  /// 이 값과 content가 같으면 다시 추천을 돌리지 않는다.
  final String? lastTaggedContent;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Memo({
    required this.id,
    required this.sessionId,
    required this.content,
    required this.orderIndex,
    this.evaluation,
    this.evaluationStatus,
    this.lastTaggedContent,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['content'] = Variable<String>(content);
    map['order_index'] = Variable<int>(orderIndex);
    if (!nullToAbsent || evaluation != null) {
      map['evaluation'] = Variable<String>(
        $MemosTable.$converterevaluationn.toSql(evaluation),
      );
    }
    if (!nullToAbsent || evaluationStatus != null) {
      map['evaluation_status'] = Variable<String>(
        $MemosTable.$converterevaluationStatusn.toSql(evaluationStatus),
      );
    }
    if (!nullToAbsent || lastTaggedContent != null) {
      map['last_tagged_content'] = Variable<String>(lastTaggedContent);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MemosCompanion toCompanion(bool nullToAbsent) {
    return MemosCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      content: Value(content),
      orderIndex: Value(orderIndex),
      evaluation: evaluation == null && nullToAbsent
          ? const Value.absent()
          : Value(evaluation),
      evaluationStatus: evaluationStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(evaluationStatus),
      lastTaggedContent: lastTaggedContent == null && nullToAbsent
          ? const Value.absent()
          : Value(lastTaggedContent),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Memo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Memo(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      content: serializer.fromJson<String>(json['content']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      evaluation: $MemosTable.$converterevaluationn.fromJson(
        serializer.fromJson<String?>(json['evaluation']),
      ),
      evaluationStatus: $MemosTable.$converterevaluationStatusn.fromJson(
        serializer.fromJson<String?>(json['evaluationStatus']),
      ),
      lastTaggedContent: serializer.fromJson<String?>(
        json['lastTaggedContent'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'content': serializer.toJson<String>(content),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'evaluation': serializer.toJson<String?>(
        $MemosTable.$converterevaluationn.toJson(evaluation),
      ),
      'evaluationStatus': serializer.toJson<String?>(
        $MemosTable.$converterevaluationStatusn.toJson(evaluationStatus),
      ),
      'lastTaggedContent': serializer.toJson<String?>(lastTaggedContent),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Memo copyWith({
    int? id,
    int? sessionId,
    String? content,
    int? orderIndex,
    Value<MemoEvaluation?> evaluation = const Value.absent(),
    Value<EvaluationStatus?> evaluationStatus = const Value.absent(),
    Value<String?> lastTaggedContent = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Memo(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    content: content ?? this.content,
    orderIndex: orderIndex ?? this.orderIndex,
    evaluation: evaluation.present ? evaluation.value : this.evaluation,
    evaluationStatus: evaluationStatus.present
        ? evaluationStatus.value
        : this.evaluationStatus,
    lastTaggedContent: lastTaggedContent.present
        ? lastTaggedContent.value
        : this.lastTaggedContent,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Memo copyWithCompanion(MemosCompanion data) {
    return Memo(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      content: data.content.present ? data.content.value : this.content,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      evaluation: data.evaluation.present
          ? data.evaluation.value
          : this.evaluation,
      evaluationStatus: data.evaluationStatus.present
          ? data.evaluationStatus.value
          : this.evaluationStatus,
      lastTaggedContent: data.lastTaggedContent.present
          ? data.lastTaggedContent.value
          : this.lastTaggedContent,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Memo(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('content: $content, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('evaluation: $evaluation, ')
          ..write('evaluationStatus: $evaluationStatus, ')
          ..write('lastTaggedContent: $lastTaggedContent, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    content,
    orderIndex,
    evaluation,
    evaluationStatus,
    lastTaggedContent,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Memo &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.content == this.content &&
          other.orderIndex == this.orderIndex &&
          other.evaluation == this.evaluation &&
          other.evaluationStatus == this.evaluationStatus &&
          other.lastTaggedContent == this.lastTaggedContent &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MemosCompanion extends UpdateCompanion<Memo> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<String> content;
  final Value<int> orderIndex;
  final Value<MemoEvaluation?> evaluation;
  final Value<EvaluationStatus?> evaluationStatus;
  final Value<String?> lastTaggedContent;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MemosCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.content = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.evaluation = const Value.absent(),
    this.evaluationStatus = const Value.absent(),
    this.lastTaggedContent = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MemosCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required String content,
    required int orderIndex,
    this.evaluation = const Value.absent(),
    this.evaluationStatus = const Value.absent(),
    this.lastTaggedContent = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : sessionId = Value(sessionId),
       content = Value(content),
       orderIndex = Value(orderIndex);
  static Insertable<Memo> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<String>? content,
    Expression<int>? orderIndex,
    Expression<String>? evaluation,
    Expression<String>? evaluationStatus,
    Expression<String>? lastTaggedContent,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (content != null) 'content': content,
      if (orderIndex != null) 'order_index': orderIndex,
      if (evaluation != null) 'evaluation': evaluation,
      if (evaluationStatus != null) 'evaluation_status': evaluationStatus,
      if (lastTaggedContent != null) 'last_tagged_content': lastTaggedContent,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MemosCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<String>? content,
    Value<int>? orderIndex,
    Value<MemoEvaluation?>? evaluation,
    Value<EvaluationStatus?>? evaluationStatus,
    Value<String?>? lastTaggedContent,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return MemosCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      content: content ?? this.content,
      orderIndex: orderIndex ?? this.orderIndex,
      evaluation: evaluation ?? this.evaluation,
      evaluationStatus: evaluationStatus ?? this.evaluationStatus,
      lastTaggedContent: lastTaggedContent ?? this.lastTaggedContent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (evaluation.present) {
      map['evaluation'] = Variable<String>(
        $MemosTable.$converterevaluationn.toSql(evaluation.value),
      );
    }
    if (evaluationStatus.present) {
      map['evaluation_status'] = Variable<String>(
        $MemosTable.$converterevaluationStatusn.toSql(evaluationStatus.value),
      );
    }
    if (lastTaggedContent.present) {
      map['last_tagged_content'] = Variable<String>(lastTaggedContent.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemosCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('content: $content, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('evaluation: $evaluation, ')
          ..write('evaluationStatus: $evaluationStatus, ')
          ..write('lastTaggedContent: $lastTaggedContent, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TagCategory, String> category =
      GeneratedColumn<String>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TagCategory>($TagsTable.$convertercategory);
  static const VerificationMeta _parentTagIdMeta = const VerificationMeta(
    'parentTagId',
  );
  @override
  late final GeneratedColumn<int> parentTagId = GeneratedColumn<int>(
    'parent_tag_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id)',
    ),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: DateTime.now,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    parentTagId,
    isArchived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_tag_id')) {
      context.handle(
        _parentTagIdMeta,
        parentTagId.isAcceptableOrUnknown(
          data['parent_tag_id']!,
          _parentTagIdMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: $TagsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      parentTagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_tag_id'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TagCategory, String, String> $convertercategory =
      const EnumNameConverter<TagCategory>(TagCategory.values);
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String name;
  final TagCategory category;

  /// 예: 백발리의 부모는 발리. 부모 태그로 조회하면 자식도 포함한다.
  /// 자기참조이고, 자식이 가리키는 부모는 지울 수 없게 둔다(cascade 없음).
  final int? parentTagId;
  final bool isArchived;
  final DateTime createdAt;
  const Tag({
    required this.id,
    required this.name,
    required this.category,
    this.parentTagId,
    required this.isArchived,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['category'] = Variable<String>(
        $TagsTable.$convertercategory.toSql(category),
      );
    }
    if (!nullToAbsent || parentTagId != null) {
      map['parent_tag_id'] = Variable<int>(parentTagId);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      parentTagId: parentTagId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentTagId),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: $TagsTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      parentTagId: serializer.fromJson<int?>(json['parentTagId']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(
        $TagsTable.$convertercategory.toJson(category),
      ),
      'parentTagId': serializer.toJson<int?>(parentTagId),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Tag copyWith({
    int? id,
    String? name,
    TagCategory? category,
    Value<int?> parentTagId = const Value.absent(),
    bool? isArchived,
    DateTime? createdAt,
  }) => Tag(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    parentTagId: parentTagId.present ? parentTagId.value : this.parentTagId,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      parentTagId: data.parentTagId.present
          ? data.parentTagId.value
          : this.parentTagId,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('parentTagId: $parentTagId, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, category, parentTagId, isArchived, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.parentTagId == this.parentTagId &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  final Value<TagCategory> category;
  final Value<int?> parentTagId;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.parentTagId = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required TagCategory category,
    this.parentTagId = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       category = Value(category);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? parentTagId,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (parentTagId != null) 'parent_tag_id': parentTagId,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TagsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<TagCategory>? category,
    Value<int?>? parentTagId,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      parentTagId: parentTagId ?? this.parentTagId,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $TagsTable.$convertercategory.toSql(category.value),
      );
    }
    if (parentTagId.present) {
      map['parent_tag_id'] = Variable<int>(parentTagId.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('parentTagId: $parentTagId, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TagAliasesTable extends TagAliases
    with TableInfo<$TagAliasesTable, TagAliase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagAliasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
    'alias',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AliasConfidence, String>
  confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<AliasConfidence>($TagAliasesTable.$converterconfidence);
  @override
  List<GeneratedColumn> get $columns => [id, tagId, alias, confidence];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tag_aliases';
  @override
  VerificationContext validateIntegrity(
    Insertable<TagAliase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
        _aliasMeta,
        alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta),
      );
    } else if (isInserting) {
      context.missing(_aliasMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {tagId, alias},
  ];
  @override
  TagAliase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagAliase(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
      alias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alias'],
      )!,
      confidence: $TagAliasesTable.$converterconfidence.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}confidence'],
        )!,
      ),
    );
  }

  @override
  $TagAliasesTable createAlias(String alias) {
    return $TagAliasesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AliasConfidence, String, String>
  $converterconfidence = const EnumNameConverter<AliasConfidence>(
    AliasConfidence.values,
  );
}

class TagAliase extends DataClass implements Insertable<TagAliase> {
  final int id;
  final int tagId;
  final String alias;
  final AliasConfidence confidence;
  const TagAliase({
    required this.id,
    required this.tagId,
    required this.alias,
    required this.confidence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tag_id'] = Variable<int>(tagId);
    map['alias'] = Variable<String>(alias);
    {
      map['confidence'] = Variable<String>(
        $TagAliasesTable.$converterconfidence.toSql(confidence),
      );
    }
    return map;
  }

  TagAliasesCompanion toCompanion(bool nullToAbsent) {
    return TagAliasesCompanion(
      id: Value(id),
      tagId: Value(tagId),
      alias: Value(alias),
      confidence: Value(confidence),
    );
  }

  factory TagAliase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagAliase(
      id: serializer.fromJson<int>(json['id']),
      tagId: serializer.fromJson<int>(json['tagId']),
      alias: serializer.fromJson<String>(json['alias']),
      confidence: $TagAliasesTable.$converterconfidence.fromJson(
        serializer.fromJson<String>(json['confidence']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tagId': serializer.toJson<int>(tagId),
      'alias': serializer.toJson<String>(alias),
      'confidence': serializer.toJson<String>(
        $TagAliasesTable.$converterconfidence.toJson(confidence),
      ),
    };
  }

  TagAliase copyWith({
    int? id,
    int? tagId,
    String? alias,
    AliasConfidence? confidence,
  }) => TagAliase(
    id: id ?? this.id,
    tagId: tagId ?? this.tagId,
    alias: alias ?? this.alias,
    confidence: confidence ?? this.confidence,
  );
  TagAliase copyWithCompanion(TagAliasesCompanion data) {
    return TagAliase(
      id: data.id.present ? data.id.value : this.id,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      alias: data.alias.present ? data.alias.value : this.alias,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagAliase(')
          ..write('id: $id, ')
          ..write('tagId: $tagId, ')
          ..write('alias: $alias, ')
          ..write('confidence: $confidence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tagId, alias, confidence);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagAliase &&
          other.id == this.id &&
          other.tagId == this.tagId &&
          other.alias == this.alias &&
          other.confidence == this.confidence);
}

class TagAliasesCompanion extends UpdateCompanion<TagAliase> {
  final Value<int> id;
  final Value<int> tagId;
  final Value<String> alias;
  final Value<AliasConfidence> confidence;
  const TagAliasesCompanion({
    this.id = const Value.absent(),
    this.tagId = const Value.absent(),
    this.alias = const Value.absent(),
    this.confidence = const Value.absent(),
  });
  TagAliasesCompanion.insert({
    this.id = const Value.absent(),
    required int tagId,
    required String alias,
    required AliasConfidence confidence,
  }) : tagId = Value(tagId),
       alias = Value(alias),
       confidence = Value(confidence);
  static Insertable<TagAliase> custom({
    Expression<int>? id,
    Expression<int>? tagId,
    Expression<String>? alias,
    Expression<String>? confidence,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tagId != null) 'tag_id': tagId,
      if (alias != null) 'alias': alias,
      if (confidence != null) 'confidence': confidence,
    });
  }

  TagAliasesCompanion copyWith({
    Value<int>? id,
    Value<int>? tagId,
    Value<String>? alias,
    Value<AliasConfidence>? confidence,
  }) {
    return TagAliasesCompanion(
      id: id ?? this.id,
      tagId: tagId ?? this.tagId,
      alias: alias ?? this.alias,
      confidence: confidence ?? this.confidence,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(
        $TagAliasesTable.$converterconfidence.toSql(confidence.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagAliasesCompanion(')
          ..write('id: $id, ')
          ..write('tagId: $tagId, ')
          ..write('alias: $alias, ')
          ..write('confidence: $confidence')
          ..write(')'))
        .toString();
  }
}

class $TagExclusionsTable extends TagExclusions
    with TableInfo<$TagExclusionsTable, TagExclusion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagExclusionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, tagId, word];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tag_exclusions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TagExclusion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {tagId, word},
  ];
  @override
  TagExclusion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagExclusion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
      word: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word'],
      )!,
    );
  }

  @override
  $TagExclusionsTable createAlias(String alias) {
    return $TagExclusionsTable(attachedDatabase, alias);
  }
}

class TagExclusion extends DataClass implements Insertable<TagExclusion> {
  final int id;
  final int tagId;
  final String word;
  const TagExclusion({
    required this.id,
    required this.tagId,
    required this.word,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tag_id'] = Variable<int>(tagId);
    map['word'] = Variable<String>(word);
    return map;
  }

  TagExclusionsCompanion toCompanion(bool nullToAbsent) {
    return TagExclusionsCompanion(
      id: Value(id),
      tagId: Value(tagId),
      word: Value(word),
    );
  }

  factory TagExclusion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagExclusion(
      id: serializer.fromJson<int>(json['id']),
      tagId: serializer.fromJson<int>(json['tagId']),
      word: serializer.fromJson<String>(json['word']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tagId': serializer.toJson<int>(tagId),
      'word': serializer.toJson<String>(word),
    };
  }

  TagExclusion copyWith({int? id, int? tagId, String? word}) => TagExclusion(
    id: id ?? this.id,
    tagId: tagId ?? this.tagId,
    word: word ?? this.word,
  );
  TagExclusion copyWithCompanion(TagExclusionsCompanion data) {
    return TagExclusion(
      id: data.id.present ? data.id.value : this.id,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      word: data.word.present ? data.word.value : this.word,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagExclusion(')
          ..write('id: $id, ')
          ..write('tagId: $tagId, ')
          ..write('word: $word')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tagId, word);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagExclusion &&
          other.id == this.id &&
          other.tagId == this.tagId &&
          other.word == this.word);
}

class TagExclusionsCompanion extends UpdateCompanion<TagExclusion> {
  final Value<int> id;
  final Value<int> tagId;
  final Value<String> word;
  const TagExclusionsCompanion({
    this.id = const Value.absent(),
    this.tagId = const Value.absent(),
    this.word = const Value.absent(),
  });
  TagExclusionsCompanion.insert({
    this.id = const Value.absent(),
    required int tagId,
    required String word,
  }) : tagId = Value(tagId),
       word = Value(word);
  static Insertable<TagExclusion> custom({
    Expression<int>? id,
    Expression<int>? tagId,
    Expression<String>? word,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tagId != null) 'tag_id': tagId,
      if (word != null) 'word': word,
    });
  }

  TagExclusionsCompanion copyWith({
    Value<int>? id,
    Value<int>? tagId,
    Value<String>? word,
  }) {
    return TagExclusionsCompanion(
      id: id ?? this.id,
      tagId: tagId ?? this.tagId,
      word: word ?? this.word,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagExclusionsCompanion(')
          ..write('id: $id, ')
          ..write('tagId: $tagId, ')
          ..write('word: $word')
          ..write(')'))
        .toString();
  }
}

class $MemoTagsTable extends MemoTags with TableInfo<$MemoTagsTable, MemoTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _memoIdMeta = const VerificationMeta('memoId');
  @override
  late final GeneratedColumn<int> memoId = GeneratedColumn<int>(
    'memo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES memos (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<MemoTagSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MemoTagSource>($MemoTagsTable.$convertersource);
  @override
  late final GeneratedColumnWithTypeConverter<MemoTagStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MemoTagStatus>($MemoTagsTable.$converterstatus);
  @override
  List<GeneratedColumn> get $columns => [memoId, tagId, source, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memo_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('memo_id')) {
      context.handle(
        _memoIdMeta,
        memoId.isAcceptableOrUnknown(data['memo_id']!, _memoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memoIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {memoId, tagId};
  @override
  MemoTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoTag(
      memoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}memo_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
      source: $MemoTagsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      status: $MemoTagsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $MemoTagsTable createAlias(String alias) {
    return $MemoTagsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MemoTagSource, String, String> $convertersource =
      const EnumNameConverter<MemoTagSource>(MemoTagSource.values);
  static JsonTypeConverter2<MemoTagStatus, String, String> $converterstatus =
      const EnumNameConverter<MemoTagStatus>(MemoTagStatus.values);
}

class MemoTag extends DataClass implements Insertable<MemoTag> {
  final int memoId;
  final int tagId;
  final MemoTagSource source;
  final MemoTagStatus status;
  const MemoTag({
    required this.memoId,
    required this.tagId,
    required this.source,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['memo_id'] = Variable<int>(memoId);
    map['tag_id'] = Variable<int>(tagId);
    {
      map['source'] = Variable<String>(
        $MemoTagsTable.$convertersource.toSql(source),
      );
    }
    {
      map['status'] = Variable<String>(
        $MemoTagsTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  MemoTagsCompanion toCompanion(bool nullToAbsent) {
    return MemoTagsCompanion(
      memoId: Value(memoId),
      tagId: Value(tagId),
      source: Value(source),
      status: Value(status),
    );
  }

  factory MemoTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoTag(
      memoId: serializer.fromJson<int>(json['memoId']),
      tagId: serializer.fromJson<int>(json['tagId']),
      source: $MemoTagsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      status: $MemoTagsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'memoId': serializer.toJson<int>(memoId),
      'tagId': serializer.toJson<int>(tagId),
      'source': serializer.toJson<String>(
        $MemoTagsTable.$convertersource.toJson(source),
      ),
      'status': serializer.toJson<String>(
        $MemoTagsTable.$converterstatus.toJson(status),
      ),
    };
  }

  MemoTag copyWith({
    int? memoId,
    int? tagId,
    MemoTagSource? source,
    MemoTagStatus? status,
  }) => MemoTag(
    memoId: memoId ?? this.memoId,
    tagId: tagId ?? this.tagId,
    source: source ?? this.source,
    status: status ?? this.status,
  );
  MemoTag copyWithCompanion(MemoTagsCompanion data) {
    return MemoTag(
      memoId: data.memoId.present ? data.memoId.value : this.memoId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      source: data.source.present ? data.source.value : this.source,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoTag(')
          ..write('memoId: $memoId, ')
          ..write('tagId: $tagId, ')
          ..write('source: $source, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(memoId, tagId, source, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoTag &&
          other.memoId == this.memoId &&
          other.tagId == this.tagId &&
          other.source == this.source &&
          other.status == this.status);
}

class MemoTagsCompanion extends UpdateCompanion<MemoTag> {
  final Value<int> memoId;
  final Value<int> tagId;
  final Value<MemoTagSource> source;
  final Value<MemoTagStatus> status;
  final Value<int> rowid;
  const MemoTagsCompanion({
    this.memoId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.source = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemoTagsCompanion.insert({
    required int memoId,
    required int tagId,
    required MemoTagSource source,
    required MemoTagStatus status,
    this.rowid = const Value.absent(),
  }) : memoId = Value(memoId),
       tagId = Value(tagId),
       source = Value(source),
       status = Value(status);
  static Insertable<MemoTag> custom({
    Expression<int>? memoId,
    Expression<int>? tagId,
    Expression<String>? source,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (memoId != null) 'memo_id': memoId,
      if (tagId != null) 'tag_id': tagId,
      if (source != null) 'source': source,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemoTagsCompanion copyWith({
    Value<int>? memoId,
    Value<int>? tagId,
    Value<MemoTagSource>? source,
    Value<MemoTagStatus>? status,
    Value<int>? rowid,
  }) {
    return MemoTagsCompanion(
      memoId: memoId ?? this.memoId,
      tagId: tagId ?? this.tagId,
      source: source ?? this.source,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (memoId.present) {
      map['memo_id'] = Variable<int>(memoId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $MemoTagsTable.$convertersource.toSql(source.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $MemoTagsTable.$converterstatus.toSql(status.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoTagsCompanion(')
          ..write('memoId: $memoId, ')
          ..write('tagId: $tagId, ')
          ..write('source: $source, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlacesTable places = $PlacesTable(this);
  late final $CuesTable cues = $CuesTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $GamesTable games = $GamesTable(this);
  late final $MemosTable memos = $MemosTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $TagAliasesTable tagAliases = $TagAliasesTable(this);
  late final $TagExclusionsTable tagExclusions = $TagExclusionsTable(this);
  late final $MemoTagsTable memoTags = $MemoTagsTable(this);
  late final Index placesLastUsedAt = Index(
    'places_last_used_at',
    'CREATE INDEX places_last_used_at ON places (last_used_at)',
  );
  late final Index cuesLastUsedAt = Index(
    'cues_last_used_at',
    'CREATE INDEX cues_last_used_at ON cues (last_used_at)',
  );
  late final Index sessionsDate = Index(
    'sessions_date',
    'CREATE INDEX sessions_date ON sessions (date)',
  );
  late final Index sessionsStatus = Index(
    'sessions_status',
    'CREATE INDEX sessions_status ON sessions (status)',
  );
  late final Index sessionsPlaceId = Index(
    'sessions_place_id',
    'CREATE INDEX sessions_place_id ON sessions (place_id)',
  );
  late final Index sessionsCueId = Index(
    'sessions_cue_id',
    'CREATE INDEX sessions_cue_id ON sessions (cue_id)',
  );
  late final Index gamesSessionId = Index(
    'games_session_id',
    'CREATE INDEX games_session_id ON games (session_id)',
  );
  late final Index memosSessionId = Index(
    'memos_session_id',
    'CREATE INDEX memos_session_id ON memos (session_id)',
  );
  late final Index tagsCategory = Index(
    'tags_category',
    'CREATE INDEX tags_category ON tags (category)',
  );
  late final Index tagsParentTagId = Index(
    'tags_parent_tag_id',
    'CREATE INDEX tags_parent_tag_id ON tags (parent_tag_id)',
  );
  late final Index tagAliasesTagId = Index(
    'tag_aliases_tag_id',
    'CREATE INDEX tag_aliases_tag_id ON tag_aliases (tag_id)',
  );
  late final Index tagExclusionsTagId = Index(
    'tag_exclusions_tag_id',
    'CREATE INDEX tag_exclusions_tag_id ON tag_exclusions (tag_id)',
  );
  late final Index memoTagsTagId = Index(
    'memo_tags_tag_id',
    'CREATE INDEX memo_tags_tag_id ON memo_tags (tag_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    places,
    cues,
    sessions,
    games,
    memos,
    tags,
    tagAliases,
    tagExclusions,
    memoTags,
    placesLastUsedAt,
    cuesLastUsedAt,
    sessionsDate,
    sessionsStatus,
    sessionsPlaceId,
    sessionsCueId,
    gamesSessionId,
    memosSessionId,
    tagsCategory,
    tagsParentTagId,
    tagAliasesTagId,
    tagExclusionsTagId,
    memoTagsTagId,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('games', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('memos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tag_aliases', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tag_exclusions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'memos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('memo_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('memo_tags', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PlacesTableCreateCompanionBuilder = PlacesCompanion Function({
  Value<int> id,
  required String name,
  required SurfaceType surface,
  required bool isIndoor,
  Value<DateTime> createdAt,
  Value<DateTime> lastUsedAt,
});
typedef $$PlacesTableUpdateCompanionBuilder = PlacesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<SurfaceType> surface,
  Value<bool> isIndoor,
  Value<DateTime> createdAt,
  Value<DateTime> lastUsedAt,
});

final class $$PlacesTableReferences
    extends BaseReferences<_$AppDatabase, $PlacesTable, Place> {
  $$PlacesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'places__id__sessions__place_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.placeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlacesTableFilterComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SurfaceType, SurfaceType, String>
  get surface => $composableBuilder(
    column: $table.surface,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isIndoor => $composableBuilder(
    column: $table.isIndoor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlacesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get surface => $composableBuilder(
    column: $table.surface,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isIndoor => $composableBuilder(
    column: $table.isIndoor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SurfaceType, String> get surface =>
      $composableBuilder(column: $table.surface, builder: (column) => column);

  GeneratedColumn<bool> get isIndoor =>
      $composableBuilder(column: $table.isIndoor, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlacesTable,
          Place,
          $$PlacesTableFilterComposer,
          $$PlacesTableOrderingComposer,
          $$PlacesTableAnnotationComposer,
          $$PlacesTableCreateCompanionBuilder,
          $$PlacesTableUpdateCompanionBuilder,
          (Place, $$PlacesTableReferences),
          Place,
          PrefetchHooks Function({bool sessionsRefs})
        > {
  $$PlacesTableTableManager(_$AppDatabase db, $PlacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<SurfaceType> surface = const Value.absent(),
                Value<bool> isIndoor = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastUsedAt = const Value.absent(),
              }) => PlacesCompanion(
                id: id,
                name: name,
                surface: surface,
                isIndoor: isIndoor,
                createdAt: createdAt,
                lastUsedAt: lastUsedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required SurfaceType surface,
                required bool isIndoor,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastUsedAt = const Value.absent(),
              }) => PlacesCompanion.insert(
                id: id,
                name: name,
                surface: surface,
                isIndoor: isIndoor,
                createdAt: createdAt,
                lastUsedAt: lastUsedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlacesTable, Place>(table),
                  $$PlacesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sessionsRefs) db.sessions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionsRefs)
                    await $_getPrefetchedData<Place, $PlacesTable, Session>(
                      currentTable: table,
                      referencedTable: $$PlacesTableReferences
                          ._sessionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PlacesTableReferences(db, table, p0).sessionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.placeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlacesTable,
      Place,
      $$PlacesTableFilterComposer,
      $$PlacesTableOrderingComposer,
      $$PlacesTableAnnotationComposer,
      $$PlacesTableCreateCompanionBuilder,
      $$PlacesTableUpdateCompanionBuilder,
      (Place, $$PlacesTableReferences),
      Place,
      PrefetchHooks Function({bool sessionsRefs})
    >;
typedef $$CuesTableCreateCompanionBuilder = CuesCompanion Function({
  Value<int> id,
  required String cueText,
  Value<DateTime> createdAt,
  Value<DateTime> lastUsedAt,
});
typedef $$CuesTableUpdateCompanionBuilder = CuesCompanion Function({
  Value<int> id,
  Value<String> cueText,
  Value<DateTime> createdAt,
  Value<DateTime> lastUsedAt,
});

final class $$CuesTableReferences
    extends BaseReferences<_$AppDatabase, $CuesTable, Cue> {
  $$CuesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'cues__id__sessions__cue_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.cueId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CuesTableFilterComposer extends Composer<_$AppDatabase, $CuesTable> {
  $$CuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cueText => $composableBuilder(
    column: $table.cueText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.cueId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CuesTableOrderingComposer extends Composer<_$AppDatabase, $CuesTable> {
  $$CuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cueText => $composableBuilder(
    column: $table.cueText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CuesTable> {
  $$CuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cueText =>
      $composableBuilder(column: $table.cueText, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.cueId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CuesTable,
          Cue,
          $$CuesTableFilterComposer,
          $$CuesTableOrderingComposer,
          $$CuesTableAnnotationComposer,
          $$CuesTableCreateCompanionBuilder,
          $$CuesTableUpdateCompanionBuilder,
          (Cue, $$CuesTableReferences),
          Cue,
          PrefetchHooks Function({bool sessionsRefs})
        > {
  $$CuesTableTableManager(_$AppDatabase db, $CuesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> cueText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastUsedAt = const Value.absent(),
              }) => CuesCompanion(
                id: id,
                cueText: cueText,
                createdAt: createdAt,
                lastUsedAt: lastUsedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String cueText,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastUsedAt = const Value.absent(),
              }) => CuesCompanion.insert(
                id: id,
                cueText: cueText,
                createdAt: createdAt,
                lastUsedAt: lastUsedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CuesTable, Cue>(table),
                  $$CuesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (sessionsRefs) db.sessions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sessionsRefs)
                    await $_getPrefetchedData<Cue, $CuesTable, Session>(
                      currentTable: table,
                      referencedTable: $$CuesTableReferences._sessionsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$CuesTableReferences(db, table, p0).sessionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.cueId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CuesTable,
      Cue,
      $$CuesTableFilterComposer,
      $$CuesTableOrderingComposer,
      $$CuesTableAnnotationComposer,
      $$CuesTableCreateCompanionBuilder,
      $$CuesTableUpdateCompanionBuilder,
      (Cue, $$CuesTableReferences),
      Cue,
      PrefetchHooks Function({bool sessionsRefs})
    >;
typedef $$SessionsTableCreateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<SessionType> sessionType,
  required DateTime date,
  Value<int?> startMinutes,
  Value<int?> endMinutes,
  Value<int?> placeId,
  Value<SurfaceType?> surfaceSnapshot,
  Value<bool?> isIndoorSnapshot,
  Value<String?> placeNameSnapshot,
  Value<int?> conditionScore,
  Value<LastMealBucket?> lastMealBucket,
  Value<int?> cueId,
  Value<CueApplied?> cueApplied,
  Value<SessionStatus> status,
  Value<bool> tagReviewed,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$SessionsTableUpdateCompanionBuilder = SessionsCompanion Function({
  Value<int> id,
  Value<SessionType> sessionType,
  Value<DateTime> date,
  Value<int?> startMinutes,
  Value<int?> endMinutes,
  Value<int?> placeId,
  Value<SurfaceType?> surfaceSnapshot,
  Value<bool?> isIndoorSnapshot,
  Value<String?> placeNameSnapshot,
  Value<int?> conditionScore,
  Value<LastMealBucket?> lastMealBucket,
  Value<int?> cueId,
  Value<CueApplied?> cueApplied,
  Value<SessionStatus> status,
  Value<bool> tagReviewed,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlacesTable _placeIdTable(_$AppDatabase db) =>
      db.places.createAlias('sessions__place_id__places__id');

  $$PlacesTableProcessedTableManager? get placeId {
    final $_column = $_itemColumn<int>('place_id');
    if ($_column == null) return null;
    final manager = $$PlacesTableTableManager(
      $_db,
      $_db.places,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_placeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CuesTable _cueIdTable(_$AppDatabase db) =>
      db.cues.createAlias('sessions__cue_id__cues__id');

  $$CuesTableProcessedTableManager? get cueId {
    final $_column = $_itemColumn<int>('cue_id');
    if ($_column == null) return null;
    final manager = $$CuesTableTableManager(
      $_db,
      $_db.cues,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cueIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$GamesTable, List<Game>> _gamesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.games,
    aliasName: 'sessions__id__games__session_id',
  );

  $$GamesTableProcessedTableManager get gamesRefs {
    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_gamesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MemosTable, List<Memo>> _memosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.memos,
    aliasName: 'sessions__id__memos__session_id',
  );

  $$MemosTableProcessedTableManager get memosRefs {
    final manager = $$MemosTableTableManager(
      $_db,
      $_db.memos,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_memosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SessionType, SessionType, String>
  get sessionType => $composableBuilder(
    column: $table.sessionType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SurfaceType?, SurfaceType, String>
  get surfaceSnapshot => $composableBuilder(
    column: $table.surfaceSnapshot,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isIndoorSnapshot => $composableBuilder(
    column: $table.isIndoorSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeNameSnapshot => $composableBuilder(
    column: $table.placeNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get conditionScore => $composableBuilder(
    column: $table.conditionScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LastMealBucket?, LastMealBucket, String>
  get lastMealBucket => $composableBuilder(
    column: $table.lastMealBucket,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<CueApplied?, CueApplied, String>
  get cueApplied => $composableBuilder(
    column: $table.cueApplied,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<SessionStatus, SessionStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get tagReviewed => $composableBuilder(
    column: $table.tagReviewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PlacesTableFilterComposer get placeId {
    final $$PlacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableFilterComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuesTableFilterComposer get cueId {
    final $$CuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cueId,
      referencedTable: $db.cues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuesTableFilterComposer(
            $db: $db,
            $table: $db.cues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> gamesRefs(
    Expression<bool> Function($$GamesTableFilterComposer f) f,
  ) {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> memosRefs(
    Expression<bool> Function($$MemosTableFilterComposer f) f,
  ) {
    final $$MemosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memos,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemosTableFilterComposer(
            $db: $db,
            $table: $db.memos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionType => $composableBuilder(
    column: $table.sessionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get surfaceSnapshot => $composableBuilder(
    column: $table.surfaceSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isIndoorSnapshot => $composableBuilder(
    column: $table.isIndoorSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeNameSnapshot => $composableBuilder(
    column: $table.placeNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get conditionScore => $composableBuilder(
    column: $table.conditionScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastMealBucket => $composableBuilder(
    column: $table.lastMealBucket,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cueApplied => $composableBuilder(
    column: $table.cueApplied,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get tagReviewed => $composableBuilder(
    column: $table.tagReviewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlacesTableOrderingComposer get placeId {
    final $$PlacesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableOrderingComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuesTableOrderingComposer get cueId {
    final $$CuesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cueId,
      referencedTable: $db.cues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuesTableOrderingComposer(
            $db: $db,
            $table: $db.cues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SessionType, String> get sessionType =>
      $composableBuilder(
        column: $table.sessionType,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SurfaceType?, String> get surfaceSnapshot =>
      $composableBuilder(
        column: $table.surfaceSnapshot,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isIndoorSnapshot => $composableBuilder(
    column: $table.isIndoorSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<String> get placeNameSnapshot => $composableBuilder(
    column: $table.placeNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get conditionScore => $composableBuilder(
    column: $table.conditionScore,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LastMealBucket?, String>
  get lastMealBucket => $composableBuilder(
    column: $table.lastMealBucket,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CueApplied?, String> get cueApplied =>
      $composableBuilder(
        column: $table.cueApplied,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<SessionStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get tagReviewed => $composableBuilder(
    column: $table.tagReviewed,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PlacesTableAnnotationComposer get placeId {
    final $$PlacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.places,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableAnnotationComposer(
            $db: $db,
            $table: $db.places,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CuesTableAnnotationComposer get cueId {
    final $$CuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cueId,
      referencedTable: $db.cues,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CuesTableAnnotationComposer(
            $db: $db,
            $table: $db.cues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> gamesRefs<T extends Object>(
    Expression<T> Function($$GamesTableAnnotationComposer a) f,
  ) {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> memosRefs<T extends Object>(
    Expression<T> Function($$MemosTableAnnotationComposer a) f,
  ) {
    final $$MemosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memos,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemosTableAnnotationComposer(
            $db: $db,
            $table: $db.memos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({
            bool placeId,
            bool cueId,
            bool gamesRefs,
            bool memosRefs,
          })
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<SessionType> sessionType = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> startMinutes = const Value.absent(),
                Value<int?> endMinutes = const Value.absent(),
                Value<int?> placeId = const Value.absent(),
                Value<SurfaceType?> surfaceSnapshot = const Value.absent(),
                Value<bool?> isIndoorSnapshot = const Value.absent(),
                Value<String?> placeNameSnapshot = const Value.absent(),
                Value<int?> conditionScore = const Value.absent(),
                Value<LastMealBucket?> lastMealBucket = const Value.absent(),
                Value<int?> cueId = const Value.absent(),
                Value<CueApplied?> cueApplied = const Value.absent(),
                Value<SessionStatus> status = const Value.absent(),
                Value<bool> tagReviewed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                sessionType: sessionType,
                date: date,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                placeId: placeId,
                surfaceSnapshot: surfaceSnapshot,
                isIndoorSnapshot: isIndoorSnapshot,
                placeNameSnapshot: placeNameSnapshot,
                conditionScore: conditionScore,
                lastMealBucket: lastMealBucket,
                cueId: cueId,
                cueApplied: cueApplied,
                status: status,
                tagReviewed: tagReviewed,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<SessionType> sessionType = const Value.absent(),
                required DateTime date,
                Value<int?> startMinutes = const Value.absent(),
                Value<int?> endMinutes = const Value.absent(),
                Value<int?> placeId = const Value.absent(),
                Value<SurfaceType?> surfaceSnapshot = const Value.absent(),
                Value<bool?> isIndoorSnapshot = const Value.absent(),
                Value<String?> placeNameSnapshot = const Value.absent(),
                Value<int?> conditionScore = const Value.absent(),
                Value<LastMealBucket?> lastMealBucket = const Value.absent(),
                Value<int?> cueId = const Value.absent(),
                Value<CueApplied?> cueApplied = const Value.absent(),
                Value<SessionStatus> status = const Value.absent(),
                Value<bool> tagReviewed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                sessionType: sessionType,
                date: date,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                placeId: placeId,
                surfaceSnapshot: surfaceSnapshot,
                isIndoorSnapshot: isIndoorSnapshot,
                placeNameSnapshot: placeNameSnapshot,
                conditionScore: conditionScore,
                lastMealBucket: lastMealBucket,
                cueId: cueId,
                cueApplied: cueApplied,
                status: status,
                tagReviewed: tagReviewed,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SessionsTable, Session>(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                placeId = false,
                cueId = false,
                gamesRefs = false,
                memosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gamesRefs) db.games,
                    if (memosRefs) db.memos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (placeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.placeId,
                            referencedTable: $$SessionsTableReferences
                                ._placeIdTable(db),
                            referencedColumn: $$SessionsTableReferences
                                ._placeIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (cueId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.cueId,
                            referencedTable: $$SessionsTableReferences
                                ._cueIdTable(db),
                            referencedColumn: $$SessionsTableReferences
                                ._cueIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (gamesRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          Game
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._gamesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).gamesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (memosRefs)
                        await $_getPrefetchedData<
                          Session,
                          $SessionsTable,
                          Memo
                        >(
                          currentTable: table,
                          referencedTable: $$SessionsTableReferences
                              ._memosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).memosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({
        bool placeId,
        bool cueId,
        bool gamesRefs,
        bool memosRefs,
      })
    >;
typedef $$GamesTableCreateCompanionBuilder = GamesCompanion Function({
  Value<int> id,
  required int sessionId,
  required GameFormat format,
  Value<int?> myScore,
  Value<int?> opponentScore,
  required int orderIndex,
});
typedef $$GamesTableUpdateCompanionBuilder = GamesCompanion Function({
  Value<int> id,
  Value<int> sessionId,
  Value<GameFormat> format,
  Value<int?> myScore,
  Value<int?> opponentScore,
  Value<int> orderIndex,
});

final class $$GamesTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTable, Game> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('games__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GamesTableFilterComposer extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GameFormat, GameFormat, String> get format =>
      $composableBuilder(
        column: $table.format,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get myScore => $composableBuilder(
    column: $table.myScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get opponentScore => $composableBuilder(
    column: $table.opponentScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get myScore => $composableBuilder(
    column: $table.myScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get opponentScore => $composableBuilder(
    column: $table.opponentScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GameFormat, String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<int> get myScore =>
      $composableBuilder(column: $table.myScore, builder: (column) => column);

  GeneratedColumn<int> get opponentScore => $composableBuilder(
    column: $table.opponentScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesTable,
          Game,
          $$GamesTableFilterComposer,
          $$GamesTableOrderingComposer,
          $$GamesTableAnnotationComposer,
          $$GamesTableCreateCompanionBuilder,
          $$GamesTableUpdateCompanionBuilder,
          (Game, $$GamesTableReferences),
          Game,
          PrefetchHooks Function({bool sessionId})
        > {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<GameFormat> format = const Value.absent(),
                Value<int?> myScore = const Value.absent(),
                Value<int?> opponentScore = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
              }) => GamesCompanion(
                id: id,
                sessionId: sessionId,
                format: format,
                myScore: myScore,
                opponentScore: opponentScore,
                orderIndex: orderIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required GameFormat format,
                Value<int?> myScore = const Value.absent(),
                Value<int?> opponentScore = const Value.absent(),
                required int orderIndex,
              }) => GamesCompanion.insert(
                id: id,
                sessionId: sessionId,
                format: format,
                myScore: myScore,
                opponentScore: opponentScore,
                orderIndex: orderIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GamesTable, Game>(table),
                  $$GamesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$GamesTableReferences._sessionIdTable(
                          db,
                        ),
                        referencedColumn: $$GamesTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesTable,
      Game,
      $$GamesTableFilterComposer,
      $$GamesTableOrderingComposer,
      $$GamesTableAnnotationComposer,
      $$GamesTableCreateCompanionBuilder,
      $$GamesTableUpdateCompanionBuilder,
      (Game, $$GamesTableReferences),
      Game,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$MemosTableCreateCompanionBuilder = MemosCompanion Function({
  Value<int> id,
  required int sessionId,
  required String content,
  required int orderIndex,
  Value<MemoEvaluation?> evaluation,
  Value<EvaluationStatus?> evaluationStatus,
  Value<String?> lastTaggedContent,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$MemosTableUpdateCompanionBuilder = MemosCompanion Function({
  Value<int> id,
  Value<int> sessionId,
  Value<String> content,
  Value<int> orderIndex,
  Value<MemoEvaluation?> evaluation,
  Value<EvaluationStatus?> evaluationStatus,
  Value<String?> lastTaggedContent,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$MemosTableReferences
    extends BaseReferences<_$AppDatabase, $MemosTable, Memo> {
  $$MemosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.sessions.createAlias('memos__session_id__sessions__id');

  $$SessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MemoTagsTable, List<MemoTag>> _memoTagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.memoTags,
    aliasName: 'memos__id__memo_tags__memo_id',
  );

  $$MemoTagsTableProcessedTableManager get memoTagsRefs {
    final manager = $$MemoTagsTableTableManager(
      $_db,
      $_db.memoTags,
    ).filter((f) => f.memoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_memoTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MemosTableFilterComposer extends Composer<_$AppDatabase, $MemosTable> {
  $$MemosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MemoEvaluation?, MemoEvaluation, String>
  get evaluation => $composableBuilder(
    column: $table.evaluation,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<EvaluationStatus?, EvaluationStatus, String>
  get evaluationStatus => $composableBuilder(
    column: $table.evaluationStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get lastTaggedContent => $composableBuilder(
    column: $table.lastTaggedContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SessionsTableFilterComposer get sessionId {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> memoTagsRefs(
    Expression<bool> Function($$MemoTagsTableFilterComposer f) f,
  ) {
    final $$MemoTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoTags,
      getReferencedColumn: (t) => t.memoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoTagsTableFilterComposer(
            $db: $db,
            $table: $db.memoTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MemosTableOrderingComposer
    extends Composer<_$AppDatabase, $MemosTable> {
  $$MemosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evaluation => $composableBuilder(
    column: $table.evaluation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evaluationStatus => $composableBuilder(
    column: $table.evaluationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastTaggedContent => $composableBuilder(
    column: $table.lastTaggedContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SessionsTableOrderingComposer get sessionId {
    final $$SessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableOrderingComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemosTable> {
  $$MemosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<MemoEvaluation?, String> get evaluation =>
      $composableBuilder(
        column: $table.evaluation,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<EvaluationStatus?, String>
  get evaluationStatus => $composableBuilder(
    column: $table.evaluationStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastTaggedContent => $composableBuilder(
    column: $table.lastTaggedContent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SessionsTableAnnotationComposer get sessionId {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> memoTagsRefs<T extends Object>(
    Expression<T> Function($$MemoTagsTableAnnotationComposer a) f,
  ) {
    final $$MemoTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoTags,
      getReferencedColumn: (t) => t.memoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.memoTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MemosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemosTable,
          Memo,
          $$MemosTableFilterComposer,
          $$MemosTableOrderingComposer,
          $$MemosTableAnnotationComposer,
          $$MemosTableCreateCompanionBuilder,
          $$MemosTableUpdateCompanionBuilder,
          (Memo, $$MemosTableReferences),
          Memo,
          PrefetchHooks Function({bool sessionId, bool memoTagsRefs})
        > {
  $$MemosTableTableManager(_$AppDatabase db, $MemosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<MemoEvaluation?> evaluation = const Value.absent(),
                Value<EvaluationStatus?> evaluationStatus =
                    const Value.absent(),
                Value<String?> lastTaggedContent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MemosCompanion(
                id: id,
                sessionId: sessionId,
                content: content,
                orderIndex: orderIndex,
                evaluation: evaluation,
                evaluationStatus: evaluationStatus,
                lastTaggedContent: lastTaggedContent,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required String content,
                required int orderIndex,
                Value<MemoEvaluation?> evaluation = const Value.absent(),
                Value<EvaluationStatus?> evaluationStatus =
                    const Value.absent(),
                Value<String?> lastTaggedContent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MemosCompanion.insert(
                id: id,
                sessionId: sessionId,
                content: content,
                orderIndex: orderIndex,
                evaluation: evaluation,
                evaluationStatus: evaluationStatus,
                lastTaggedContent: lastTaggedContent,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MemosTable, Memo>(table),
                  $$MemosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false, memoTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (memoTagsRefs) db.memoTags],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$MemosTableReferences._sessionIdTable(
                          db,
                        ),
                        referencedColumn: $$MemosTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (memoTagsRefs)
                    await $_getPrefetchedData<Memo, $MemosTable, MemoTag>(
                      currentTable: table,
                      referencedTable: $$MemosTableReferences
                          ._memoTagsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MemosTableReferences(db, table, p0).memoTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.memoId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MemosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemosTable,
      Memo,
      $$MemosTableFilterComposer,
      $$MemosTableOrderingComposer,
      $$MemosTableAnnotationComposer,
      $$MemosTableCreateCompanionBuilder,
      $$MemosTableUpdateCompanionBuilder,
      (Memo, $$MemosTableReferences),
      Memo,
      PrefetchHooks Function({bool sessionId, bool memoTagsRefs})
    >;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  required String name,
  required TagCategory category,
  Value<int?> parentTagId,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<TagCategory> category,
  Value<int?> parentTagId,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TagsTable _parentTagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('tags__parent_tag_id__tags__id');

  $$TagsTableProcessedTableManager? get parentTagId {
    final $_column = $_itemColumn<int>('parent_tag_id');
    if ($_column == null) return null;
    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentTagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TagAliasesTable, List<TagAliase>>
  _tagAliasesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tagAliases,
    aliasName: 'tags__id__tag_aliases__tag_id',
  );

  $$TagAliasesTableProcessedTableManager get tagAliasesRefs {
    final manager = $$TagAliasesTableTableManager(
      $_db,
      $_db.tagAliases,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tagAliasesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TagExclusionsTable, List<TagExclusion>>
  _tagExclusionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tagExclusions,
    aliasName: 'tags__id__tag_exclusions__tag_id',
  );

  $$TagExclusionsTableProcessedTableManager get tagExclusionsRefs {
    final manager = $$TagExclusionsTableTableManager(
      $_db,
      $_db.tagExclusions,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tagExclusionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MemoTagsTable, List<MemoTag>> _memoTagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.memoTags,
    aliasName: 'tags__id__memo_tags__tag_id',
  );

  $$MemoTagsTableProcessedTableManager get memoTagsRefs {
    final manager = $$MemoTagsTableTableManager(
      $_db,
      $_db.memoTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_memoTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TagCategory, TagCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TagsTableFilterComposer get parentTagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentTagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> tagAliasesRefs(
    Expression<bool> Function($$TagAliasesTableFilterComposer f) f,
  ) {
    final $$TagAliasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tagAliases,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagAliasesTableFilterComposer(
            $db: $db,
            $table: $db.tagAliases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tagExclusionsRefs(
    Expression<bool> Function($$TagExclusionsTableFilterComposer f) f,
  ) {
    final $$TagExclusionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tagExclusions,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagExclusionsTableFilterComposer(
            $db: $db,
            $table: $db.tagExclusions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> memoTagsRefs(
    Expression<bool> Function($$MemoTagsTableFilterComposer f) f,
  ) {
    final $$MemoTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoTagsTableFilterComposer(
            $db: $db,
            $table: $db.memoTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TagsTableOrderingComposer get parentTagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentTagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TagCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TagsTableAnnotationComposer get parentTagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentTagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> tagAliasesRefs<T extends Object>(
    Expression<T> Function($$TagAliasesTableAnnotationComposer a) f,
  ) {
    final $$TagAliasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tagAliases,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagAliasesTableAnnotationComposer(
            $db: $db,
            $table: $db.tagAliases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tagExclusionsRefs<T extends Object>(
    Expression<T> Function($$TagExclusionsTableAnnotationComposer a) f,
  ) {
    final $$TagExclusionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tagExclusions,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagExclusionsTableAnnotationComposer(
            $db: $db,
            $table: $db.tagExclusions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> memoTagsRefs<T extends Object>(
    Expression<T> Function($$MemoTagsTableAnnotationComposer a) f,
  ) {
    final $$MemoTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.memoTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({
            bool parentTagId,
            bool tagAliasesRefs,
            bool tagExclusionsRefs,
            bool memoTagsRefs,
          })
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<TagCategory> category = const Value.absent(),
                Value<int?> parentTagId = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                name: name,
                category: category,
                parentTagId: parentTagId,
                isArchived: isArchived,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required TagCategory category,
                Value<int?> parentTagId = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                name: name,
                category: category,
                parentTagId: parentTagId,
                isArchived: isArchived,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TagsTable, Tag>(table),
                  $$TagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                parentTagId = false,
                tagAliasesRefs = false,
                tagExclusionsRefs = false,
                memoTagsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tagAliasesRefs) db.tagAliases,
                    if (tagExclusionsRefs) db.tagExclusions,
                    if (memoTagsRefs) db.memoTags,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (parentTagId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.parentTagId,
                            referencedTable: $$TagsTableReferences
                                ._parentTagIdTable(db),
                            referencedColumn: $$TagsTableReferences
                                ._parentTagIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (tagAliasesRefs)
                        await $_getPrefetchedData<Tag, $TagsTable, TagAliase>(
                          currentTable: table,
                          referencedTable: $$TagsTableReferences
                              ._tagAliasesRefsTable(db),
                          managerFromTypedResult: (p0) => $$TagsTableReferences(
                            db,
                            table,
                            p0,
                          ).tagAliasesRefs,
                          referencedItemsForCurrentItem: (
                            item,
                            referencedItems,
                          ) => referencedItems.where((e) => e.tagId == item.id),
                          typedResults: items,
                        ),
                      if (tagExclusionsRefs)
                        await $_getPrefetchedData<
                          Tag,
                          $TagsTable,
                          TagExclusion
                        >(
                          currentTable: table,
                          referencedTable: $$TagsTableReferences
                              ._tagExclusionsRefsTable(db),
                          managerFromTypedResult: (p0) => $$TagsTableReferences(
                            db,
                            table,
                            p0,
                          ).tagExclusionsRefs,
                          referencedItemsForCurrentItem: (
                            item,
                            referencedItems,
                          ) => referencedItems.where((e) => e.tagId == item.id),
                          typedResults: items,
                        ),
                      if (memoTagsRefs)
                        await $_getPrefetchedData<Tag, $TagsTable, MemoTag>(
                          currentTable: table,
                          referencedTable: $$TagsTableReferences
                              ._memoTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TagsTableReferences(db, table, p0).memoTagsRefs,
                          referencedItemsForCurrentItem: (
                            item,
                            referencedItems,
                          ) => referencedItems.where((e) => e.tagId == item.id),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({
        bool parentTagId,
        bool tagAliasesRefs,
        bool tagExclusionsRefs,
        bool memoTagsRefs,
      })
    >;
typedef $$TagAliasesTableCreateCompanionBuilder = TagAliasesCompanion Function({
  Value<int> id,
  required int tagId,
  required String alias,
  required AliasConfidence confidence,
});
typedef $$TagAliasesTableUpdateCompanionBuilder = TagAliasesCompanion Function({
  Value<int> id,
  Value<int> tagId,
  Value<String> alias,
  Value<AliasConfidence> confidence,
});

final class $$TagAliasesTableReferences
    extends BaseReferences<_$AppDatabase, $TagAliasesTable, TagAliase> {
  $$TagAliasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('tag_aliases__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TagAliasesTableFilterComposer
    extends Composer<_$AppDatabase, $TagAliasesTable> {
  $$TagAliasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AliasConfidence, AliasConfidence, String>
  get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TagAliasesTableOrderingComposer
    extends Composer<_$AppDatabase, $TagAliasesTable> {
  $$TagAliasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TagAliasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagAliasesTable> {
  $$TagAliasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AliasConfidence, String> get confidence =>
      $composableBuilder(
        column: $table.confidence,
        builder: (column) => column,
      );

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TagAliasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagAliasesTable,
          TagAliase,
          $$TagAliasesTableFilterComposer,
          $$TagAliasesTableOrderingComposer,
          $$TagAliasesTableAnnotationComposer,
          $$TagAliasesTableCreateCompanionBuilder,
          $$TagAliasesTableUpdateCompanionBuilder,
          (TagAliase, $$TagAliasesTableReferences),
          TagAliase,
          PrefetchHooks Function({bool tagId})
        > {
  $$TagAliasesTableTableManager(_$AppDatabase db, $TagAliasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagAliasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagAliasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagAliasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<String> alias = const Value.absent(),
                Value<AliasConfidence> confidence = const Value.absent(),
              }) => TagAliasesCompanion(
                id: id,
                tagId: tagId,
                alias: alias,
                confidence: confidence,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tagId,
                required String alias,
                required AliasConfidence confidence,
              }) => TagAliasesCompanion.insert(
                id: id,
                tagId: tagId,
                alias: alias,
                confidence: confidence,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TagAliasesTable, TagAliase>(table),
                  $$TagAliasesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tagId,
                        referencedTable: $$TagAliasesTableReferences
                            ._tagIdTable(db),
                        referencedColumn: $$TagAliasesTableReferences
                            ._tagIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TagAliasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagAliasesTable,
      TagAliase,
      $$TagAliasesTableFilterComposer,
      $$TagAliasesTableOrderingComposer,
      $$TagAliasesTableAnnotationComposer,
      $$TagAliasesTableCreateCompanionBuilder,
      $$TagAliasesTableUpdateCompanionBuilder,
      (TagAliase, $$TagAliasesTableReferences),
      TagAliase,
      PrefetchHooks Function({bool tagId})
    >;
typedef $$TagExclusionsTableCreateCompanionBuilder =
    TagExclusionsCompanion Function({
      Value<int> id,
      required int tagId,
      required String word,
    });
typedef $$TagExclusionsTableUpdateCompanionBuilder =
    TagExclusionsCompanion Function({
      Value<int> id,
      Value<int> tagId,
      Value<String> word,
    });

final class $$TagExclusionsTableReferences
    extends BaseReferences<_$AppDatabase, $TagExclusionsTable, TagExclusion> {
  $$TagExclusionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('tag_exclusions__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TagExclusionsTableFilterComposer
    extends Composer<_$AppDatabase, $TagExclusionsTable> {
  $$TagExclusionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TagExclusionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TagExclusionsTable> {
  $$TagExclusionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TagExclusionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagExclusionsTable> {
  $$TagExclusionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TagExclusionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagExclusionsTable,
          TagExclusion,
          $$TagExclusionsTableFilterComposer,
          $$TagExclusionsTableOrderingComposer,
          $$TagExclusionsTableAnnotationComposer,
          $$TagExclusionsTableCreateCompanionBuilder,
          $$TagExclusionsTableUpdateCompanionBuilder,
          (TagExclusion, $$TagExclusionsTableReferences),
          TagExclusion,
          PrefetchHooks Function({bool tagId})
        > {
  $$TagExclusionsTableTableManager(_$AppDatabase db, $TagExclusionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagExclusionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagExclusionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagExclusionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> tagId = const Value.absent(),
            Value<String> word = const Value.absent(),
          }) => TagExclusionsCompanion(id: id, tagId: tagId, word: word),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int tagId,
            required String word,
          }) => TagExclusionsCompanion.insert(id: id, tagId: tagId, word: word),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TagExclusionsTable, TagExclusion>(table),
                  $$TagExclusionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tagId,
                        referencedTable: $$TagExclusionsTableReferences
                            ._tagIdTable(db),
                        referencedColumn: $$TagExclusionsTableReferences
                            ._tagIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TagExclusionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagExclusionsTable,
      TagExclusion,
      $$TagExclusionsTableFilterComposer,
      $$TagExclusionsTableOrderingComposer,
      $$TagExclusionsTableAnnotationComposer,
      $$TagExclusionsTableCreateCompanionBuilder,
      $$TagExclusionsTableUpdateCompanionBuilder,
      (TagExclusion, $$TagExclusionsTableReferences),
      TagExclusion,
      PrefetchHooks Function({bool tagId})
    >;
typedef $$MemoTagsTableCreateCompanionBuilder = MemoTagsCompanion Function({
  required int memoId,
  required int tagId,
  required MemoTagSource source,
  required MemoTagStatus status,
  Value<int> rowid,
});
typedef $$MemoTagsTableUpdateCompanionBuilder = MemoTagsCompanion Function({
  Value<int> memoId,
  Value<int> tagId,
  Value<MemoTagSource> source,
  Value<MemoTagStatus> status,
  Value<int> rowid,
});

final class $$MemoTagsTableReferences
    extends BaseReferences<_$AppDatabase, $MemoTagsTable, MemoTag> {
  $$MemoTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MemosTable _memoIdTable(_$AppDatabase db) =>
      db.memos.createAlias('memo_tags__memo_id__memos__id');

  $$MemosTableProcessedTableManager get memoId {
    final $_column = $_itemColumn<int>('memo_id')!;

    final manager = $$MemosTableTableManager(
      $_db,
      $_db.memos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('memo_tags__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MemoTagsTableFilterComposer
    extends Composer<_$AppDatabase, $MemoTagsTable> {
  $$MemoTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<MemoTagSource, MemoTagSource, String>
  get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<MemoTagStatus, MemoTagStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$MemosTableFilterComposer get memoId {
    final $$MemosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memoId,
      referencedTable: $db.memos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemosTableFilterComposer(
            $db: $db,
            $table: $db.memos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoTagsTable> {
  $$MemoTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$MemosTableOrderingComposer get memoId {
    final $$MemosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memoId,
      referencedTable: $db.memos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemosTableOrderingComposer(
            $db: $db,
            $table: $db.memos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoTagsTable> {
  $$MemoTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<MemoTagSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MemoTagStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$MemosTableAnnotationComposer get memoId {
    final $$MemosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memoId,
      referencedTable: $db.memos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemosTableAnnotationComposer(
            $db: $db,
            $table: $db.memos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoTagsTable,
          MemoTag,
          $$MemoTagsTableFilterComposer,
          $$MemoTagsTableOrderingComposer,
          $$MemoTagsTableAnnotationComposer,
          $$MemoTagsTableCreateCompanionBuilder,
          $$MemoTagsTableUpdateCompanionBuilder,
          (MemoTag, $$MemoTagsTableReferences),
          MemoTag,
          PrefetchHooks Function({bool memoId, bool tagId})
        > {
  $$MemoTagsTableTableManager(_$AppDatabase db, $MemoTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> memoId = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<MemoTagSource> source = const Value.absent(),
                Value<MemoTagStatus> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemoTagsCompanion(
                memoId: memoId,
                tagId: tagId,
                source: source,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int memoId,
                required int tagId,
                required MemoTagSource source,
                required MemoTagStatus status,
                Value<int> rowid = const Value.absent(),
              }) => MemoTagsCompanion.insert(
                memoId: memoId,
                tagId: tagId,
                source: source,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MemoTagsTable, MemoTag>(table),
                  $$MemoTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({memoId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (memoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.memoId,
                        referencedTable: $$MemoTagsTableReferences._memoIdTable(
                          db,
                        ),
                        referencedColumn: $$MemoTagsTableReferences
                            ._memoIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (tagId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tagId,
                        referencedTable: $$MemoTagsTableReferences._tagIdTable(
                          db,
                        ),
                        referencedColumn: $$MemoTagsTableReferences
                            ._tagIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MemoTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoTagsTable,
      MemoTag,
      $$MemoTagsTableFilterComposer,
      $$MemoTagsTableOrderingComposer,
      $$MemoTagsTableAnnotationComposer,
      $$MemoTagsTableCreateCompanionBuilder,
      $$MemoTagsTableUpdateCompanionBuilder,
      (MemoTag, $$MemoTagsTableReferences),
      MemoTag,
      PrefetchHooks Function({bool memoId, bool tagId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlacesTableTableManager get places =>
      $$PlacesTableTableManager(_db, _db.places);
  $$CuesTableTableManager get cues => $$CuesTableTableManager(_db, _db.cues);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$MemosTableTableManager get memos =>
      $$MemosTableTableManager(_db, _db.memos);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$TagAliasesTableTableManager get tagAliases =>
      $$TagAliasesTableTableManager(_db, _db.tagAliases);
  $$TagExclusionsTableTableManager get tagExclusions =>
      $$TagExclusionsTableTableManager(_db, _db.tagExclusions);
  $$MemoTagsTableTableManager get memoTags =>
      $$MemoTagsTableTableManager(_db, _db.memoTags);
}
