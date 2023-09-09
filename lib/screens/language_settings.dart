import 'package:Molhem/core/helpers/theme_helper.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSettings extends StatefulWidget {

  @override
  _LanguageSettingsState createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  String _selectedLanguage = ''; // Empty string means no language selected

  void _selectLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  @override
  void initState() {
    super.initState();
    // Load the selected language from SharedPreferences
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('languageCode') ?? context.locale.languageCode;
    });
  }

  Future<void> _saveSelectedLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', language);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: SizedBox(
            height: 50,
            child: AutoSizeText(
              'select_your_language'.tr(),
              style: theme.textTheme.headline6?.copyWith(
                color: ThemeHelper.blueAlter,
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),
              maxLines: 1,
            ),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.language,
            color: ThemeHelper.blueAlter,
            size: 40,
          ),
          title: Text(
            'english',
            style: ThemeHelper.headingText(context)?.copyWith(
              fontSize: 30
            ),
          ).tr(),
          trailing: _selectedLanguage == 'en'
              ? Icon(
                  Icons.check,
                  color: ThemeHelper.blueAlter,
            size: 40,
                )
              : null,
          onTap: () async {
            await _saveSelectedLanguage('en');
            await context.setLocale(Locale('en',''));
            _selectLanguage('en');
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            height: 32,
            thickness: 1,
            color: theme.primaryColor.withOpacity(0.2),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.language,
            color: ThemeHelper.blueAlter,
            size: 40,
          ),
          title: Text(
            'arabic',
            style: ThemeHelper.headingText(context)?.copyWith(
                fontSize: 30
            ),
          ).tr(),
          trailing: _selectedLanguage == 'ar'
              ? Icon(
                  Icons.check,
                  color: theme.primaryColor,
                )
              : null,
          onTap: () async {
            await _saveSelectedLanguage('ar');
            await context.setLocale(Locale('ar',''));
            _selectLanguage('ar');
          },
        ),
      ],
    );
  }
}
