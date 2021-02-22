import 'package:dartz/dartz.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:notebook/core/exceptions/exception_code.dart';
import 'package:notebook/core/exceptions/failure.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/data/resources/sql_tables/book_table.dart';
import 'package:notebook/data/resources/daos/db_actions.dart';
import 'package:notebook/service_locator/service_locator.dart';

part 'book_dao.g.dart';

@UseDao(tables: [BookTable])
class BookDao extends DatabaseAccessor<MoorDatabase>
    with _$BookDaoMixin
    implements DbActions<Book> {
  final MoorDatabase db;

  BookDao(this.db) : super(db);

  @override
  Future<List<Book>> getAllItem() => select(bookTable).get();
  @override
  Stream<List<Book>> watchAllItem([_]) => select(bookTable).watch();

  @override
  Future<Either<Failure, int>> insertItem(Insertable<Book> book) async {
    try {
      final insertStatus = await into(bookTable).insert(book);
      return Right(insertStatus);
    } on InvalidDataException {
      final failure =
          locator.getWithParam<Failure>(ExceptionCodeType.invalidDataException);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, bool>> updateItem(Insertable<Book> book) async {
    try {
      final updateStatus = await update(bookTable).replace(book);
      return Right(updateStatus);
    } on InvalidDataException {
      final failure =
          locator.getWithParam<Failure>(ExceptionCodeType.invalidDataException);
      return Left(failure);
    }
  }

  @override
  Future deleteItem(Insertable<Book> book) => delete(bookTable).delete(book);

  @override
  Future<Either<Failure, bool>> isExists({String itemName}) async {
    final result = await (select(bookTable)
          ..where((tbl) => tbl.name.equals(itemName))
          ..limit(1))
        .getSingle();

    if (result != null) {
      final failure = locator.getWithParam<Failure>(ExceptionCodeType.itemAlreadyExists);
      return Left(failure);
    }
    return const Right(false);

  }
}
