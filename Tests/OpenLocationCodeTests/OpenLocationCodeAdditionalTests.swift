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
//  Tests various API claims and functionality not covered by the core tests.
//
//  Authored by William Denniss.
//
//===----------------------------------------------------------------------===//

import XCTest
import Foundation
@testable import OpenLocationCode

/// Tests various API claims and functionality not covered by the core tests.
class OpenLocationCodeAdditionalTests: XCTestCase {

  /// Tests that the documented possible code lengths behave as expected.
  func testEncodeLengthValidity() {
    // Even lengths between 2 and 10 inclusive are valid.
    for length in [2, 4, 6, 8, 10] {
      let code = OpenLocationCode.encode(latitude: 47.365590,
                                         longitude: 8.524997,
                                         codeLength: length)
      XCTAssertNotNil(code, "\(length)")
    }
    // All lengths above 10 are valid.
    for length in 11..<100 {
      let code = OpenLocationCode.encode(latitude: 47.365590,
                                         longitude: 8.524997,
                                         codeLength: length)
      XCTAssertNotNil(code, "\(length)")
    }
    // All lengths before 2, and odd numbers before 10 are invalid.
    for length in [-100, -3, -2, -1, 0, 1, 3, 5, 7, 9] {
      let code = OpenLocationCode.encode(latitude: 47.365590,
                                         longitude: 8.524997,
                                         codeLength: length)
      XCTAssertNil(code, "\(length)")
    }
  }

  /// Tests that the documented possible code lengths behave as expected.
  func testShortenLimit() {
    let shortcode = OpenLocationCode.shorten(code: "9C3W9QCJ+2VX",
                                             latitude: 51.3708675,
                                             longitude: -1.217765625,
                                             maximumTruncation: 6)
    XCTAssertEqual(shortcode, "CJ+2VX")
    let shortcode2 = OpenLocationCode.shorten(code: "9C3W9QCJ+2VX",
                                              latitude: 51.3708675,
                                              longitude: -1.217765625,
                                              maximumTruncation: 2)
    XCTAssertEqual(shortcode2, "3W9QCJ+2VX")
    let citycode = OpenLocationCode.shorten(code: "9C3W9QCJ+2VX",
                                            latitude: 51.3708675,
                                            longitude: -1.217765625)
    XCTAssertEqual(citycode, "9QCJ+2VX")
  }

  static var allTests = [
    ("testEncodeLengthValidity", testEncodeLengthValidity),
  ]
}
