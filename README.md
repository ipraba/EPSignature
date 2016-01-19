<p align="center" >
  <img src="Screenshots/logo.png" alt="EPSignature" title="EPSignature" width="196">
</p>

# EPSignature

Signature component for iOS written in Swift

[![Swift 2.0](https://img.shields.io/badge/Swift-2.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![CI Status](https://travis-ci.org/ipraba/EPSignature.svg?branch=master)](https://travis-ci.org/ipraba/EPSignature)
[![Version](https://img.shields.io/cocoapods/v/EPSignature.svg?style=flat)](http://cocoapods.org/pods/EPSignature)
[![License](https://img.shields.io/cocoapods/l/EPSignature.svg?style=flat)](https://github.com/ipraba/EPSignature/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/EPSignature.svg?style=flat)](http://cocoapods.org/pods/EPSignature)

### Preview
![Screenshot](https://raw.githubusercontent.com/ipraba/EPSignature/master/Screenshots/iPhone.png)    ![Screenshot](https://raw.githubusercontent.com/ipraba/EPSignature/master/Screenshots/iPad.png)


### Installation

EPSignature is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "EPSignature"
```
#### Manual Installation

Just drag and drop the files in `Pod/Classes` folder into your project

### Features

1. User can draw the signature either by finger or by apple pencil
2. Ability to save the signature as default signature. Which can be retrieved later
3. Ability to load the saved signature
4. Works on both orientations(portrait and landscape)
5. Works on both iPhone and iPad devices
6. Also can be embedded in any container view
7. Can extract the signature as Image
8. Draws smoothly

### Initialization of EPSignatureViewController

    let signatureVC = EPSignatureViewController(signatureDelegate: self, showsDate: true, showsSaveSignatureOption: true)
    signatureVC.subtitleText = "I agree to the terms and conditions"
    signatureVC.title = "John Doe"
    let nav = UINavigationController(rootViewController: signatureVC)
    presentViewController(nav, animated: true, completion: nil)

Note: You can also embed the signature view in any one of the container using the EPSignatureView

### Properties of EPSignatureViewController

Properties | Description
---- | ---------
**`showsDate`**|`Bool value that allows to show the date while signing`
**`showsSaveSignatureOption`**|`Bool value that allows the user to save the signature for future use`
**`signatureDelegate`**|`Delegate listing for events`
**`subtitleText`**|`Subtitle text for signature(Eg: Sign here)`
**`tintColor`**|`Tint color for the view controller. Applies for barbuttons, switches and actionsheet`

### Properties of EPSignatureView

Properties | Description
---- | ---------
**`strokeColor`**|`Stroke color of the signature`
**`strokeWidth`**|`Stroke width of the signature`
**`isSigned`**|`Bool value checks whether the user has signed or not`

### EPSignatureViewController Delegates

     func epSignature(_: EPSignature.EPSignatureViewController, didCancel error: NSError)
     func epSignature(_: EPSignature.EPSignatureViewController, didSigned signatureImage: UIImage, boundingRect: CGRect)

### License

EPSignature is available under the MIT license. See the [LICENSE](https://github.com/ipraba/EPSignature/blob/master/LICENSE) file for more info.

### Author

[@ipraba](https://github.com/ipraba)
