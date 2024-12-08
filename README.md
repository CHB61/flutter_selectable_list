# Flutter Selectable List

#### A practical solution to streamline building and managing the state of selectable lists.

| SelectableList | SelectableListAnchor |
| :---: | :---: |
| <sub><b>SelectableListAnchor</b></sub> | <sub><b>SelectableListAnchor</b></sub> |


## Features
- <b>*SelectableList*</b> - a customizable ListView
  - Single and multi select constructors
  - Supports search and pagination with async callbacks
- <b>*SelectableListController*</b> - a `ChangeNotifier` that controls the `SelectableList`.
  - Easily maintain the list of selected items from anywhere
- <b>*SelectableListAnchor*</b> - a FormField builder widget that opens the `SelectableList` in a modal widget
  - Choose to open either a BottomSheet, Dialog, Dropdown, or SideSheet
  - Coming soon: choose to open modal or persistent (overlay)


## Usage

### SelectableList
A `CustomScrollView` that listens to a `SelectableListController`. Instantiated with either a `single` or `multi` constructor. By default, the items are shown as a list of vertically scrollable CheckboxListTiles.

#### <b>Search</b>
*Basic Search:*

The simplest way to search the contents of your list is to enable the default search header with `showDefaultHeader: true` and `showSearchField: true`. This provides a TextField that will filter the list as the user types.

*Async Search:*

You can override the default search function by passing `onSearchTextChanged`, or pass your own `header` widget. Use the `SelectableListController` to update the list with new items or to indicate loading status.


*Search View:*

Use the `searchViewBuilder` to display a custom view in place of the SelectableList. The controller has properties that lets you control when to show the search view.

#### <b>Load More Items</b>
Use the callback `onScrollThresholdReached` to fetch more items and use the controller to add them.

### SelectableListController
A ChangeNotifier that maintains the list of items and its selected value. It contains properties to determine the loading and search states, and can also be used to open widgets when paired with a SelectableListAnchor.

### SelectableListAnchor
A builder widget used to open the SelectableList. Properties specific to a certain widget can be specified with the respective parameter. For example, if the anchor is opening a SideSheet, the parameter `sideSheetProperties` can be provided.

This widget is also a FormField.

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


