import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/phone_number_picker/contacts/contacts_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/phone_number_picker/phone_number_picker_page_view_model.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/phone_number_picker/recent_receivers/recent_receivers_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class PhoneNumberPickerPage extends StatefulWidget {
  const PhoneNumberPickerPage({
    required this.cabinetName,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  final String cabinetName;
  final Function(String, {String? name}) onSelect;

  @override
  State<PhoneNumberPickerPage> createState() => _PhoneNumberPickerPageState();
}

class _PhoneNumberPickerPageState extends BaseViewState<PhoneNumberPickerPage, PhoneNumberPickerPageViewModel> {
  int currentIndex = 0;

  @override
  PhoneNumberPickerPageViewModel createViewModel() => locator<PhoneNumberPickerPageViewModel>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.5,
          title: Text(
            widget.cabinetName,
            style: AppTheme.black_16bold,
          ),
          bottom: TabBar(
            onTap: (position) {
              setState(() {
                currentIndex = position;
              });
            },
            unselectedLabelColor: AppTheme.grey,
            indicatorColor: AppTheme.orange,
            labelColor: AppTheme.orange,
            labelStyle: AppTheme.yellow1_14w600,
            tabs: [
              Tab(
                text: LocaleKeys.delivery_recent.trans(),
              ),
              Tab(
                text: LocaleKeys.delivery_contact.trans(),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: IndexedStack(
          index: currentIndex,
          children: [
            Obx(
              () => RecentReceiversPage(
                recentReceivers: viewModel.recentReceivers,
                canLoadMore: viewModel.canLoadMore,
                onLoadMore: viewModel.onLoadMore,
                selectedUser: viewModel.selectedReceiver,
                onItemClick: viewModel.onItemClickUser,
                isFromCharity: false,
                onSelect: widget.onSelect,
              ),
            ),
            Obx(
              () => ContactsPage(
                listPersons: viewModel.listPersons,
                isFromCharity: false,
                onSelect: widget.onSelect,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
