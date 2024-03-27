import 'dart:async';

import 'package:flutter/material.dart';

class EasyListView extends StatefulWidget {
  const EasyListView({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.loadMore = false,
    this.onLoadMore,
    this.loadMoreWhenNoData = false,
    this.loadMoreItemBuilder,
    this.dividerBuilder,
    this.physics,
    this.headerSliverBuilder,
    this.controller,
    this.foregroundWidget,
    this.placeholderWidget,
    this.padding,
    this.scrollbarEnable = true,
    this.isSliverMode = false,
    this.shrinkWrap = false,
    // [Not Recommended]
    // Sliver mode will discard a lot of ListView variables (likes physics, controller),
    // and each of items must be sliver.
    // *Sliver mode will build all items when inited. (ListView item is built by lazy)*
  }) : super(key: key);

  final int itemCount;
  final WidgetBuilder? headerBuilder;
  final WidgetBuilder? footerBuilder;
  final WidgetBuilder? loadMoreItemBuilder;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? dividerBuilder;
  final bool? loadMore;
  final bool? loadMoreWhenNoData;
  final bool? scrollbarEnable;
  final VoidCallback? onLoadMore;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final NestedScrollViewHeaderSliversBuilder? headerSliverBuilder;
  final Widget? foregroundWidget;
  final Widget? placeholderWidget;
  final EdgeInsetsGeometry? padding;
  final bool? isSliverMode;
  final bool? shrinkWrap;

  @override
  State<StatefulWidget> createState() => EasyListViewState();
}

enum ItemType { header, footer, loadMore, data, dividerData, placeholder }

class EasyListViewState extends State<EasyListView> {
  bool get isNested => widget.headerSliverBuilder != null;
  double? _placeholderHeight;
  final GlobalKey _headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _onBuildCompleted(context));
  }

  void _onBuildCompleted(BuildContext context) {
    double headerHeight = 0;

    if (_hasHeader()) {
      // ignore: cast_nullable_to_non_nullable
      final RenderBox renderBoxRed = _headerKey.currentContext!.findRenderObject() as RenderBox;
      headerHeight = renderBoxRed.size.height;
    }
    final remainSize = context.size!.height - headerHeight;

    if (_placeholderHeight == null) {
      _placeholderHeight = remainSize;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final listView = isNested
        ? NestedScrollView(
            headerSliverBuilder: widget.headerSliverBuilder!,
            physics: widget.physics,
            controller: widget.controller,
            body: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: _buildList(),
            ),
          )
        : _buildList();
    return listView;
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final headerCount = _headerCount();
    const placeHolderCount = 1;
    final totalItemCount = _dataItemCount() + headerCount + _footerCount() + placeHolderCount;
    switch (_itemType(index, totalItemCount)) {
      case ItemType.header:
        return Container(
          key: _headerKey,
          child: widget.headerBuilder!(context),
        );
      case ItemType.placeholder:
        final double height = _placeholderHeight ?? 0;
        return (!_needShowPlaceHolder() || widget.placeholderWidget == null)
            ? Container()
            : SizedBox(
                height: height,
                child: widget.placeholderWidget,
              );
      case ItemType.footer:
        return widget.footerBuilder!(context);
      case ItemType.loadMore:
        return _buildLoadMoreItem();
      case ItemType.dividerData:
        return _buildDividerWithData(index, index - headerCount - placeHolderCount);
      case ItemType.data:
      default:
        return widget.itemBuilder(context, index - headerCount - placeHolderCount);
    }
  }

  Stack _buildList() {
    final headerCount = _headerCount();
    const placeHolderCount = 1;
    final totalItemCount = _dataItemCount() + headerCount + _footerCount() + placeHolderCount;
    final ScrollView listView = widget.isSliverMode!
        ? CustomScrollView(
            slivers: List.generate(totalItemCount, (index) => _itemBuilder(context, index)),
          )
        : ListView.builder(
            physics: isNested ? null : widget.physics,
            controller: isNested ? null : widget.controller,
            padding: widget.padding,
            itemCount: totalItemCount,
            itemBuilder: _itemBuilder,
            shrinkWrap: widget.shrinkWrap ?? false,
          );

    final List<Widget> children = widget.scrollbarEnable! ? [Scrollbar(child: listView)] : [listView];
    if (widget.foregroundWidget != null) children.add(widget.foregroundWidget!);
    return Stack(children: children);
  }

  ItemType _itemType(itemIndex, int totalItemCount) {
    if (_isHeader(itemIndex)) {
      return ItemType.header;
    } else if (_isPlaceHolder(itemIndex)) {
      return ItemType.placeholder;
    } else if (_isLoadMore(itemIndex, totalItemCount)) {
      return ItemType.loadMore;
    } else if (_isFooter(itemIndex, totalItemCount)) {
      return ItemType.footer;
    } else if (_hasDivider()) {
      return ItemType.dividerData;
    } else {
      return ItemType.data;
    }
  }

  Widget _buildLoadMoreItem() {
    if ((widget.loadMoreWhenNoData! || (!widget.loadMoreWhenNoData! && widget.itemCount > 0)) && widget.onLoadMore != null) {
      Timer(const Duration(milliseconds: 50), widget.onLoadMore!);
    }
    return widget.loadMoreItemBuilder != null
        ? widget.loadMoreItemBuilder!(context)
        : widget.isSliverMode!
            ? SliverList(delegate: SliverChildListDelegate([_defaultLoadMore]))
            : _defaultLoadMore;
  }

  Widget _buildDividerWithData(int index, int dataIndex) => index.isEven
      ? widget.dividerBuilder != null
          ? widget.dividerBuilder!(context, dataIndex ~/ 2)
          : widget.isSliverMode!
              ? SliverList(delegate: SliverChildListDelegate([_defaultDivider]))
              : _defaultDivider
      : widget.itemBuilder(context, dataIndex ~/ 2);

  bool _isHeader(itemIndex) => _hasHeader() && itemIndex == 0;

  bool _isPlaceHolder(itemIndex) => itemIndex == (_hasHeader() ? _headerCount() : 0);

  bool _isLoadMore(itemIndex, int total) => widget.loadMore! && itemIndex == total - 1;

  bool _isFooter(itemIndex, int total) => _hasFooter() && itemIndex == total - 1;

  int _headerCount() => _hasHeader() ? 1 : 0;

  int _footerCount() => (_hasFooter() || widget.loadMore!) ? 1 : 0;

  int _dataItemCount() => _hasDivider() ? widget.itemCount * 2 - 1 : widget.itemCount;

  bool _hasDivider() => widget.dividerBuilder != null;

  bool _hasHeader() => widget.headerBuilder != null;

  bool _needShowPlaceHolder() => widget.itemCount == 0;

  bool _hasFooter() => widget.footerBuilder != null;

  final _defaultLoadMore = Container(
    padding: const EdgeInsets.all(8.0),
    child: const Center(
      child: CircularProgressIndicator(),
    ),
  );

  final _defaultDivider = const Divider(color: Colors.grey);
}
