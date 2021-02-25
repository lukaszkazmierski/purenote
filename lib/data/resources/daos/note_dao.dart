import 'package:dartz/dartz.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:notebook/core/exceptions/exception_code.dart';
import 'package:notebook/core/exceptions/failure.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/data/resources/sql_tables/note_table.dart';
import 'package:notebook/data/resources/daos/db_actions.dart';


part 'note_dao.g.dart';

@UseDao(tables: [NoteTable])
class NoteDao extends DatabaseAccessor<MoorDatabase>
    with _$NoteDaoMixin implements DbActions<Note>  {

  final MoorDatabase db;

  NoteDao(this.db) : super(db);

  @override
  Future<List<Note>> getAllItem() => select(noteTable).get();
  @override
  Stream<List<Note>> watchAllItem([String bookName]) =>
      (select(noteTable)
          ..orderBy([
            (tbl) => OrderingTerm(expression: tbl.creationDate, mode: OrderingMode.desc)
          ])
          ..where((tbl) => tbl.book.equals(bookName))
      ).watch();
  @override
  Future<Either<Failure, int>> insertItem(Insertable<Note> note) async {
    try {
      final insertStatus = await into(noteTable).insert(note);
      return Right(insertStatus);
    } on InvalidDataException {
      return Left(Failure(ExceptionCodeType.invalidDataException));
    }
  }
  @override
  Future<Either<Failure, bool>> updateItem(Insertable<Note> note) async {
    try {
      final updateStatus = await update(noteTable).replace(note);
      return Right(updateStatus);
    } on InvalidDataException {
      return Left(Failure(ExceptionCodeType.invalidDataException));
    }
  }

  @override
  Future deleteItem(Insertable<Note> note) => delete(noteTable).delete(note);

  @override
  Future<Either<Failure, bool>> isExists({String itemName}) => throw UnimplementedError();
}