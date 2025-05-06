## 0.0.12

- Added `width` and `minWidth` to `openOverlay` function.

## 0.0.11

- Added `openOverlay` as a function to SelectableListController. Removed `openDropdown`.

## 0.0.10

- Added `shrinkWrap` parameter.

## 0.0.9

- Fixed anchor dropdown not applying shape.
- Fixed null always being returned from onBarrierDismissed.

## 0.0.8

- SelectableListAnchor
	- Added section below the builder widget to display error text.

## 0.0.7

- Changes to pass pub static analysis.

## 0.0.6

- SelectableList now uses a CustomScrollView
- Added `pinSelectedValue` and `floatSelectedValue` params for SelectableList
- Removed all of the "select" widgets (SelectableListDialog, SelectableListDropdown, SelectableListSidesheet, SelectableListBottomsheet) in favor of using the SelectableListAnchor to open each type. If not using anchor, can simply create a container for the SelectableList.
- SelectableList
	- changed elevation to be non-nullable with default value of 0.0
	- changed surfaceTintColor to have a default value of null
	- changed name of maxScrollThreshold to scrollThreshold

## 0.0.5

- Pass shape parameter from SelectableListAnchor to showModalDropdown.

## 0.0.4

- Added `shape` parameter for `showModalDropdown` function.

## 0.0.3

- Renamed `searchBuilder` to `searchViewBuilder`
- Fixed bug when confirming an empty selection
- Added missing dropdown parameters in SelectableListAnchor
- Changes to dropdown
	- Doesn't reset values when dismissed by tapping on barrier
	- Now supports showing the default header if `showDefaultHeader` is true

## 0.0.2

- Removed hard-coded fillColor from default search TextField
- Added exports
- Changed prefix of `ListSelect` widgets to `SelectableList`.

## 0.0.1

- Initial release
