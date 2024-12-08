import 'package:flutter/material.dart';
import 'selectable_list_anchor.dart';

class SelectableList<T> extends StatefulWidget {
  const SelectableList.single({
    super.key,
    this.tileColor,
    this.checkboxShape,
    this.controlAffinity = ListTileControlAffinity.platform,
    SingleSelectController<T>? controller,
    this.dividerColor,
    this.elevation = 0.0,
    this.floatSelectedValue = false,
    this.foregroundColor,
    T? initialValue,
    this.isThreeLine = false,
    this.itemBuilder,
    this.itemExtent,
    this.items,
    this.itemTitle,
    this.scrollThreshold = 0.85,
    this.onScrollThresholdReached,
    void Function(T?)? onSelectionChanged,
    this.onSearchTextChanged,
    this.pinSelectedValue = false,
    this.progressIndicator,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
    this.searchViewBuilder,
    this.secondary,
    this.subtitle,
    this.surfaceTintColor,
  })  : initialValueList = null,
        initialValueSingle = initialValue,
        multiselect = false,
        multiSelectController = null,
        onMultiSelectionChanged = null,
        onSingleSelectionChanged = onSelectionChanged,
        singleSelectController = controller,
        assert(initialValue == null || controller == null),
        assert(items == null || controller == null),
        assert(items != null || controller != null),
        assert(scrollThreshold >= 0 && scrollThreshold <= 1);

  const SelectableList.multi({
    super.key,
    this.tileColor,
    this.checkboxShape,
    this.controlAffinity = ListTileControlAffinity.platform,
    MultiSelectController<T>? controller,
    this.dividerColor,
    this.elevation = 0.0,
    this.floatSelectedValue = false,
    this.foregroundColor,
    List<T>? initialValue,
    this.isThreeLine = false,
    this.itemBuilder,
    this.itemExtent,
    this.items,
    this.itemTitle,
    this.scrollThreshold = 0.85,
    this.onScrollThresholdReached,
    OnMultiSelectionChanged onSelectionChanged,
    this.onSearchTextChanged,
    this.pinSelectedValue = false,
    this.progressIndicator,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
    this.searchViewBuilder,
    this.secondary,
    this.subtitle,
    this.surfaceTintColor,
  })  : initialValueList = initialValue,
        initialValueSingle = null,
        multiselect = true,
        multiSelectController = controller,
        onMultiSelectionChanged = onSelectionChanged,
        onSingleSelectionChanged = null,
        singleSelectController = null,
        assert(initialValue == null || controller == null),
        assert(items == null || controller == null),
        assert(items != null || controller != null),
        assert(scrollThreshold >= 0 && scrollThreshold <= 1);

  final Color? tileColor;

  final OutlinedBorder? checkboxShape;

  /// Where to place the control relative to the text on the [CheckboxListTile].
  final ListTileControlAffinity controlAffinity;

  final Color? dividerColor;

  final double elevation;

  /// {@template selectable_list_float_selected}
  /// Pins the selected value to the top of the list. [itemExtent] is required
  /// to enable floating effect.
  ///
  /// If [itemExtent] is not provided and this value is `true`, the selected
  /// value will still be pinned but it cannot shrink while scrolling. In this
  /// case, consider using [pinSelectedValue] which will have the same result.
  /// {@endtemplate}
  final bool floatSelectedValue;

  final Color? foregroundColor;

  final List<T>? initialValueList;
  final T? initialValueSingle;

  final bool isThreeLine;

  /// {@template selectable_list_item_builder}
  /// Overrides the default [CheckboxListTile].
  /// {@endtemplate}
  final Widget Function(T item, int index)? itemBuilder;

  /// {@template selectable_list_item_extent}
  /// Providing the itemExtent will build a [SliverFixedExtentList] and is also
  /// required to enable [floatSelectedValue].
  /// {@endtemplate}
  final double? itemExtent;

  final List<T>? items;

  /// Callback function to get the title of each item. Not needed if `T` is of
  /// type `String`.
  // final Widget Function(T)? itemTitle;
  final String Function(T)? itemTitle;

  /// This value is used as a percentage (which ranges from 0.0 to 1.0) of the
  /// `maxScrollExtent` to determine when to call [onScrollThresholdReached]
  /// based on the current scroll position. The default value is `0.8`.
  final double scrollThreshold;

  final bool multiselect;

  final OnMultiSelectionChanged onMultiSelectionChanged;
  final void Function(T?)? onSingleSelectionChanged;

  final void Function(String)? onSearchTextChanged;

  final bool pinSelectedValue;

  /// Widget to be displayed when [SelectableListController.loading] is `true`.
  /// The position of this widget can be set using the [SelectableListController.progressIndicatorPosition].
  final Widget? progressIndicator;

  /// An enum that determines where the [progressIndicator] is displayed.
  ///
  /// [ProgressIndicatorPosition.center] will render the widget above the list
  /// items in a [Stack], and [ProgressIndicatorPosition.listItem] will render
  /// the widget where the next list item would appear.
  // final ProgressIndicatorPosition progressIndicatorPosition;

  final SingleSelectController<T>? singleSelectController;
  final MultiSelectController<T>? multiSelectController;

  /// Creates a listener on the [scrollController] that calls this function
  /// when the [maxScrollThreshold] is reached. It will only be called once
  /// unless the `maxScrollExtent` changes.
  final Function? onScrollThresholdReached;

  final ScrollController? scrollController;
  final Axis scrollDirection;
  final Widget Function(T)? secondary;

  final Widget Function(T)? subtitle;

  final Widget Function(TextEditingController, Widget)? searchViewBuilder;

  /// Not recommended for use. See [Dialog.surfaceTintColor].
  final Color? surfaceTintColor;

  @override
  State<SelectableList<T>> createState() => _SelectableListState<T>();
}

class _SelectableListState<T> extends State<SelectableList<T>> {
  late SelectableListController<T> _controller;
  late ScrollController _scrollController;
  double _maxScrollExtent = 0;
  bool _calledMaxExtent = false;

  @override
  void initState() {
    super.initState();

    widget.multiselect
        ? _controller = widget.multiSelectController ??
            MultiSelectController(
              initialValue: widget.initialValueList,
              items: widget.items,
            )
        : _controller = widget.singleSelectController ??
            SingleSelectController(
              initialValue: widget.initialValueSingle,
              items: widget.items,
            );

    // //-------------
    // Map<String, SelectableListItem> itemsMap = {};
    // for (T item in _controller.items) {
    //   String label = widget.itemTitle?.call(item) ?? item.toString();
    //   itemsMap[label] = SelectableListItem(item, label);
    // }
    // //-------------

    _scrollController = widget.scrollController ?? ScrollController();

    if (widget.onScrollThresholdReached != null) {
      _addMaxExtentListener();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _addMaxExtentListener() {
    _scrollController.addListener(() {
      double currMaxScrollExtent = _scrollController.position.maxScrollExtent;

      if (_maxScrollExtent != currMaxScrollExtent) {
        // review this
        // account for the progress indicator being added to the list.
        if (currMaxScrollExtent - _maxScrollExtent > 200) {
          _maxScrollExtent = currMaxScrollExtent;
          _calledMaxExtent = false;
        }
      }

      double nextPageTrigger = widget.scrollThreshold * currMaxScrollExtent;
      double currentPosition = _scrollController.position.pixels;

      if (currentPosition > nextPageTrigger && !_calledMaxExtent) {
        widget.onScrollThresholdReached?.call();
        _calledMaxExtent = true;
      }
    });
  }

  Widget _buildListItem(T item, int index) {
    return Material(
      color: widget.tileColor,
      elevation: widget.elevation,
      shadowColor: Colors.transparent,
      surfaceTintColor: widget.surfaceTintColor ?? Colors.transparent,
      child: CheckboxListTile(
        side: BorderSide(
          width: 2,
          color:
              widget.foregroundColor ?? Theme.of(context).colorScheme.onSurface,
        ),
        checkboxShape: widget.checkboxShape,
        selected: _controller.isItemChecked(item),
        selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.4),
        // tileColor: widget.backgroundColor,
        // checkColor: widget.checkColor,
        value: _controller.isItemChecked(item),
        // activeColor: widget.selectedColor
        // title: widget.itemTitle?.call(item) ?? Text(item.toString()),
        title: Text(
          widget.itemTitle?.call(item) ?? item.toString(),
          style: TextStyle(
            color: widget.foregroundColor,
          ),
        ),
        subtitle: widget.subtitle?.call(item),
        isThreeLine: widget.isThreeLine,
        secondary: widget.secondary?.call(item),
        controlAffinity: widget.controlAffinity,
        onChanged: (checked) {
          _controller.onValueChanged(item, checked ?? false);

          if (widget.multiselect) {
            widget.onMultiSelectionChanged?.call(
              _controller.value,
              item,
              checked ?? false,
            );
          } else {
            widget.onSingleSelectionChanged?.call(_controller.value);
          }
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    if (!_controller.loading) return Container();

    return Material(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Center(
        child: widget.progressIndicator ??
            Container(
              margin: const EdgeInsets.symmetric(vertical: 25),
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: widget.foregroundColor,
              ),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          List<T> items = [];
          Widget? searchView;
          Widget selectableListView;

          // update the _maxScrollExtent in case the list size changed
          if (_scrollController.hasClients) {
            _maxScrollExtent = _scrollController.position.maxScrollExtent;
          }

          items = _controller.filteredItems ?? _controller.items;

          selectableListView = _SelectableListView<T>(
            buildProgressIndicator: _buildProgressIndicator,
            controller: _controller,
            floatSelectedValue: widget.floatSelectedValue,
            itemBuilder: widget.itemBuilder ?? _buildListItem,
            itemExtent: widget.itemExtent,
            items: items,
            pinSelectedValue: widget.pinSelectedValue,
            scrollController: _scrollController,
            scrollDirection: widget.scrollDirection,
          );

          if (_controller.searchActive) {
            searchView = widget.searchViewBuilder?.call(
              _controller.searchController,
              selectableListView,
            );
          }

          return searchView ?? selectableListView;
        });
  }
}

class _SelectableListView<T> extends StatelessWidget {
  final Widget Function() buildProgressIndicator;
  final SelectableListController controller;
  final bool floatSelectedValue;
  final Widget Function(T item, int index) itemBuilder;
  final double? itemExtent;
  final List<T> items;
  final bool pinSelectedValue;
  final ScrollController scrollController;
  final Axis scrollDirection;

  const _SelectableListView({
    super.key,
    required this.buildProgressIndicator,
    required this.controller,
    this.floatSelectedValue = false,
    required this.itemBuilder,
    this.itemExtent,
    required this.items,
    this.pinSelectedValue = false,
    required this.scrollController,
    this.scrollDirection = Axis.vertical,
  });

  Widget _itemBuilder(BuildContext context, int index) {
    if (index == items.length) {
      if (controller.loading &&
          controller.progressIndicatorPosition ==
              ProgressIndicatorPosition.listItem) {
        return buildProgressIndicator();
      }
      return Container();
    } else {
      T item = items[index];
      return itemBuilder(item, index);
    }
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = controller.loading &&
            controller.progressIndicatorPosition ==
                ProgressIndicatorPosition.listItem
        ? items.length + 1
        : items.length;

    List<T> selectedItems = [];
    if (pinSelectedValue || floatSelectedValue) {
      if (controller is SingleSelectController) {
        if (controller.value != null) {
          selectedItems = [controller.value as T];
        }
      } else {
        selectedItems = controller.value as List<T>;
      }

      // itemExtent present - using SliverFixedExtentList. Remove the selected
      // items from the list since they cannot simply be hidden in this case.

      // if (itemExtent != null) {
      itemCount -= selectedItems.length;

      for (T val in selectedItems) {
        items.removeWhere((e) {
          return e == val;
        });
      }
      // }
    }

    return Stack(
      children: [
        CustomScrollView(
          controller: scrollController,
          scrollDirection: scrollDirection,
          slivers: [
            if ((pinSelectedValue || floatSelectedValue) &&
                selectedItems.isNotEmpty)
              itemExtent != null
                  ? SliverPersistentHeader(
                      delegate: _SelectedItemsHeaderDelegate(
                        floating: floatSelectedValue,
                        height: itemExtent!,
                        items: selectedItems,
                        itemBuilder: itemBuilder,
                      ),
                      floating: floatSelectedValue,
                      pinned: pinSelectedValue,
                    )
                  : PinnedHeaderSliver(
                      child: ListView(
                        shrinkWrap: true,
                        children: selectedItems
                            .map((e) => itemBuilder(e, 0))
                            .toList(),
                      ),
                    ),
            itemExtent != null
                ? SliverFixedExtentList.builder(
                    itemBuilder: _itemBuilder,
                    itemExtent: itemExtent!,
                    itemCount: itemCount,
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      _itemBuilder,
                      childCount: itemCount,
                    ),
                  ),
          ],
        ),
        controller.loading &&
                controller.progressIndicatorPosition ==
                    ProgressIndicatorPosition.center
            ? buildProgressIndicator()
            : Container(),
      ],
    );
  }
}

enum ProgressIndicatorPosition {
  center,
  listItem,
}

typedef OnMultiSelectionChanged<T> = void Function(
    List<T> value, T item, bool selected)?;

class SelectableListItem<T> {
  final T value;
  final String label;
  bool selected = false;

  SelectableListItem(this.value, this.label);
}

class _SelectedItemsHeaderDelegate<T> extends SliverPersistentHeaderDelegate {
  bool floating;
  final double height;
  final Widget Function(T, int) itemBuilder;
  final List<T> items;

  _SelectedItemsHeaderDelegate({
    this.floating = false,
    this.height = 48.0,
    required this.itemBuilder,
    required this.items,
  });

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: items.map((e) => itemBuilder(e, 0)).toList(),
      ),
    );
  }

  @override
  double get maxExtent => height * items.length;

  // The list should only shrink if floating is true. If it is false, the
  // minExtent is set to be the same as maxExtent so that it cannot change.
  @override
  double get minExtent => floating ? height : height * items.length;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
