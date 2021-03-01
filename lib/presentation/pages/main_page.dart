import 'package:flutter/material.dart' hide Router;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart' show ExtendedNavigator;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notebook/core/config/theme/app_themes.dart';
import 'package:notebook/core/utils/routes/router.gr.dart';
import 'package:notebook/presentation/blocs/book_bloc/book_bloc.dart';
import 'package:notebook/presentation/widgets/add_item_btn.dart';
import 'package:notebook/presentation/widgets/centered_circular_progress_indicator.dart';
import 'package:notebook/core/utils/ui/dialogs/book_name_form_dialog.dart';
import 'package:notebook/service_locator/service_locator.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookBloc>(
      create: (_) => locator.get<BookBloc>(),
      child: const MainLayout(),
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('main'),
      ),
      body: const _Body(),
      floatingActionButton: AddItemBtn(onPressed: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return WillPopScope(
                  child: BookNameFormDialog<AddBookDialog>(),
                  onWillPop: () async => false);
            });
      }),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<BookBloc>().watchAllBooks,
      builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CenteredCircularProgressIndicator();
          default:
            if (snapshot.hasError) {
              return const CenteredCircularProgressIndicator();
            } else {
              return _BookListView(bookList: snapshot.data);
            }
        }
      },
    );
  }
}

class _BookListView extends StatelessWidget {
  final SlidableController slidableController = SlidableController();
  final List<Book> bookList;

  _BookListView({
    this.bookList,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: bookList.length,
        itemBuilder: (BuildContext context, int index) {
          return SlidableListTile(
            book: bookList[index],
            slidableController: slidableController,);
        });
  }
}

class SlidableListTile extends StatelessWidget {
  final SlidableController slidableController;

  const SlidableListTile({
    Key key,
    @required this.book,
    @required this.slidableController
  }) : super(key: key);

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(book.name),
      controller: slidableController,
      actionExtentRatio: 0.2,
      actionPane: const SlidableStrechActionPane(),
        child: ListTileTheme(
            iconColor: lightTheme.listTileIconColor,
            child: ListTile(
              title: Text(book.name),
              leading: const Icon(Icons.book),
              onTap: () {
                ExtendedNavigator.of(context).push(Routes.bookWithNotesPage,
                    arguments: BookWithNotesPageArguments(
                        bookName: book.name));
              },
            )),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Rename',
            color: Colors.black45,
            icon: Icons.drive_file_rename_outline,
            onTap: () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return WillPopScope(
                      child: BookNameFormDialog<RenameBookDialog>(
                          book: book),
                      onWillPop: () async => false);
                }),
          ),
          IconSlideAction(
            caption: 'Delete',
            color: Color( 0xffd32f2f ),
            icon: Icons.delete,
            onTap: () => context.read<BookBloc>().add(RemoveBook(book)),
          ),
        ],);
  }
}
