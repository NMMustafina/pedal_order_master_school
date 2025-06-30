// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InstructorModelAdapter extends TypeAdapter<InstructorModel> {
  @override
  final int typeId = 1;

  @override
  InstructorModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InstructorModel(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      weekly: (fields[3] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as Map).cast<String, String>())),
    );
  }

  @override
  void write(BinaryWriter writer, InstructorModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.weekly);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstructorModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
