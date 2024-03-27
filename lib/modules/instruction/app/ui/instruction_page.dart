import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/instruction/app/ui/instruction_page_view_model.dart';
import 'package:santapocket/modules/instruction/app/ui/widgets/instruction_list_item.dart';
import 'package:santapocket/shared/listview/easy_listview.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class InstructionPage extends StatefulWidget {
  const InstructionPage({Key? key}) : super(key: key);

  @override
  State<InstructionPage> createState() => _InstructionPageState();
}

class _InstructionPageState extends BaseViewState<InstructionPage, InstructionPageViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.instruction_title.trans().toUpperCase(),
          style: AppTheme.black_16bold,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(
        () => EasyListView(
          itemCount: viewModel.instructions.length,
          itemBuilder: (_, index) => InstructionListItem(
            instruction: viewModel.instructions[index],
          ),
        ),
      ),
    );
  }

  @override
  InstructionPageViewModel createViewModel() => locator<InstructionPageViewModel>();
}
