import 'package:flutter/material.dart';

class SettingsListTileModel {
  final Icon leading;
  final Widget title;
  final Widget subtitle;
  final String redirectToPage;

  const SettingsListTileModel({
    @required this.leading,
    @required this.title,
    @required this.subtitle,
    this.redirectToPage
  });
}