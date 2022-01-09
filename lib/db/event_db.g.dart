// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Event extends DataClass implements Insertable<Event> {
  final int id;
  final String streamId;
  final String streamType;
  final String tag;
  final int version;
  final DateTime date;
  final Map<String, dynamic> data;
  Event(
      {required this.id,
      required this.streamId,
      required this.streamType,
      required this.tag,
      required this.version,
      required this.date,
      required this.data});
  factory Event.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Event(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      streamId: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}stream_id'])!,
      streamType: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}stream_type'])!,
      tag: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}tag'])!,
      version: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}version'])!,
      date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      data: $EventsTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}data']))!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['stream_id'] = Variable<String>(streamId);
    map['stream_type'] = Variable<String>(streamType);
    map['tag'] = Variable<String>(tag);
    map['version'] = Variable<int>(version);
    map['date'] = Variable<DateTime>(date);
    {
      final converter = $EventsTable.$converter0;
      map['data'] = Variable<String>(converter.mapToSql(data)!);
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      streamId: Value(streamId),
      streamType: Value(streamType),
      tag: Value(tag),
      version: Value(version),
      date: Value(date),
      data: Value(data),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<int>(json['id']),
      streamId: serializer.fromJson<String>(json['streamId']),
      streamType: serializer.fromJson<String>(json['streamType']),
      tag: serializer.fromJson<String>(json['tag']),
      version: serializer.fromJson<int>(json['version']),
      date: serializer.fromJson<DateTime>(json['date']),
      data: serializer.fromJson<Map<String, dynamic>>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'streamId': serializer.toJson<String>(streamId),
      'streamType': serializer.toJson<String>(streamType),
      'tag': serializer.toJson<String>(tag),
      'version': serializer.toJson<int>(version),
      'date': serializer.toJson<DateTime>(date),
      'data': serializer.toJson<Map<String, dynamic>>(data),
    };
  }

  Event copyWith(
          {int? id,
          String? streamId,
          String? streamType,
          String? tag,
          int? version,
          DateTime? date,
          Map<String, dynamic>? data}) =>
      Event(
        id: id ?? this.id,
        streamId: streamId ?? this.streamId,
        streamType: streamType ?? this.streamType,
        tag: tag ?? this.tag,
        version: version ?? this.version,
        date: date ?? this.date,
        data: data ?? this.data,
      );
  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('streamId: $streamId, ')
          ..write('streamType: $streamType, ')
          ..write('tag: $tag, ')
          ..write('version: $version, ')
          ..write('date: $date, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, streamId, streamType, tag, version, date, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.streamId == this.streamId &&
          other.streamType == this.streamType &&
          other.tag == this.tag &&
          other.version == this.version &&
          other.date == this.date &&
          other.data == this.data);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<int> id;
  final Value<String> streamId;
  final Value<String> streamType;
  final Value<String> tag;
  final Value<int> version;
  final Value<DateTime> date;
  final Value<Map<String, dynamic>> data;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.streamId = const Value.absent(),
    this.streamType = const Value.absent(),
    this.tag = const Value.absent(),
    this.version = const Value.absent(),
    this.date = const Value.absent(),
    this.data = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required String streamId,
    required String streamType,
    required String tag,
    required int version,
    this.date = const Value.absent(),
    required Map<String, dynamic> data,
  })  : streamId = Value(streamId),
        streamType = Value(streamType),
        tag = Value(tag),
        version = Value(version),
        data = Value(data);
  static Insertable<Event> custom({
    Expression<int>? id,
    Expression<String>? streamId,
    Expression<String>? streamType,
    Expression<String>? tag,
    Expression<int>? version,
    Expression<DateTime>? date,
    Expression<Map<String, dynamic>>? data,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (streamId != null) 'stream_id': streamId,
      if (streamType != null) 'stream_type': streamType,
      if (tag != null) 'tag': tag,
      if (version != null) 'version': version,
      if (date != null) 'date': date,
      if (data != null) 'data': data,
    });
  }

  EventsCompanion copyWith(
      {Value<int>? id,
      Value<String>? streamId,
      Value<String>? streamType,
      Value<String>? tag,
      Value<int>? version,
      Value<DateTime>? date,
      Value<Map<String, dynamic>>? data}) {
    return EventsCompanion(
      id: id ?? this.id,
      streamId: streamId ?? this.streamId,
      streamType: streamType ?? this.streamType,
      tag: tag ?? this.tag,
      version: version ?? this.version,
      date: date ?? this.date,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (streamId.present) {
      map['stream_id'] = Variable<String>(streamId.value);
    }
    if (streamType.present) {
      map['stream_type'] = Variable<String>(streamType.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (data.present) {
      final converter = $EventsTable.$converter0;
      map['data'] = Variable<String>(converter.mapToSql(data.value)!);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('streamId: $streamId, ')
          ..write('streamType: $streamType, ')
          ..write('tag: $tag, ')
          ..write('version: $version, ')
          ..write('date: $date, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  final GeneratedDatabase _db;
  final String? _alias;
  $EventsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _streamIdMeta = const VerificationMeta('streamId');
  @override
  late final GeneratedColumn<String?> streamId = GeneratedColumn<String?>(
      'stream_id', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _streamTypeMeta = const VerificationMeta('streamType');
  @override
  late final GeneratedColumn<String?> streamType = GeneratedColumn<String?>(
      'stream_type', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String?> tag = GeneratedColumn<String?>(
      'tag', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _versionMeta = const VerificationMeta('version');
  @override
  late final GeneratedColumn<int?> version = GeneratedColumn<int?>(
      'version', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime?> date = GeneratedColumn<DateTime?>(
      'date', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDate);
  final VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String?>
      data = GeneratedColumn<String?>('data', aliasedName, false,
              type: const StringType(), requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>($EventsTable.$converter0);
  @override
  List<GeneratedColumn> get $columns =>
      [id, streamId, streamType, tag, version, date, data];
  @override
  String get aliasedName => _alias ?? 'events';
  @override
  String get actualTableName => 'events';
  @override
  VerificationContext validateIntegrity(Insertable<Event> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('stream_id')) {
      context.handle(_streamIdMeta,
          streamId.isAcceptableOrUnknown(data['stream_id']!, _streamIdMeta));
    } else if (isInserting) {
      context.missing(_streamIdMeta);
    }
    if (data.containsKey('stream_type')) {
      context.handle(
          _streamTypeMeta,
          streamType.isAcceptableOrUnknown(
              data['stream_type']!, _streamTypeMeta));
    } else if (isInserting) {
      context.missing(_streamTypeMeta);
    }
    if (data.containsKey('tag')) {
      context.handle(
          _tagMeta, tag.isAcceptableOrUnknown(data['tag']!, _tagMeta));
    } else if (isInserting) {
      context.missing(_tagMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    context.handle(_dataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Event.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(_db, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converter0 =
      const JsonConverter();
}

abstract class _$EventDB extends GeneratedDatabase {
  _$EventDB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $EventsTable events = $EventsTable(this);
  late final EventDao eventDao = EventDao(this as EventDB);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [events];
}
