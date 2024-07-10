// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Main Category`
  String get main_category {
    return Intl.message(
      'Main Category',
      name: 'main_category',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to delete them all?`
  String get delete_question {
    return Intl.message(
      'Do you want to delete them all?',
      name: 'delete_question',
      desc: '',
      args: [],
    );
  }

  /// `YES`
  String get yes {
    return Intl.message(
      'YES',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Switch`
  String get swap {
    return Intl.message(
      'Switch',
      name: 'swap',
      desc: '',
      args: [],
    );
  }

  /// `Please select two item to swap.`
  String get switch_question {
    return Intl.message(
      'Please select two item to swap.',
      name: 'switch_question',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Please select only one item at a time to edit.`
  String get edit_question {
    return Intl.message(
      'Please select only one item at a time to edit.',
      name: 'edit_question',
      desc: '',
      args: [],
    );
  }

  /// `Record List`
  String get record_List {
    return Intl.message(
      'Record List',
      name: 'record_List',
      desc: '',
      args: [],
    );
  }

  /// `Select a record`
  String get record_describe {
    return Intl.message(
      'Select a record',
      name: 'record_describe',
      desc: '',
      args: [],
    );
  }

  /// `Add New Counter`
  String get new_count {
    return Intl.message(
      'Add New Counter',
      name: 'new_count',
      desc: '',
      args: [],
    );
  }

  /// `Add New Category`
  String get new_category {
    return Intl.message(
      'Add New Category',
      name: 'new_category',
      desc: '',
      args: [],
    );
  }

  /// `More exciting features coming soon!`
  String get coming_soon {
    return Intl.message(
      'More exciting features coming soon!',
      name: 'coming_soon',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get export {
    return Intl.message(
      'Export',
      name: 'export',
      desc: '',
      args: [],
    );
  }

  /// `Data will been export to "Download" folder by file named "FlutterSharedPreferences.xml". \n Do you want to export?`
  String get export_describe {
    return Intl.message(
      'Data will been export to "Download" folder by file named "FlutterSharedPreferences.xml". \n Do you want to export?',
      name: 'export_describe',
      desc: '',
      args: [],
    );
  }

  /// `Data have been export to "Download" folder`
  String get export_success {
    return Intl.message(
      'Data have been export to "Download" folder',
      name: 'export_success',
      desc: '',
      args: [],
    );
  }

  /// `Data export fail err code: `
  String get export_fail {
    return Intl.message(
      'Data export fail err code: ',
      name: 'export_fail',
      desc: '',
      args: [],
    );
  }

  /// `Chart`
  String get chart {
    return Intl.message(
      'Chart',
      name: 'chart',
      desc: '',
      args: [],
    );
  }

  /// `'s note`
  String get record_of {
    return Intl.message(
      '\'s note',
      name: 'record_of',
      desc: '',
      args: [],
    );
  }

  /// `SAVE`
  String get save {
    return Intl.message(
      'SAVE',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Add Note Here.`
  String get add_here {
    return Intl.message(
      'Add Note Here.',
      name: 'add_here',
      desc: '',
      args: [],
    );
  }

  /// `Title can't be empty!!`
  String get title_warning {
    return Intl.message(
      'Title can\'t be empty!!',
      name: 'title_warning',
      desc: '',
      args: [],
    );
  }

  /// `Fail to save record. Please try again.`
  String get save_err {
    return Intl.message(
      'Fail to save record. Please try again.',
      name: 'save_err',
      desc: '',
      args: [],
    );
  }

  /// `Save succeed!`
  String get save_success {
    return Intl.message(
      'Save succeed!',
      name: 'save_success',
      desc: '',
      args: [],
    );
  }

  /// `Counter Edit`
  String get counter_edit {
    return Intl.message(
      'Counter Edit',
      name: 'counter_edit',
      desc: '',
      args: [],
    );
  }

  /// `Category Edit`
  String get category_edit {
    return Intl.message(
      'Category Edit',
      name: 'category_edit',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Value`
  String get value {
    return Intl.message(
      'Value',
      name: 'value',
      desc: '',
      args: [],
    );
  }

  /// `Select Color:`
  String get select_color {
    return Intl.message(
      'Select Color:',
      name: 'select_color',
      desc: '',
      args: [],
    );
  }

  /// `Change Lost`
  String get lost_warning {
    return Intl.message(
      'Change Lost',
      name: 'lost_warning',
      desc: '',
      args: [],
    );
  }

  /// `If you haven't save yet. New data change might be lost.`
  String get lost_warning_describe {
    return Intl.message(
      'If you haven\'t save yet. New data change might be lost.',
      name: 'lost_warning_describe',
      desc: '',
      args: [],
    );
  }

  /// `Ignore`
  String get ignore {
    return Intl.message(
      'Ignore',
      name: 'ignore',
      desc: '',
      args: [],
    );
  }

  /// `Add New Note`
  String get add_note {
    return Intl.message(
      'Add New Note',
      name: 'add_note',
      desc: '',
      args: [],
    );
  }

  /// `View Note List`
  String get view_note {
    return Intl.message(
      'View Note List',
      name: 'view_note',
      desc: '',
      args: [],
    );
  }

  /// `Edit Picture`
  String get edit_picture {
    return Intl.message(
      'Edit Picture',
      name: 'edit_picture',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Item`
  String get item {
    return Intl.message(
      'Item',
      name: 'item',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Long press on item/category can change mode.`
  String get help_message {
    return Intl.message(
      'Long press on item/category can change mode.',
      name: 'help_message',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
