import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'int_resource.dart';

class IntLocalizationsDelegate extends LocalizationsDelegate<IntLocalizations> {
  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<IntLocalizations> load(Locale locale) {
    return SynchronousFuture<IntLocalizations>(
      IntLocalizations(locale.languageCode == "zh"),
    );
  }

  @override
  bool shouldReload(LocalizationsDelegate old) {
    return false;
  }
}
