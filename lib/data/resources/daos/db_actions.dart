import 'package:dartz/dartz.dart';
import 'package:moor/moor.dart';
import 'package:notebook/core/exceptions/failure.dart';

abstract class DbActions<D extends DataClass> {
  Future<List<D>> getAllItem();
  Stream<List<D>> watchAllItem([String bookName]);
  Future<Either<Failure, int>> insertItem(Insertable<D> item);
  Future<Either<Failure, bool>> updateItem(Insertable<D> item);
  Future deleteItem(Insertable<D> item);
}