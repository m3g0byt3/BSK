# BSK
(acronym for "contactless multi-tickets" in Russian)

[![CI Status](https://img.shields.io/travis/m3g0byt3/BSK.svg?style=flat)](https://travis-ci.org/m3g0byt3/DSDMenu)
[![Version](https://img.shields.io/cocoapods/v/BSK.svg?style=flat)](https://cocoapods.org/pods/DSDMenu)
[![License](https://img.shields.io/cocoapods/l/BSK.svg?style=flat)](https://cocoapods.org/pods/DSDMenu)
[![Platform](https://img.shields.io/cocoapods/p/BSK.svg?style=flat)](https://cocoapods.org/pods/DSDMenu)
[![iOS](https://img.shields.io/badge/iOS-9.3-blue.svg?style=flat)](https://cocoapods.org/pods/DSDMenu)
[![GitHub issues](https://img.shields.io/github/issues/m3g0byt3/BSK.svg?style=flat)](https://github.com/m3g0byt3/DSDMenu)


Simple non-official framework for top-up russian contactless metropolitan multi-tickets "Podorozhnik" and "Sputnik".
Using [Moya] & [Alamofire] for networking, [Quick] & [Nimble] for unit-testing.
 

### Features
***
Top-up following types of metropolitan transport cards:
- [x] "Podorozhnik" multi-tickets with 19-digit number length
- [x] "Podorozhnik" multi-tickets with 26-digit number length
- [ ] "Sputnik" multi-tickets with 11-digit number length

Using following payment methods for top-up:
- [x] Credit or debit cards
- [ ] Cellphone balance
- [ ] Yandex Money
- [ ] Qiwi Wallet
- [ ] Apple Pay


### Requirements
***
* iOS 9.3+
* Xcode 9.4+
* Swift 4.0+


###  Project Status
***
Actively under development.


###  TODO
***
* Add usage guide
* Add sample projects


###  Installation
***

BSK is available via [CocoaPods](https://cocoapods.org).

[CocoaPods](https://cocoapods.org) is a dependency manager for Swift and Objective-C Cocoa projects. You can install it with the following command:

```bash
$ sudo gem install cocoapods
```

To integrate BSK, simply add the following line to your `Podfile`:

```ruby
pod 'BSK'
```

Then, run the following command:

```bash
pod install
```


###  Usage
***

TBD


###  Sample Project
***

TBD


###  Contributing
***
1. Fork
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

That's it!


###  License
***
BSK is released under an MIT license. See [LICENSE] for more information.


###  Author
***
[m3g0byt3]

[//]: #
[m3g0byt3]: <https://github.com/m3g0byt3>
[Moya]: <https://github.com/Moya>
[Alamofire]: <https://github.com/Alamofire/Alamofire>
[Quick]: <https://github.com/Quick/Quick>
[Nimble]: <https://github.com/Quick/Nimble>
[LICENSE]: <https://github.com/m3g0byt3/BSK/blob/master/LICENSE.txt>
[ispp.spbmetropoliten.ru]: <http://ispp.spbmetropoliten.ru>
