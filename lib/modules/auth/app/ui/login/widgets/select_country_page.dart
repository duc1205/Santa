import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/auth/domain/models/country.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class SelectCountryPage extends StatefulWidget {
  const SelectCountryPage({required this.countries, required this.currentCountryCode, required this.onSelectedCountry, Key? key}) : super(key: key);

  final List<Country> countries;
  final String currentCountryCode;
  final Function(Country) onSelectedCountry;

  @override
  State<SelectCountryPage> createState() => _SelectCountryPageState();
}

class _SelectCountryPageState extends State<SelectCountryPage> {
  int _selectedIndex = -1;

  @override
  void initState() {
    _selectedIndex = widget.countries.indexWhere((country) => country.phoneCode == widget.currentCountryCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(
          LocaleKeys.auth_select_country.trans(),
          style: AppTheme.black_18,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
            16.w,
          ),
          child: ListView.separated(
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onSelectedCountry(widget.countries[index]);
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Row(
                  children: [
                    Text(
                      widget.countries[index].name,
                      style: AppTheme.black_16,
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    if (_selectedIndex == index)
                      Icon(
                        Icons.check_circle,
                        color: AppTheme.orange,
                        size: 16.sp,
                      )
                    else
                      Container(),
                    const Spacer(),
                    Text(
                      widget.countries[index].phoneCode,
                      style: AppTheme.black_16,
                    ),
                  ],
                ),
              ),
            ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: widget.countries.length,
          ),
        ),
      ),
    );
  }
}
