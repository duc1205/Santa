import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';

class LoadMoreView extends StatelessWidget {
  const LoadMoreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(LocaleKeys.shared_loading.trans()),
          SizedBox(
            width: 8.w,
          ),
          SizedBox(
            width: 15.w,
            height: 15.w,
            child: const FittedBox(child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.orange))),
          ),
        ],
      ),
    );
  }
}
