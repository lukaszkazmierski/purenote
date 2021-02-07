import 'package:moor/moor.dart';

abstract class DbActions<D extends DataClass> {
  Future<List<D>> getAllItem();
  Stream<List<D>> watchAllItem();
  Future insertItem(Insertable<D> note);
  Future updateItem(Insertable<D> note);
  Future deleteItem(Insertable<D> note);
}