import 'package:auto_route/auto_route_annotations.dart';
import 'package:notebook/presentation/pages/book_with_notes_pages.dart';
import 'package:notebook/presentation/pages/intro_page.dart';
import 'package:notebook/presentation/pages/main_page.dart';
import 'package:notebook/presentation/pages/note_edit_page.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: MainPage),
    MaterialRoute(page: IntroPage),
    MaterialRoute(page: BookWithNotesPage),
    MaterialRoute(page: NoteEditPage),
  ]
)
class $Router {}