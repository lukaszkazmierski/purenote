import 'package:notebook/data/resources/daos/db_actions.dart';

abstract class NotebookLocalDb {
  DbActions get book;
  DbActions get note;
}