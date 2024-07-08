import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sig_pagination/model/model.dart';
import 'package:signals/signals_flutter.dart';

class PaginationScreen<T> extends StatefulWidget {
  final Future<List<T>> Function() future;
  final APagination pagination;
  final RefreshController? refreshController;
  final TextEditingController? searchController;
  final Widget Function(List<T>) pageBuilder;
  final Widget emptyWidget;
  final Widget loadingWidget;
  final Widget Function(dynamic, StackTrace, FutureSignal<List<T>>) errorWidget;

  /// header indicator displace before content
  ///
  /// If reverse is false,header displace at the top of content.
  /// If reverse is true,header displace at the bottom of content.
  /// if scrollDirection = Axis.horizontal,it will display at left or right
  ///
  /// from 1.5.2,it has been change RefreshIndicator to Widget,but remember only pass sliver widget,
  /// if you pass not a sliver,it will throw error
  final Widget? header;

  /// footer indicator display after content
  ///
  /// If reverse is true,header displace at the top of content.
  /// If reverse is false,header displace at the bottom of content.
  /// if scrollDirection = Axis.horizontal,it will display at left or right
  ///
  /// from 1.5.2,it has been change LoadIndicator to Widget,but remember only pass sliver widget,
  //  if you pass not a sliver,it will throw error
  final Widget? footer;
  // This bool will affect whether or not to have the function of drop-up load.
  final bool enablePullUp;

  /// callback when header ready to twoLevel
  ///
  /// If you want to close twoLevel,you should use [RefreshController.closeTwoLevel]
  final OnTwoLevel? onTwoLevel;

  /// copy from ScrollView,for setting in SingleChildView,not ScrollView
  final Axis? scrollDirection;

  /// copy from ScrollView,for setting in SingleChildView,not ScrollView
  final bool? reverse;

  /// copy from ScrollView,for setting in SingleChildView,not ScrollView
  final ScrollController? scrollController;

  /// copy from ScrollView,for setting in SingleChildView,not ScrollView
  final bool? primary;

  /// copy from ScrollView,for setting in SingleChildView,not ScrollView
  final ScrollPhysics? physics;

  /// copy from ScrollView,for setting in SingleChildView,not ScrollView
  final double? cacheExtent;

  /// copy from ScrollView,for setting in SingleChildView,not ScrollView
  final int? semanticChildCount;

  /// copy from ScrollView,for setting in SingleChildView,not ScrollView
  final DragStartBehavior? dragStartBehavior;

  const PaginationScreen({
    super.key,
    required this.pagination,
    required this.future,
    required this.pageBuilder,
    required this.emptyWidget,
    required this.errorWidget,
    required this.loadingWidget,
    this.refreshController,
    this.searchController,
    this.cacheExtent,
    this.dragStartBehavior,
    this.enablePullUp = true,
    this.footer,
    this.header,
    this.onTwoLevel,
    this.physics,
    this.primary,
    this.reverse,
    this.scrollController,
    this.scrollDirection,
    this.semanticChildCount,
  });

  @override
  State<PaginationScreen<T>> createState() => _PaginationScreenState<T>();
}

class _PaginationScreenState<T> extends State<PaginationScreen<T>> {
  late RefreshController refreshController;
  late FutureSignal<List<T>> pageSignal;
  ValueNotifier<List<T>> paginatedHolder = ValueNotifier([]);
  late APagination pagination;
  bool loaded = false;
  // SEARCH
  Timer? _debounce;
  String _textTracker = '';
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    refreshController = widget.refreshController ?? RefreshController();
    pageSignal = FutureSignal(() => widget.future());
    pagination = widget.pagination;

    searchController = widget.searchController ?? TextEditingController();
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        _onSearchTextChanged(searchController.text);
      }
    });
    if (searchController.text.isNotEmpty) {
      _onSearchTextChanged(searchController.text, seconds: 0);
    }
  }

  void _onSearchTextChanged(String query, {int seconds = 1}) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    if (!mounted) return;
    _debounce = Timer(Duration(seconds: seconds), () {
      pagination.search = searchController.text;
      if (_textTracker != searchController.text) {
        refreshController.requestRefresh();
        _textTracker = searchController.text;
      }
    });
  }

  void onLoading() async {
    try {
      if (paginatedHolder.value.length == pagination.total) {
        refreshController.loadNoData();
      } else {
        var a = await widget.future.call();
        paginatedHolder.value = [...paginatedHolder.value, ...a];
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  void onRefresh() async {
    pagination.reset();
    try {
      var a = await widget.future.call();
      paginatedHolder.value = [...a];
      refreshController.refreshCompleted(resetFooterState: true);
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  @override
  void dispose() {
    (widget.refreshController ?? refreshController).dispose();
    (widget.searchController ?? searchController).dispose();
    pageSignal.dispose();
    paginatedHolder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pagedData = pageSignal.watch(context);
    return pagedData.map(
      data: (value) {
        if (!loaded) {
          loaded = true;
          paginatedHolder.value = value.toList();
        }
        return ValueListenableBuilder<List<T>>(
          valueListenable: paginatedHolder,
          builder: (context, data, _) {
            return SmartRefresher(
              controller: refreshController,
              enablePullUp: widget.enablePullUp,
              onLoading: onLoading,
              onRefresh: onRefresh,
              header: widget.header,
              footer: widget.footer,
              onTwoLevel: widget.onTwoLevel,
              dragStartBehavior: widget.dragStartBehavior,
              primary: widget.primary,
              cacheExtent: widget.cacheExtent,
              semanticChildCount: widget.semanticChildCount,
              reverse: widget.reverse,
              physics: widget.physics,
              scrollDirection: widget.scrollDirection,
              scrollController: widget.scrollController,
              child: (data.isEmpty)
                  ? widget.emptyWidget
                  : widget.pageBuilder(data),
            );
          },
        );
      },
      error: (error, trace) {
        return widget.errorWidget(
          error,
          trace,
          pageSignal,
        );
      },
      loading: () => Center(
        child: widget.loadingWidget,
      ),
      reloading: () => Center(
        child: widget.loadingWidget,
      ),
    );
  }
}
