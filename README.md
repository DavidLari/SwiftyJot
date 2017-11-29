# SwiftyJot

[![CI Status](http://img.shields.io/travis/DavidLari/SwiftyJot.svg?style=flat)](https://travis-ci.org/DavidLari/SwiftyJot)
[![Version](https://img.shields.io/cocoapods/v/SwiftyJot.svg?style=flat)](http://cocoapods.org/pods/SwiftyJot)
[![License](https://img.shields.io/cocoapods/l/SwiftyJot.svg?style=flat)](http://cocoapods.org/pods/SwiftyJot)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyJot.svg?style=flat)](http://cocoapods.org/pods/SwiftyJot)

## SwiftyJot

Give your images the finger with SwiftyJot! Lightweight library lets users mark up a photo/image.

- Options to allow user to select color using built-in palette.
- User can select brush size.
- Multi-level undo
- One level redo.
- Swift 4.
- Works on iPhone X.
- Supports iPhones and iPads.
- Uses safe zones on iOS 11+.
- No storyboards.

Inspired by the (now abandoned) [jot](https://github.com/IFTTT/jot) object-C library from IFTTT but all new code, 100% Swift.

Pull requests welcomed!

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Build and run. Tap an image then tap Annotate.

Royalty free example images from [Unsplash](https://unsplash.com)

## Requirements

Works on iOS 9.0 and later. Xcode 9.x and later. Swift 4.

## Installation

SwiftyJot is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyJot'
```

## Usage

Assumption: You have a view controller displayed and it has a UIImageView with an image on it.

First import SwiftyJot, then instantiate and present:

```
let swiftyJot = SwiftyJot()
swiftyJot.present(sourceImageView: imageView, presentingViewController: self)
```

After the user edits and taps Done, the marked up image will automatically replace your original in the image view.
The new image is the same resolution as the original.

To customize the appearance, create a configuration object and set properties:

```
let swiftyJot = SwiftyJot()
var config = SwiftyJot.Config()
config.backgroundColor = .gray
config.title = "Example"
config.tintColor = .darkGray
config.buttonBackgroundColor = .white
config.brushColor = .red
config.brushSize = 8.0
config.showMenuButton = true
config.showPaletteButton = true
swiftyJot.config = config

swiftyJot.present(sourceImageView: imageView, presentingViewController: self)
```

## Version

This is an early version of SwiftyJot. However, every effort will be made to avoid any compatibility breaking changes.

## Author

DavidLari, david@DavidLariStudios.com

## License

SwiftyJot is available under the MIT license. See the LICENSE file for more info.

