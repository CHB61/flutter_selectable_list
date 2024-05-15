import 'package:flutter/material.dart';
import 'selectable_list_anchor.dart';

enum ProgressIndicatorPosition {
  center,
  listItem,
}

class SelectableList<T> extends StatefulWidget {
  final Color? backgroundColor;

  final OutlinedBorder? checkboxShape;

  /// Where to place the control relative to the text on the [CheckboxListTile].
  final ListTileControlAffinity controlAffinity;

  final double? elevation;

  final List<T>? initialValueList;
  final T? initialValueSingle;

  final bool isThreeLine;

  /// Overrides the default [CheckboxListTile].
  final Widget Function(T item, int index)? itemBuilder;
  final List<T>? items;

  /// Callback function to get the title of each item. Not needed if `T` is of
  /// type `String`.
  // final Widget Function(T)? itemTitle;
  final String Function(T)? itemTitle;

  /// This value is used as a percentage (which ranges from 0.0 to 1.0) of the
  /// `maxScrollExtent` to determine when to call [onScrollThresholdReached]
  /// based on the current scroll position. The default value is `0.8`.
  // final double maxScrollThreshold;
  final double maxScrollThreshold;

  final bool multiselect;

  final void Function(List<T>, T, bool)? onMultiSelectionChanged;
  final void Function(T?)? onSingleSelectionChanged;

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

  final Widget Function(TextEditingController, Widget)? searchBuilder;

  const SelectableList.single({
    super.key,
    this.backgroundColor,
    this.checkboxShape,
    this.controlAffinity = ListTileControlAffinity.platform,
    SingleSelectController<T>? controller,
    this.elevation,
    T? initialValue,
    this.isThreeLine = false,
    this.itemBuilder,
    this.items,
    this.itemTitle,
    this.maxScrollThreshold = 0.85,
    this.onScrollThresholdReached,
    void Function(T?)? onSelectionChanged,
    this.progressIndicator,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
    this.searchBuilder,
    this.secondary,
    this.subtitle,
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
        assert(maxScrollThreshold >= 0 && maxScrollThreshold <= 1);

  const SelectableList.multi({
    super.key,
    this.backgroundColor,
    this.checkboxShape,
    this.controlAffinity = ListTileControlAffinity.platform,
    MultiSelectController<T>? controller,
    this.elevation,
    List<T>? initialValue,
    this.isThreeLine = false,
    this.itemBuilder,
    this.items,
    this.itemTitle,
    this.maxScrollThreshold = 0.85,
    this.onScrollThresholdReached,
    void Function(List<T>, T, bool)? onSelectionChanged,
    this.progressIndicator,
    this.scrollController,
    this.scrollDirection = Axis.vertical,
    this.searchBuilder,
    this.secondary,
    this.subtitle,
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
        assert(maxScrollThreshold >= 0 && maxScrollThreshold <= 1);

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
        // TODO: review this
        // account for the progress indicator being added to the list.
        if (currMaxScrollExtent - _maxScrollExtent > 200) {
          _maxScrollExtent = currMaxScrollExtent;
          _calledMaxExtent = false;
        }
      }

      double nextPageTrigger = widget.maxScrollThreshold * currMaxScrollExtent;
      double currentPosition = _scrollController.position.pixels;

      if (currentPosition > nextPageTrigger && !_calledMaxExtent) {
        widget.onScrollThresholdReached?.call();
        _calledMaxExtent = true;
      }
    });
  }

  Widget _buildListItem(T item, int index) {
    return Material(
      color: widget.backgroundColor,
      surfaceTintColor:
          widget.backgroundColor ?? Theme.of(context).colorScheme.surfaceTint,
      elevation: widget.elevation ?? 0,
      shadowColor: Colors.transparent,
      child: CheckboxListTile(
        checkboxShape: widget.checkboxShape,
        // tileColor: widget.backgroundColor,
        // checkColor: widget.checkColor,
        value: _controller.isItemChecked(item),
        // activeColor: widget.selectedColor
        // title: widget.itemTitle?.call(item) ?? Text(item.toString()),
        title: Text(widget.itemTitle?.call(item) ?? item.toString()),
        subtitle: widget.subtitle?.call(item),
        isThreeLine: widget.isThreeLine,
        secondary: widget.secondary?.call(item),
        controlAffinity: widget.controlAffinity,
        onChanged: (checked) {
          _controller.onValueChanged(item, checked ?? false);

          // if (widget.separateSelectedItems) {
          // setState(() {
          //   _items = widget.separateSelected(_items);
          // });
          // }
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
      color: widget.backgroundColor,
      surfaceTintColor:
          widget.backgroundColor ?? Theme.of(context).colorScheme.surfaceTint,
      elevation: widget.elevation ?? 0,
      shadowColor: Colors.transparent,
      child: Center(
        child: widget.progressIndicator ??
            Container(
              margin: const EdgeInsets.symmetric(vertical: 25),
              height: 24,
              width: 24,
              child: const CircularProgressIndicator(strokeWidth: 3),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          List items = [];
          Widget? searchView;
          Widget selectableListView;

          items = _controller.filteredItems ?? _controller.items;

          selectableListView = _SelectableListView(
            buildProgressIndicator: _buildProgressIndicator,
            controller: _controller,
            itemBuilder: widget.itemBuilder ?? _buildListItem,
            items: items,
            scrollController: _scrollController,
            scrollDirection: widget.scrollDirection,
          );

          if (_controller.searchActive) {
            searchView = widget.searchBuilder?.call(
              _controller.searchController,
              selectableListView,
            );
          }

          return searchView ?? selectableListView;
        });
  }
}

class _SelectableListView<T> extends StatelessWidget {
  final ScrollController scrollController;
  final Axis scrollDirection;
  final SelectableListController<T> controller;
  final List items;
  final Widget Function(T item, int index) itemBuilder;
  final Widget Function() buildProgressIndicator;

  const _SelectableListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    required this.items,
    required this.scrollController,
    this.scrollDirection = Axis.vertical,
    required this.buildProgressIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scrollbar(
          controller: scrollController,
          child: ListView.builder(
              scrollDirection: scrollDirection,
              controller: scrollController,
              shrinkWrap: true, // should this always be true?
              itemCount: controller.loading &&
                      controller.progressIndicatorPosition ==
                          ProgressIndicatorPosition.listItem
                  ? items.length + 1
                  : items.length,
              itemBuilder: (context, index) {
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
              }),
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
