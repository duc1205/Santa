import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/helpers/remote_image_resize_helper.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/instruction/app/ui/detail/instruction_detail_page_view_model.dart';
import 'package:santapocket/modules/instruction/domain/models/instruction.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class InstructionDetailPage extends StatefulWidget {
  final Instruction instruction;

  const InstructionDetailPage({Key? key, required this.instruction}) : super(key: key);

  @override
  State<InstructionDetailPage> createState() => _IntructionDetailPageState();
}

class _IntructionDetailPageState extends BaseViewState<InstructionDetailPage, InstructionDetailPageViewModel> {
  int currentPage = 0;

  @override
  InstructionDetailPageViewModel createViewModel() => locator<InstructionDetailPageViewModel>();

  @override
  void loadArguments() {
    viewModel.instructionId = widget.instruction.id;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.instruction.name?.toUpperCase() ?? "",
          style: AppTheme.black_16bold,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (viewModel.instructionImages.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(14),
                  child: Swiper(
                    loop: viewModel.instructionImages.length > 1,
                    itemCount: viewModel.instructionImages.length,
                    autoplay: false,
                    onIndexChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) => Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: RemoteImageResizeHelper.getImageResize(
                            viewModel.instructionImages[index].url ?? "",
                            0,
                            670.h * MediaQuery.of(context).devicePixelRatio,
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            }),
          ),
          Obx(
            () => Visibility(
              visible: viewModel.instructionImages.length > 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: viewModel.instructionImages.asMap().entries.map((e) {
                  return Container(
                    width: 8.w,
                    height: 8.w,
                    margin: EdgeInsets.only(
                      left: 4.w,
                      right: 4.w,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentPage == e.key ? AppTheme.orange.withOpacity(0.8) : AppTheme.grey.withOpacity(0.5),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
        ],
      ),
    );
  }
}
