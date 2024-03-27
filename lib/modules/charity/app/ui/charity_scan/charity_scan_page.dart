import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/context_ext.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/charity/app/ui/charity_scan/charity_scan_page_viewmodel.dart';
import 'package:santapocket/modules/charity/app/ui/charity_scan/widgets/charity_contract_item.dart';
import 'package:santapocket/shared/textfeild/debounce_textfield.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class CharityScanPage extends StatefulWidget {
  const CharityScanPage({super.key});

  @override
  State<CharityScanPage> createState() => _CharityScanPageState();
}

class _CharityScanPageState extends BaseViewState<CharityScanPage, CharityScanPageViewModel> {
  @override
  CharityScanPageViewModel createViewModel() => locator<CharityScanPageViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [AppTheme.carnationBloom.withOpacity(0.3), AppTheme.white],
            stops: const [
              0.01,
              0.6,
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: viewModel.refreshCharities,
          child: CustomScrollView(
            shrinkWrap: true,
            controller: viewModel.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    children: [
                      SizedBox(
                        height: 16.w,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.r),
                          ),
                          color: AppTheme.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                                    child: Assets.images.imgCharityBackground.image(fit: BoxFit.fill),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              LocaleKeys.charity_charity_love_message.trans(),
                              style: AppTheme.brakeRed_14w600,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 14.h,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                        width: double.infinity,
                        color: AppTheme.lumberOrange,
                        child: Center(
                          child: EasyRichText(
                            LocaleKeys.charity_choose_charity_org.trans(),
                            defaultStyle: AppTheme.black_14w400,
                            patternList: [
                              EasyRichTextPattern(
                                targetString: '“${LocaleKeys.charity_charity_org.trans()}”',
                                style: AppTheme.black_14w600,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Obx(
                          () => DebounceTextfield(
                            action: viewModel.filterCabinets,
                            controller: viewModel.textEditingController,
                            duration: const Duration(milliseconds: 300),
                            onTextfieldEmpty: viewModel.refreshCharities,
                            textFieldStyle: AppTheme.blackDark_14w400,
                            inputDecoration: InputDecoration(
                              hintText: LocaleKeys.charity_search_organization.trans(),
                              hintStyle: AppTheme.grey_14w400,
                              fillColor: Colors.white,
                              filled: true,
                              isDense: true,
                              prefixIcon: Assets.icons.icSearch.image(
                                width: 20.w,
                                height: 20.h,
                              ),
                              suffixIcon: viewModel.query.trim().isEmpty
                                  ? const SizedBox()
                                  : TapDebouncer(
                                      onTap: () async {
                                        context.hideKeyboard();
                                        await viewModel.refreshCharities();
                                      },
                                      builder: (BuildContext context, TapDebouncerFunc? onTap) => IconButton(
                                        onPressed: onTap,
                                        icon: Icon(
                                          Icons.clear,
                                          size: 20.sp,
                                          color: AppTheme.grey.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppTheme.gluttonyOrange, width: 1.w),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.w),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Obx(
                          () => viewModel.charities.isEmpty && viewModel.isEmptyList
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 54.h,
                                    ),
                                    Assets.images.imgEmptyDonation.image(),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Text(
                                      LocaleKeys.charity_no_charity_org.trans(),
                                      style: AppTheme.blackDark_14w400,
                                    ),
                                  ],
                                )
                              : viewModel.charities.isEmpty && viewModel.isEmptySearch
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: 54.h,
                                        ),
                                        Assets.images.imgSearchEmpty.image(),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Text(
                                          LocaleKeys.charity_no_result_found.trans(),
                                          style: AppTheme.blackDark_14w400,
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Text(
                                          LocaleKeys.charity_try_different_keyword.trans(),
                                          style: AppTheme.blackDark_18w600,
                                        ),
                                      ],
                                    )
                                  : GridView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.symmetric(vertical: 15.h),
                                      shrinkWrap: true,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 167.w / 153.h,
                                        crossAxisSpacing: 11.w,
                                        mainAxisSpacing: 11.h,
                                      ),
                                      itemBuilder: ((context, index) => GestureDetector(
                                            onTap: () => viewModel.onClickButton(viewModel.charities.elementAt(index)),
                                            child: CharityContractItem(
                                              iconUrl: viewModel.charities[index].iconUrl ?? "",
                                              url: viewModel.charities.elementAt(index).imageUrl ?? "",
                                              orgName: viewModel.charities.elementAt(index).name,
                                            ),
                                          )),
                                      itemCount: viewModel.charities.length,
                                    ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
