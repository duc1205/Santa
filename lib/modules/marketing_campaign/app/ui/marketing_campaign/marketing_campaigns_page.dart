import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/helpers/remote_image_resize_helper.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/marketing_campaign/app/ui/marketing_campaign/marketing_campaigns_page_viewmodel.dart';
import 'package:santapocket/modules/marketing_campaign/domain/models/marketing_campaign.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class MarketingCampaignsPage extends StatefulWidget {
  final bool shouldShowPopup;

  const MarketingCampaignsPage({
    Key? key,
    required this.shouldShowPopup,
  }) : super(key: key);

  @override
  State<MarketingCampaignsPage> createState() => _MarketingCampaignsPageState();
}

class _MarketingCampaignsPageState extends BaseViewState<MarketingCampaignsPage, MarketingCampaignsPageViewModel> {
  ///auto play transition duration (in millisecond)
  static const int interval = 10000;
  int currentPage = 0;

  @override
  MarketingCampaignsPageViewModel createViewModel() => locator<MarketingCampaignsPageViewModel>();

  @override
  void loadArguments() {
    viewModel.shouldShowPopup = widget.shouldShowPopup;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () {
            if (viewModel.marketingCampaigns.isNotEmpty) {
              return SizedBox(
                height: 162.h,
                child: Swiper(
                  itemCount: viewModel.marketingCampaigns.length,
                  autoplay: viewModel.marketingCampaigns.length == 1 ? false : true,
                  autoplayDelay: interval,
                  physics: viewModel.marketingCampaigns.length > 1 ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                  onIndexChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) => MarketingCampaignBanner(
                    marketingCampaign: viewModel.marketingCampaigns[index],
                    onClickBanner: () => viewModel.onClickBanner(
                      viewModel.marketingCampaigns[index].postUrl,
                      viewModel.marketingCampaigns[index].needAccessToken,
                      viewModel.marketingCampaigns[index].id,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
        Obx(() {
          if (viewModel.marketingCampaigns.length > 1) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: viewModel.marketingCampaigns.asMap().entries.map((e) {
                return Container(
                  width: 8.w,
                  height: 8.w,
                  margin: EdgeInsets.only(left: 4.w, right: 4.w, top: 8.h, bottom: 15.h),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPage == e.key ? AppTheme.orange.withOpacity(0.8) : AppTheme.grey.withOpacity(0.5),
                  ),
                );
              }).toList(),
            );
          } else if (viewModel.marketingCampaigns.length == 1) {
            return SizedBox(
              height: 15.h,
            );
          }
          return const SizedBox();
        }),
      ],
    );
  }
}

class MarketingCampaignBanner extends StatelessWidget {
  final MarketingCampaign marketingCampaign;
  final Function() onClickBanner;

  const MarketingCampaignBanner({Key? key, required this.marketingCampaign, required this.onClickBanner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 21.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onClickBanner,
          child: CachedNetworkImage(
            imageUrl: RemoteImageResizeHelper.getImageResize(
              marketingCampaign.bannerUrl ?? "",
              345.w * MediaQuery.of(context).devicePixelRatio,
              162.h * MediaQuery.of(context).devicePixelRatio,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
