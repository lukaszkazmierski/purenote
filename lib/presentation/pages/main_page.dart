import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notebook/app.dart';
import 'package:notebook/data/resources/notebook_local_db_impl.dart';


import 'package:notebook/presentation/blocs/book_bloc.dart';
import 'package:notebook/presentation/widgets/add_item_btn.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookBloc(NotebookLocalDbImpl()),
      child: NewWidget(),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('main'),
        ),
        body: Content(),
        floatingActionButton: AddItemBtn(onPressed: () {
    final book = BookTableCompanion(name: Value<String>('s'));
    context.read<BookBloc>().add(AddingNewBook(book));
    }),
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: FutureBuilder(
        future: context.watch<BookBloc>().getAllBooks,
        builder: (BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return BlocBuilder<BookBloc, BookState>(
                builder: (BuildContext context, BookState builder) {
              return Container(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(title: Text(snapshot.data[index].name));
                    }),
              );
            });
          }
        },
      ),
    );
  }
}

//ElevatedButton(onPressed: () => ExtendedNavigator.of(context).push(Routes.bookWithNotesPage)),
