library page_abler;
/// 对应分页器的ViewModel引入的
mixin PageAbleViewModelMixin {
  List list = [];

  int get currentPage {
    return (list.length ~/ pageSize);
  }

  int get pageSize;

  /// 加载数据(需实现)
  Future<List> loadData(int currentPage, int pageSize);

  /// 刷新数据接口
  Future freshData() async {
    final value = await loadData(0, pageSize);

    list = value;
  }

  /// 加载更多数据接口
  Future loadMoreData() async {
    final value = await loadData(currentPage, pageSize);
    final Set compareSet = Set.from(list);

    value.forEach((item) {
      if (compareSet.contains(item)) return;
      list.add(item);
    });
  }
}
