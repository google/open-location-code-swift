# Open Location Code for Swift
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Convert between decimal degree coordinates and Open Location Codes. Shorten
and recover Open Location Codes for a given reference location.

This repository is the Swift implementation of Open Location Code.
It supports Swift and Objective-C projects on iOS, macOS, tvOS and
watchOS, and Swift projects on Linux. The
[master repository](https://github.com/google/open-location-code)
has Open Location Code support for many other languages.

## About Open Location Codes

[Open Location Codes](http://openlocationcode.com/) are short, 10-11 character
codes that can be used instead of street addresses. The codes can be generated
and decoded offline, and use a reduced character set that minimises the chance
of codes including words.

Codes are able to be shortened relative to a nearby location. This means
that in many cases, only four to seven characters of the code are needed.
To recover the original code, the same location is not required, as long as
a nearby location is provided.

Codes represent rectangular areas rather than points, and the longer the
code, the smaller the area. A 10 character code represents a 13.5x13.5
meter area (at the equator. An 11 character code represents approximately
a 2.8x3.5 meter area.

Two encoding algorithms are used. The first 10 characters are pairs of
characters, one for latitude and one for latitude, using base 20. Each pair
reduces the area of the code by a factor of 400. Only even code lengths are
sensible, since an odd-numbered length would have sides in a ratio of 20:1.
At position 11, the algorithm changes so that each character selects one
position from a 4x5 grid. This allows single-character refinements.

## Supported Environments

This library is provided as a Swift and Objective-C Cocoa Framework
for iOS, macOS, tvOS and watchOS, and as a pure Swift module
for macOS and Linux.

## Building

### Cocoa Framework

To build the Framework:
```bash
xcodebuild -project OpenLocationCode.xcodeproj -scheme OpenLocationCode_iOS -configuration Release
xcodebuild -project OpenLocationCode.xcodeproj -scheme OpenLocationCode_macOS -configuration Release
xcodebuild -project OpenLocationCode.xcodeproj -scheme OpenLocationCode_tvOS -configuration Release
xcodebuild -project OpenLocationCode.xcodeproj -scheme OpenLocationCode_watchOS -configuration Release
```

Or, if you have [Carthage](https://github.com/Carthage/Carthage) installed:
```bash
carthage build --no-skip-current
```

Testing the framework:
```bash
xcodebuild test -project OpenLocationCode.xcodeproj -scheme OpenLocationCode_macOS -destination 'platform=OS X,arch=x86_64'
```

### Swift Module

To build the pure Swift module:
```bash
swift build
```

Testing the pure Swift module:
```bash
swift test
```

A Dockerfile is included to build and run the pure Swift module in
a Linux container:
```bash
docker build .
```

## Swift Code Example

```swift
import OpenLocationCode

// Encode a location with default code length.
if let code = OpenLocationCode.encode(latitude: 37.421908,
                                      longitude: -122.084681) {
  print("Open Location Code: \(code)")
}

// Encode a location with specific code length.
if let code10Digit = OpenLocationCode.encode(latitude: 37.421908,
                                             longitude: -122.084681,
                                             codeLength: 10) {
  print("Open Location Code: \(code10Digit)")
}

// Decode a full code:
if let coord = OpenLocationCode.decode("849VCWC8+Q48") {
  print("Center is \(coord.latitudeCenter), \(coord.longitudeCenter)")
}

// Attempt to trim the first characters from a code:
if let shortCode = OpenLocationCode.shorten(code: "849VCWC8+Q48",
                                            latitude: 37.4,
                                            longitude: -122.0) {
  print("Short code: \(shortCode)")
}

// Recover the full code from a short code:
if let fullCode = OpenLocationCode.recoverNearest(shortcode: "CWC8+Q48",
                                                  referenceLatitude: 37.4,
                                                  referenceLongitude: -122.0) {
  print("Recovered full code: \(fullCode)")
}
```

## Objective-C Code Example

```objc
@import OpenLocationCode;

// ...

// Encode a location with default code length.
NSString *code = [OLCConverter encodeLatitude:37.421908
                                    longitude:-122.084681];
NSLog(@"Open Location Code: %@", code);

// Encode a location with specific code length.
NSString *code10Digit = [OLCConverter encodeLatitude:37.421908
                                           longitude:-122.084681
                                          codeLength:10];
NSLog(@"Open Location Code: %@", code10Digit);

// Decode a full code:
OLCArea *coord = [OLCConverter decode:@"849VCWC8+Q48"];
NSLog(@"Center is %.6f, %.6f", coord.latitudeCenter, coord.longitudeCenter);

// Attempt to trim the first characters from a code:
NSString *shortCode = [OLCConverter shortenCode:@"849VCWC8+Q48"
                                       latitude:37.4
                                      longitude:-122.0];
NSLog(@"Short Code: %@", shortCode);

// Recover the full code from a short code:
NSString *recoveredCode = [OLCConverter recoverNearestWithShortcode:@"CWC8+Q48"
                                                  referenceLatitude:37.4
                                                 referenceLongitude:-122.1];
NSLog(@"Recovered Full Code: %@", recoveredCode);
```
