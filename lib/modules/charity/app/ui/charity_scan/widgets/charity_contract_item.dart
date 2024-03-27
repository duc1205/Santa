import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class CharityContractItem extends StatelessWidget {
  final String url;
  final String iconUrl;
  final String orgName;

  const CharityContractItem({
    super.key,
    required this.url,
    required this.orgName,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16.r),
        ),
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
            child: url.isEmpty
                ? Assets.icons.icCharityDefaultContract.image(
                    height: 94.h,
                    width: 178.w,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    url,
                    height: 94.h,
                    width: 178.w,
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
            child: Row(
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.w),
                    image: DecorationImage(
                      image: iconUrl.isNotEmpty
                          ? NetworkImage(
                              iconUrl,
                            )
                          : Assets.icons.icCharityOrgDefaultIcon.provider(),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  width: 6.w,
                ),
                Expanded(
                  child: Text(
                    orgName,
                    style: AppTheme.black_14w600,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
