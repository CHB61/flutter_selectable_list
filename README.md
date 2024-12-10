#### A practical solution to streamline building and managing the state of selectable lists.

| SelectableListAnchor |
| :---: |
| <img src="https://github.com/CHB61/flutter_selectable_list/blob/master/doc/anchor_example.gif?raw=true" width="800" alt="An example video of the SelectableListAnchor"></video> |


## Features
- <b>*SelectableList*</b>
  - Single or multi select constructors
  - Search and pagination using provided callbacks
- <b>*SelectableListController*</b>
  - a `ChangeNotifier` to allow for easily manipulating the state of the `SelectableList` from anywhere
- <b>*SelectableListAnchor*</b> 
  - a FormField builder widget that opens the `SelectableList` in a modal widget (BottomSheet, Dialog, Dropdown, or SideSheet)


## Usage

### SelectableList
A `CustomScrollView` that listens to a `SelectableListController`. Instantiated with either a `single` or `multi` constructor. By default, the items are shown as a list of vertically scrollable CheckboxListTiles.

If the list of `filteredItems` in the `SelectableListController` is <b>not null</b>, it will be shown instead.

#### <b>Search</b>
*Basic Search:*

The simplest way to search the contents of your list is to enable the default search header with `showDefaultHeader: true` and `showSearchField: true`. This provides a TextField that will filter the list as the user types.

*Async Search:*

You can override the default search function by passing `onSearchTextChanged`, or pass your own `header` widget. Use the `SelectableListController` to update the list with new items or to indicate loading status.


*Search View:*

Use the `searchViewBuilder` to display a custom view in place of the SelectableList. The controller has properties that lets you control when to show the search view.

#### <b>Load More Items</b>
The callback `onScrollThresholdReached` is invoked when the `scrollThreshold` (default `0.85`) is reached. Use this to fetch more items and use the `SelectableListController` to add them to the list.

### SelectableListController
A ChangeNotifier that maintains the list of items and its selected value. It contains properties to determine the loading and search states, and can also be used to open modal widgets when paired with a SelectableListAnchor.

Can be used as a listenable for custom widgets. For example: 
- to display the selected value of a SelectableList elsewhere in the UI
- custom header that contains a search or filter

### SelectableListAnchor
A builder widget used to open the SelectableList in a modal widget (BottomSheet, Dialog, Dropdown, or SideSheet).

This widget is also a FormField, providing validation and other standard FormField features. The error text displayed below the `builder` widget of the anchor can be replaced by passing in the `validatorBuilder`.

To allow for the value to be reset in the event of a cancel or barrier dismissal, the original value is stored in the SelectableListAnchor state each time the view is opened. `resetOnBarrierDismissed` can be used to override the default behavior. Modal widgets do not all have the same default behavior - the dropdown doesn't show the default header or actions unless specified, and it is assumed the barrier dismiss shouldn't be considered a 'cancel' action and reset the value.

Properties specific to a certain modal widget can be specified with the respective parameter. For example, if the anchor is opening a SideSheet, the parameter `sideSheetProperties` can be provided.

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

Top-level functions `showModalDropdown` and `showModalSideSheet` are included as part of the package. These can be used for general purposes.

## Contributing
Pull requests are welcome. If you are interested in becoming a collaborator, please send an email.


