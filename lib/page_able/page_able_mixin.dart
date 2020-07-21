import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'page_able_view_model_mixin.dart';

extension PageAbleExtension on Widget {
  Widget intoPageAbler(PageAbleMixin pageAbleMixin) {
    return pageAbleMixin.pageAbler(this);
  }
}

/// 刷新数据UIMixin
/// 若需要使用分页，则需引入PageAblerMixin（引用者必须为State的子类）
mixin PageAbleMixin<T extends StatefulWidget> on State<T> {
  RefreshController refreshController = RefreshController(initialRefresh: true);

  PageAbleViewModelMixin get viewModel;

  /// 刷新数据接口
  Future freshData() => viewModel.freshData();

  /// 加载更多数据接口
  Future loadMoreData() => viewModel.loadMoreData();

  Future _request(bool isRefresh) async {
    try {
      if (isRefresh) {
        await freshData();
        refreshController.refreshCompleted();
      } else {
        await loadMoreData();
        refreshController.loadComplete();
      }
    } on Error catch (error) {
      onDataError(error);
      refreshController.refreshFailed();
    } finally {
      setState(() {});
    }
  }

  void onDataError(Error error) {}

  void _onRefresh() async => await _request(true);

  void _onLoading() async => await _request(false);

  Widget pageAbler(
    Widget child, {
    bool enablePullDown = true,
    bool enablePullUp = true,
  }) {
    return SmartRefresher(
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      header: CustomHeader(
        builder: (BuildContext context, RefreshStatus mode) {
          Widget body;

          switch (mode) {
            case RefreshStatus.idle:
              body = Text("下拉刷新", style: TextStyle(color: Colors.grey));
              break;
            case RefreshStatus.canRefresh:
              body = Row(
                children: <Widget>[
                  Text("准备刷新 ", style: TextStyle(color: Colors.grey)),
                  CupertinoActivityIndicator()
                ],
                mainAxisSize: MainAxisSize.min,
              );
              break;
            case RefreshStatus.refreshing:
              body = Row(
                children: <Widget>[
                  Text("数据刷新中 ", style: TextStyle(color: Colors.grey)),
                  CupertinoActivityIndicator()
                ],
                mainAxisSize: MainAxisSize.min,
              );
              break;
            case RefreshStatus.completed:
              body = Text("刷新成功", style: TextStyle(color: Colors.grey));
              break;
            case RefreshStatus.failed:
              body = Text("刷新失败", style: TextStyle(color: Colors.grey));
              break;
            case RefreshStatus.canTwoLevel:
              break;
            case RefreshStatus.twoLevelOpening:
              break;
            case RefreshStatus.twoLeveling:
              break;
            case RefreshStatus.twoLevelClosing:
              break;
          }

          return Container(
            height: 55,
            child: Center(
              child: body,
            ),
          );
        },
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          switch (mode) {
            case LoadStatus.idle:
              body = Text("上拉加载更多", style: TextStyle(color: Colors.grey));
              break;
            case LoadStatus.canLoading:
              body = Row(
                children: <Widget>[
                  Text("准备加载更多", style: TextStyle(color: Colors.grey)),
                  CupertinoActivityIndicator()
                ],
                mainAxisSize: MainAxisSize.min,
              );
              break;
            case LoadStatus.loading:
              body = Row(
                children: <Widget>[
                  Text("数据加载中", style: TextStyle(color: Colors.grey)),
                  CupertinoActivityIndicator()
                ],
                mainAxisSize: MainAxisSize.min,
              );
              break;
            case LoadStatus.noMore:
              body = Text("没有更多数据", style: TextStyle(color: Colors.grey));
              break;
            case LoadStatus.failed:
              body = Text("数据加载失败，点击重试", style: TextStyle(color: Colors.grey));
              break;
          }

          return Container(
            height: 55,
            child: Center(
              child: body,
            ),
          );
        },
      ),
      controller: refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: child,
    );
  }
}
