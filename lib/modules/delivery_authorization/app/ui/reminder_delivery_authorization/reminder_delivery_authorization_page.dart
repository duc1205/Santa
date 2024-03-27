import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/reminder_delivery_authorization/reminder_delivery_authorization_widget.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class ReminderDeliveryAuthorizationPage extends StatefulWidget {
  final List<DeliveryAuthorization> deliveryAuthorizations;

  const ReminderDeliveryAuthorizationPage({required this.deliveryAuthorizations, Key? key}) : super(key: key);

  @override
  State<ReminderDeliveryAuthorizationPage> createState() => _ReminderDeliveryAuthorizationPageState();
}

class _ReminderDeliveryAuthorizationPageState extends State<ReminderDeliveryAuthorizationPage> {
  int _current = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return widget.deliveryAuthorizations.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(bottom: 19.h),
            child: Column(children: [
              ExpandablePageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _current = index;
                  });
                },
                itemBuilder: (context, index) {
                  return ReminderDeliveryAuthorizationWidget(deliveryAuthorization: widget.deliveryAuthorizations[index]);
                },
                itemCount: widget.deliveryAuthorizations.length,
              ),
              if (widget.deliveryAuthorizations.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.deliveryAuthorizations.asMap().entries.map((e) {
                    return Container(
                      width: 8.w,
                      height: 8.w,
                      margin: EdgeInsets.only(left: 4.w, right: 4.w, top: 8.h),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == e.key ? AppTheme.orange.withOpacity(0.8) : AppTheme.grey.withOpacity(0.5),
                      ),
                    );
                  }).toList(),
                ),
            ]),
          )
        : const SizedBox();
  }
}
