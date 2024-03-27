import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class ChangeLanguageDialog extends StatelessWidget {
  final Language language;
  final Function(Language) onChangeLanguage;

  const ChangeLanguageDialog({required this.language, required this.onChangeLanguage, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 32.w, right: 16.w),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onChangeLanguage(Language.vi),
            child: Row(
              children: [
                Text(
                  LocaleKeys.auth_vietnamese.trans(),
                  style: AppTheme.black_14,
                ),
                const Spacer(),
                Radio(
                  value: Language.vi,
                  groupValue: language,
                  activeColor: AppTheme.orange,
                  onChanged: (value) {
                    onChangeLanguage(Language.vi);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onChangeLanguage(Language.en),
            child: Row(
              children: [
                Text(
                  LocaleKeys.auth_english.trans(),
                  style: AppTheme.black_14,
                ),
                const Spacer(),
                Radio(
                  value: Language.en,
                  groupValue: language,
                  activeColor: AppTheme.orange,
                  onChanged: (value) => onChangeLanguage(Language.en),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
