//===-- OpenLocationCodeTests.swift - Tests for OpenLocationCode.swift ----===//
//
//  Copyright 2017 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//===----------------------------------------------------------------------===//
//
//  Tests that verify the included Swift library samples function correctly.
//
//  Authored by William Denniss.
//
//===----------------------------------------------------------------------===//

import XCTest
import Foundation
@testable import OpenLocationCode

class OpenLocationCodeSwiftExampleTests: XCTestCase {

  // Just runs the examples verbatium.
  func runExamples() {

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
  }

  /// Tests the Swift library README examples.
  func testExamples() {
    // Encode a location with default code length.
    let code = OpenLocationCode.encode(latitude: 37.421908,
                                       longitude: -122.084681)
    if let code = code {
      print("Open Location Code: \(code)")
    }

    // Encode a location with specific code length.
    let code10Digit = OpenLocationCode.encode(latitude: 37.421908,
                                              longitude: -122.084681,
                                              codeLength: 10)
    if let code10Digit = code10Digit {
      print("Open Location Code: \(code10Digit)")
    }

    // Decode a full code:
    let coord = OpenLocationCode.decode("849VCWC8+Q48")
    if let coord = coord {
      print("Center is \(coord.latitudeCenter), \(coord.longitudeCenter)")
    }

    // Attempt to trim the first characters from a code:
    let shortCode = OpenLocationCode.shorten(code: "849VCWC8+Q48",
                                             latitude: 37.4,
                                             longitude: -122.0)
    if let shortCode = shortCode {
      print("Short code: \(shortCode)")
    }

    // Recover the full code from a short code:
    let fullCode = OpenLocationCode.recoverNearest(shortcode: "CWC8+Q48",
                                                   referenceLatitude: 37.4,
                                                   referenceLongitude: -122.0)
    if let fullCode = fullCode {
      print("Recovered full code: \(fullCode)")
    }

    XCTAssertNotNil(code)
    XCTAssertNotNil(code10Digit)
    XCTAssertNotNil(coord)
    XCTAssertNotNil(shortCode)
    XCTAssertNotNil(fullCode)
  }

  static var allTests = [
    ("testExamples", testExamples),
  ]
}
