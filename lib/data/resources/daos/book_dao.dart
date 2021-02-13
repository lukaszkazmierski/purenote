import 'package:moor_flutter/moor_flutter.dart';
import 'package:notebook/data/resources/moor_config/moor_database.dart';
import 'package:notebook/data/resources/sql_tables/book_table.dart';
import 'package:notebook/data/resources/daos/db_actions.dart';

part 'book_dao.g.dart';

@UseDao(tables: [BookTable])
class BookDao extends DatabaseAccessor<MoorDatabase>
    with _$BookDaoMixin implements DbActions<Book>  {

  final MoorDatabase db;

  BookDao(this.db) : super(db);

  @override
  Future<List<Book>> getAllItem() => select(bookTable).get();
  @override
  Stream<List<Book>> watchAllItem() => select(bookTable).watch();
  @override
  Future insertItem(Insertable<Book> note) => into(bookTable).insert(note);
  @override
  Future updateItem(Insertable<Book> note) => update(bookTable).replace(note);
  @override
  Future deleteItem(Insertable<Book> note) => delete(bookTable).delete(note);
}