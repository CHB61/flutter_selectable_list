# Flutter Selectable List

A widget library that provides an intuitive solution to build and manage selectable lists.

| Placeholder<br /><sub><b>SelectableListAnchor</b></sub> | 
| :---: |

## Features
- Supports single or multi select
- Modal widgets (BottomSheet, Dialog, Dropdown, SideSheet) that contain a SelectableList
- SelectableListAnchor - build an anchor widget, open any type of modal widget
- Easily maintain the list of selected items from anywhere with a SelectableListController

## Usage

### SelectableList
A customizable ListView that listens to a SelectableListController. Instantiated with either a `single` or `multi` constructor. By default, the items are shown as a list of CheckboxListTiles.

### SelectableListController
A ChangeNotifier that maintains the list of items and its selected value. It contains properties to determine the loading and search states, and can also be used to open modal widgets when paired with a SelectableListAnchor.

### Modal Widgets
- ListSelectBottomSheet
- ListSelectDialog
- ListSelectDropdown
- ListSelectSideSheet

All modal widgets contain a SelectableList. They provide default header and actions widgets.

```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder: (context) {
    return ListSelectBottomSheet.multi(
      controller: _controller,
      itemTitle: (e) => e.name,
    );
  },
);
```

Top-level functions `showModalDropdown` and `showModalSideSheet` are included as part of the package. These can be used for general purposes.

### SelectableListAnchor
A builder widget that can be used to open any of the modal widgets. Any properties specific to a certain modal widget can be specified with the respective parameter. For example, if the anchor is opening a SideSheet, the parameter `sideSheetProperties` can be provided.

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

## Contributing
Pull requests are welcome. If you are interested in becoming a ${\color{lightgreen}collaborator}$, please send an email.


