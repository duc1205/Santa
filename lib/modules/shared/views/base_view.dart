import 'package:flutter/material.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/shared/view_models/base_view_model.dart';

class BaseView<T extends BaseViewModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T)? onViewModelReady;

  const BaseView({Key? key, required this.builder, this.onViewModelReady}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  T viewModel = locator<T>();

  @override
  void initState() {
    if (widget.onViewModelReady != null) {
      widget.onViewModelReady!(viewModel);
    } else {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
