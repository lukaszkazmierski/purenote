import 'package:flutter/material.dart';
import 'package:notebook/domain/models/about_application_list_tile_model.dart';
import 'package:package_info/package_info.dart';
import 'package:notebook/service_locator/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

List<AboutApplicationListTileModel> _aboutInfoTiles = [
  const AboutApplicationListTileModel(
      url: 'https://github.com/lukaszkazmierski',
      tile: Text('Developer'),
      subtitle: Text('Łukasz Kaźmierski')
  ),
  const AboutApplicationListTileModel(
      url: 'https://github.com/lukaszkazmierski/purenote',
      tile: Text('Source code'),
      subtitle: Text('https://github.com/lukaszkazmierski/purenote')
  ),
  AboutApplicationListTileModel(
      url: Uri(
        scheme: 'mailto',
        path: 'appstomize@gmail.com').toString(),
      tile: const Text('Contact'),
      subtitle: const Text('appstomize@gmail.com')
  ),
  const AboutApplicationListTileModel(
      url: 'https://github.com/lukaszkazmierski/purenote/blob/master/LICENSE',
      tile: Text('License'),
      subtitle: Text('GNU GPL v3.0')
  ),
  AboutApplicationListTileModel(
      url: 'https://github.com/lukaszkazmierski/purenote/releases',
      tile: const Text('Version'),
      subtitle: Text(locator.get<PackageInfo>().version)
  ),
];

class AboutApplicationPage extends StatelessWidget {
  const AboutApplicationPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('About application')),
      body: Column(
        children: List.generate(_aboutInfoTiles.length, (i) =>
            ListTile(
              title: _aboutInfoTiles[i].tile,
              subtitle: _aboutInfoTiles[i].subtitle,
              onTap: () => launch(_aboutInfoTiles[i].url),
            )
        ),
      ),
    );
  }
}