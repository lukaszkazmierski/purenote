import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:notebook/core/utils/routes/router.gr.dart';
import 'package:notebook/service_locator/service_locator.dart';
import 'package:package_info/package_info.dart';
import 'package:notebook/domain/models/settings_list_tile_model.dart';

List<SettingsListTileModel> _tiles = [
  SettingsListTileModel(
    leading: const Icon(Icons.info),
    title: const Text('About the application'),
    subtitle: Text(locator.get<PackageInfo>().version),
    redirectToPage: Routes.aboutApplicationPage
  )
];

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: FractionallySizedBox(
        widthFactor: 0.9,
        child: ListView(
          children: _listTiles(context)
        ),
      )
    );
  }

  List<Widget> _listTiles(BuildContext context) {
    return List.generate(_tiles.length, (i) =>
        ListTile(
          leading: _tiles[i].leading,
          title: _tiles[i].title,
          subtitle: _tiles[i].subtitle,
          onTap: () => ExtendedNavigator.of(context).push(_tiles[i].redirectToPage),
        )
    );
  }
}