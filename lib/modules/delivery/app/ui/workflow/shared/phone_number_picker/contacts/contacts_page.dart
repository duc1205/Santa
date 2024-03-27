import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/context_ext.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/phone_number_picker/contacts/contacts_page_viewmodel.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/phone_number_picker/contacts/widgets/charity_contact_item.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/phone_number_picker/contacts/widgets/contact_item.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/phone_number_picker/contacts/widgets/empty_contact.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/phone_number_picker/contacts/widgets/no_result_found.dart';
import 'package:santapocket/modules/delivery/domain/models/person.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({
    Key? key,
    required this.listPersons,
    required this.isFromCharity,
    required this.onSelect,
  }) : super(key: key);

  final List<Person> listPersons;
  final bool isFromCharity;
  final Function(String, {String? name}) onSelect;

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends BaseViewState<ContactsPage, ContactsPageViewModel> {
  @override
  void loadArguments() {
    viewModel.loadArguments(widget.listPersons);
    super.loadArguments();
  }

  @override
  ContactsPageViewModel createViewModel() => locator<ContactsPageViewModel>();

  @override
  Widget build(BuildContext context) {
    return viewModel.dataFind.isEmpty
        ? const EmptyContact()
        : Obx(() => Column(children: [
              Padding(
                padding: EdgeInsets.all(14.w),
                child: TextField(
                  controller: viewModel.controller,
                  onChanged: viewModel.onChangeText,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.delivery_search.trans(),
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
                              viewModel.onClearQueryText();
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
              if (viewModel.listPersons.isEmpty)
                const NoResultFound()
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.listPersons.length,
                    shrinkWrap: true,
                    primary: true,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        widget.isFromCharity
                            ? CharityContactItem(
                                person: viewModel.listPersons[index],
                                isSelected: viewModel.selectedIndex == index,
                                itemClick: () => viewModel.onItemClick(index),
                              )
                            : ContactItem(
                                person: viewModel.listPersons[index],
                                isSelected: viewModel.selectedIndex == index,
                                itemClick: () => viewModel.onItemClick(index),
                              ),
                      ]);
                    },
                  ),
                ),
              Visibility(
                visible: viewModel.selectedIndex > -1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50.h,
                    width: 300.w,
                    margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                    child: SizedBox.expand(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onSelect(viewModel.listPersons[viewModel.selectedIndex].phoneNumber);
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.orange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                        ),
                        child: Center(child: Text(LocaleKeys.delivery_select.trans(), style: AppTheme.white_16w600)),
                      ),
                    ),
                  ),
                ),
              ),
            ]));
  }
}
