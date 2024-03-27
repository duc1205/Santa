import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket_size.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/fill_info/pocket_sizes_widget.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

// ignore: must_be_immutable
class ChangePocketSizeBottomSheet extends StatefulWidget {
  final Function(PocketSize pocketsize) onSubmit;
  final List<PocketSize> pocketSizes;
  int selectedPocketSizeIndex;
  final int selectedPocketSizeId;

  ChangePocketSizeBottomSheet({
    Key? key,
    required this.onSubmit,
    required this.pocketSizes,
    required this.selectedPocketSizeIndex,
    required this.selectedPocketSizeId,
  }) : super(key: key);

  @override
  State<ChangePocketSizeBottomSheet> createState() => _ChangePocketSizeBottomSheetState();
}

class _ChangePocketSizeBottomSheetState extends State<ChangePocketSizeBottomSheet> {
  void _onSelectPocket(int index) {
    if ((widget.pocketSizes[index].availablePocketsCount ?? 0) > 0 && widget.selectedPocketSizeId != widget.pocketSizes[index].id) {
      setState(() {
        widget.selectedPocketSizeIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(LocaleKeys.delivery_select_size.trans(), style: AppTheme.orange_14w600),
              InkWell(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.close,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
        ),
        PocketSizesWidget(
          pocketSizes: widget.pocketSizes,
          selectedPocketSizeIndex: widget.selectedPocketSizeIndex,
          onSelectPocket: _onSelectPocket,
          selectedPocketSizeId: widget.selectedPocketSizeId,
        ),
        SizedBox(
          height: 10.h,
        ),
        const Divider(
          height: 1,
        ),
        Container(
          height: 50.h,
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 19.h),
          child: SizedBox.expand(
            child: TapDebouncer(
              onTap: () async {
                if (widget.selectedPocketSizeIndex < 0) {
                  showToast(LocaleKeys.delivery_must_select_pocket_sentence.trans());
                } else {
                  await widget.onSubmit(widget.pocketSizes[widget.selectedPocketSizeIndex]);
                }
              },
              builder: (BuildContext context, Future<void> Function()? onTap) {
                return ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      LocaleKeys.delivery_submit.trans(),
                      style: AppTheme.white_16w600,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
