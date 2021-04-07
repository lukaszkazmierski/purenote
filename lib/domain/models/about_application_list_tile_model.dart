import 'package:flutter/material.dart';

class AboutApplicationListTileModel {
  final Text tile;
  final Text subtitle;
  final String url;

  const AboutApplicationListTileModel({
    @required this.tile,
    @required  this.subtitle,
    this.url
  });
}