#### A practical solution for building and managing the state of selectable lists.

| SelectableListAnchor |
| :---: |
| <img src="https://github.com/CHB61/flutter_selectable_list/blob/master/doc/anchor_example.gif?raw=true" width="800" alt="An example video of the SelectableListAnchor"></video> |


## Features
- <b>*SelectableList*</b>
  - Single or multi select
  - Search and pagination using provided callbacks
- <b>*SelectableListController*</b>
  - a `ChangeNotifier` to allow for easily manipulating the state of the `SelectableList` from anywhere
- <b>*SelectableListAnchor*</b> 
  - a FormField builder widget that opens the `SelectableList` in a modal widget (BottomSheet, Dialog, Overlay, or SideSheet)
  


## Usage

### SelectableList
A `CustomScrollView` that listens to a `SelectableListController`. Instantiated with a `single` or `multi` constructor that requires either a `List<T>` of `items` or a `controller` to be provided. If no `controller` is present, one will be created implicitly and passed to callback functions that might require it such as `onScrollThresholdReached`. By default, the items are shown as a list of vertically scrollable CheckboxListTiles.


#### <b>Load More Items</b>
The callback `onScrollThresholdReached` is invoked when the `scrollThreshold` (default `0.85`) is reached. Use this to fetch more items and use the `SelectableListController` to add them to the list.

### SelectableListController
A ChangeNotifier that maintains the list of items and its selected value. It contains properties to determine the loading and search states, and can also be used to open modal widgets when paired with a SelectableListAnchor.

Can be used as a listenable for custom widgets. For example: 
- to display the selected value of a SelectableList elsewhere in the UI
- custom header that contains a search or filter

### SelectableListAnchor
A builder widget used to open the SelectableList in a modal widget (BottomSheet, Dialog, Overlay, or SideSheet).

The anchor adds default header and actions widgets to the SelectableList. The default header displays a `headerTitle` with an optional search field that by default will perform a basic search on the `items` and update the SelectableList internally unless `onSearchTextChanged` is provided.

This widget is also a FormField, providing a `validator` that displays an error message below the `builder` widget of the anchor and can be replaced by passing in the `validatorBuilder`.

To allow for the value to be reset in the event of a cancel or barrier dismissal, the original value is stored in the SelectableListAnchor state each time the view is opened. `resetOnBarrierDismissed` can be used to override the default behavior.

```dart
SelectableListAnchor.multi(
  items: [],
  sideSheetProperties: const SideSheetProperties(
    direction: TextDirection.rtl,
  ),
  builder: (controller, formFieldState) {
    return TextButton(
      onPressed: () => controller.openSideSheet(),
      child: const Text('Open SideSheet'),
    );
  },
);
```

### <b>Search</b>
The `SelectableListController` contains properties to control the search state.
- `filteredItems` - If not null, will be displayed instead of `items`.
- `searchActive` - A boolean value to toggle whether the `searchViewBuilder` should be shown in place of the list view.
- `searchController` - A TextEditingController that is updated when calling `controller.setSearchValue`. Used by the default search field in the anchor and can also be used for a custom search field.

*Basic Search:*

If using `SelectableListAnchor`, the simplest way to search the contents of your list is to enable the default search header with `showDefaultHeader: true` and `showSearchField: true`. This provides a TextField that will filter the list as the user types.

*Async Search:*

If using `SelectableListAnchor`, override the default search function by passing `onSearchTextChanged` to perform an async search, or pass your own `header` widget that replaces the default search field entirely. Use the `SelectableListController` to update the `SelectableList` with search results or to indicate loading status.

*Search View:*

Use the `SelectableList.searchViewBuilder` to display a custom view (search history, suggestions, etc.) when the search state is activated. Toggle the view with the controller's `searchActive` property.


## Contributing
Pull requests are welcome. If you are interested in becoming a collaborator, please send an email.


