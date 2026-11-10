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

  /// Tests the encoding behavior of codes exceeding the maximum
  /// number of digits. Codes are limited to 15 significant digits.
  func testMaxLength_Encoding() {
    for length in [15, 16, 17, 100000] {
      let code = OpenLocationCode.encode(latitude: 37.539669125,
                                         longitude: -122.375069125,
                                         codeLength: length)!
      XCTAssertEqual(code, "849VGJQF+VX7QR4M")
    }
  }

  /// Tests the decoding behavior of codes exceeding the maximum
  /// number of digits. Significant digits after 15 are ignored.
  func testMaxLength_Decoding() {
    // Codes of 15 digits (not including plus) and higher should be equal
    let maxCharCode = "849VGJQF+VX7QR4M"
    let coord1 = OpenLocationCode.decode(maxCharCode)!
    let coord2 = OpenLocationCode.decode(maxCharCode + "7QR4M")!
    XCTAssertEqual(coord1.latitudeCenter, coord2.latitudeCenter)
    XCTAssertEqual(coord1.longitudeCenter, coord2.longitudeCenter)
  }

  /// Tests the validity checking behavior of codes exceeding the maximum
  /// number of digits. Codes exceeding the maximum length but with only
  /// valid characters are still valid, those with invalid characters after
  /// the maximum length are invalid.
  func testMaxLength_Validity() {
    let maxCharCode = "849VGJQF+VX7QR4M" // a 15 digit code
    // Codes with valid characters after the max are still valid
    let maxCharCodeExceededValid = maxCharCode + "W"
    XCTAssertTrue(OpenLocationCode.isValid(code: maxCharCodeExceededValid));
    // Codes with invalid characters after the max are invalid
    let maxCharCodeExceededInvalid = maxCharCode + "U"
    XCTAssertFalse(OpenLocationCode.isValid(code: maxCharCodeExceededInvalid));
  }

  /// Tests longitude normalization across standard, boundary, huge finite, and
  /// non-finite values.
  func testNormalizeLongitude() {
    XCTAssertEqual(OpenLocationCode.normalizeLongitude(0), 0)
    XCTAssertEqual(OpenLocationCode.normalizeLongitude(-180), -180)
    XCTAssertEqual(OpenLocationCode.normalizeLongitude(180), -180)
    XCTAssertEqual(OpenLocationCode.normalizeLongitude(200), -160)
    XCTAssertEqual(OpenLocationCode.normalizeLongitude(-200), 160)
    XCTAssertEqual(OpenLocationCode.normalizeLongitude(540), -180)
    XCTAssertEqual(OpenLocationCode.normalizeLongitude(-540), -180)

    let hugeValues: [Double] = [
      1e20, -1e20, 1e308, -1e308,
      Double.greatestFiniteMagnitude, -Double.greatestFiniteMagnitude,
    ]
    for value in hugeValues {
      let normalized = OpenLocationCode.normalizeLongitude(value)
      XCTAssertTrue(normalized.isFinite, "\(value)")
      XCTAssertGreaterThanOrEqual(normalized, -180, "\(value)")
      XCTAssertLessThan(normalized, 180, "\(value)")
    }

    XCTAssertEqual(OpenLocationCode.normalizeLongitude(.infinity), .infinity)
    XCTAssertEqual(OpenLocationCode.normalizeLongitude(-.infinity), -.infinity)
    XCTAssertTrue(OpenLocationCode.normalizeLongitude(.nan).isNaN)
  }

  /// Tests that huge finite coordinates terminate and non-finite coordinates
  /// are rejected across public APIs.
  func testNonFiniteAndHugeCoordinates() {
    XCTAssertEqual(OpenLocationCode.encode(latitude: 0, longitude: 200),
                   OpenLocationCode.encode(latitude: 0, longitude: -160))
    XCTAssertEqual(OpenLocationCode.encode(latitude: 0, longitude: 540),
                   OpenLocationCode.encode(latitude: 0, longitude: -180))
    XCTAssertNotNil(OpenLocationCode.encode(latitude: 0, longitude: 1e308))
    XCTAssertNotNil(OpenLocationCode.encode(latitude: 0, longitude: -1e308))
    XCTAssertNotNil(
        OpenLocationCode.recoverNearest(shortcode: "CWC8+Q48",
                                        referenceLatitude: 37.4,
                                        referenceLongitude: 1e308))
    XCTAssertNotNil(
        OpenLocationCode.shorten(code: "849VCWC8+Q48",
                                 latitude: 37.4,
                                 longitude: 1e308))

    let nonFiniteValues: [Double] = [.infinity, -.infinity, .nan]
    for value in nonFiniteValues {
      XCTAssertNil(OpenLocationCode.encode(latitude: 0, longitude: value))
      XCTAssertNil(OpenLocationCode.encode(latitude: value, longitude: 0))
      XCTAssertNil(OpenLocationCode.encode(latitude: value, longitude: value))
      XCTAssertNil(
          OpenLocationCode.recoverNearest(shortcode: "CWC8+Q48",
                                          referenceLatitude: 37.4,
                                          referenceLongitude: value))
      XCTAssertNil(
          OpenLocationCode.recoverNearest(shortcode: "CWC8+Q48",
                                          referenceLatitude: value,
                                          referenceLongitude: -122.0))
      XCTAssertNil(
          OpenLocationCode.shorten(code: "849VCWC8+Q48",
                                   latitude: 37.4,
                                   longitude: value))
      XCTAssertNil(
          OpenLocationCode.shorten(code: "849VCWC8+Q48",
                                   latitude: value,
                                   longitude: -122.0))
      XCTAssertEqual(
          OpenLocationCode.encodeGrid(latitude: 0,
                                      longitude: value,
                                      codeLength: 1),
          "")
      XCTAssertEqual(
          OpenLocationCode.encodeGrid(latitude: value,
                                      longitude: 0,
                                      codeLength: 1),
          "")
    }
  }

  static var allTests = [
    ("testEncodeLengthValidity", testEncodeLengthValidity),
    ("testMaxLength_Encoding", testMaxLength_Encoding),
    ("testMaxLength_Decoding", testMaxLength_Decoding),
    ("testMaxLength_Validity", testMaxLength_Validity),
    ("testNormalizeLongitude", testNormalizeLongitude),
    ("testNonFiniteAndHugeCoordinates", testNonFiniteAndHugeCoordinates),
  ]
}
