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
//  Unit tests for core functionality using the official CSV test data.
//
//  Authored by William Denniss. Ported from openlocationcode_test.py.
//
//===----------------------------------------------------------------------===//

import XCTest
import Foundation
@testable import OpenLocationCode

/// OLC Test helpers.
class OLCTestHelper {
  /// Loads CSV data from the test bundle and parses into an Array of
  /// Dictionaries using the given keys.
  ///
  /// - Parameter filename: the filename of the CSV file with no path or
  ///   extension component
  /// - Parameter keys: the keys used to build the dictionary.
  /// - Returns: An array of each line of data represented as a dictionary
  ///   with the given keys.
  static func loadData(filename: String,
                       keys: Array<String>)
                       -> Array<Dictionary<String, String>>? {
    var testData:Array<Dictionary<String, String>> = []
    var csvData: String?

    // Tries to load CSV data from bundle.
    #if !os(Linux)
    let testBundle = Bundle(for: OLCTestHelper.self)
    if let path = testBundle.path(forResource: filename, ofType: "csv") {
      csvData = try? String(contentsOfFile: path)
    }
    #endif
    // Falls back to loading directly from the file.
    if csvData == nil {
      csvData =  try? String(contentsOfFile: "test_data/\(filename).csv", 
                                   encoding: .utf8)
    }
    // Parses data.
    if let csvData = csvData {
      // Iterates each line.
      for(line) in csvData.components(separatedBy: CharacterSet.newlines) {
        if line.hasPrefix("#") || line.count == 0 {
          continue
        }
        // Parses as a comma separated array.
        let lineData =
            line.components(separatedBy: CharacterSet.init(charactersIn: ","))
        // Converts to dict.
        var lineDict:Dictionary<String, String> = [:]
        for i in 0 ..< keys.count {
          lineDict[keys[i]] = lineData[i]
        }
        testData += [lineDict]
      }
      return testData
    }
    return nil
  }
}

/// Tests the validity methods.
class ValidityTests: XCTestCase {
  var testData:Array<Dictionary<String, String>> = []

  override func setUp() {
    super.setUp()
    let keys = ["code","isValid","isShort","isFull"]
    testData = OLCTestHelper.loadData(filename: "validityTests", keys: keys)!
    XCTAssertNotNil(testData)
    XCTAssert(testData.count > 0)
  }

  /// Tests OpenLocationCode.isValid
  func testValidCodes() {
    for(td) in testData {
      XCTAssertEqual(OpenLocationCode.isValid(code: td["code"]!),
                     Bool(td["isValid"]!)!)
    }
  }

  /// Tests OpenLocationCode.isFull
  func testFullCodes() {
    for(td) in testData {
      XCTAssertEqual(OpenLocationCode.isFull(code: td["code"]!),
                     Bool(td["isFull"]!)!)
    }
  }

  /// Tests OpenLocationCode.isShort
  func testShortCodes() {
    for(td) in testData {
      XCTAssertEqual(OpenLocationCode.isShort(code: td["code"]!),
                     Bool(td["isShort"]!)!)
    }
  }

  static var allTests = [
    ("testValidCodes", testValidCodes),
    ("testFullCodes", testFullCodes),
    ("testShortCodes", testShortCodes),
  ]
}

/// Tests the code shortening methods.
class ShortenTests: XCTestCase {
  var testData:Array<Dictionary<String, String>> = []

  override func setUp() {
    super.setUp()
    let keys = ["code","lat","lng","shortcode", "testtype"]
    testData = OLCTestHelper.loadData(filename: "shortCodeTests", keys: keys)!
    XCTAssertNotNil(testData)
    XCTAssert(testData.count > 0)
  }

  /// Tests OpenLocationCode.shorten
  func testFullToShort() {
    for(td) in testData {
      if td["testtype"] == "B" || td["testtype"] == "S" {
        let shortened = OpenLocationCode.shorten(code: td["code"]!,
                                                 latitude: Double(td["lat"]!)!,
                                                 longitude: Double(td["lng"]!)!,
                                                 maximumTruncation: 8)!
        XCTAssertEqual(shortened, td["shortcode"]!)
      }
      if td["testtype"] == "B" || td["testtype"] == "R" {
        let recovered =
          OpenLocationCode.recoverNearest(shortcode: td["shortcode"]!,
              referenceLatitude: Double(td["lat"]!)!,
              referenceLongitude: Double(td["lng"]!)!)
        XCTAssertEqual(recovered, td["code"]!)
      }
    }
  }

  static var allTests = [
    ("testFullToShort", testFullToShort),
  ]
}

/// Tests encoding and decoding.
class EncodingTests: XCTestCase {
  var testData:Array<Dictionary<String, String>> = []

  override func setUp() {
    super.setUp()
    let keys = ["code","lat","lng","latLo","lngLo","latHi","lngHi"]
    testData = OLCTestHelper.loadData(filename: "encodingTests", keys: keys)!
    XCTAssertNotNil(testData)
    XCTAssert(testData.count > 0)
  }

  /// Tests OpenLocationCode.encode
  func testEncoding() {
    for(td) in testData {
      let code = td["code"]!
      var codelength = code.count - 1
      if (code.find("0") >= 0)
      {
        codelength = code.find("0")
      }
      let encoded = OpenLocationCode.encode(latitude: Double(td["lat"]!)!,
                                            longitude: Double(td["lng"]!)!,
                                            codeLength: codelength)
      XCTAssertEqual(encoded, code)
    }
  }

  /// Tests OpenLocationCode.decode
  func testDecoding() {
    let precision = pow(10.0,10.0)

    for(td) in testData {
      let decoded: OpenLocationCodeArea =
          OpenLocationCode.decode(td["code"]!)!
      XCTAssertEqual((decoded.latitudeLo * precision).rounded(),
                     (Double(td["latLo"]!)! * precision).rounded(),
                     "Failure with " + td["code"]!)
      XCTAssertEqual((decoded.longitudeLo * precision).rounded(),
                     (Double(td["lngLo"]!)! * precision).rounded(),
                     "Failure with " + td["code"]!)
      XCTAssertEqual((decoded.latitudeHi * precision).rounded(),
                     (Double(td["latHi"]!)! * precision).rounded(),
                     "Failure with " + td["code"]!)
      XCTAssertEqual((decoded.longitudeHi * precision).rounded(),
                     (Double(td["lngHi"]!)! * precision).rounded(),
                     "Failure with " + td["code"]!)
    }
  }

  static var allTests = [
    ("testEncoding", testEncoding),
    ("testDecoding", testDecoding),
  ]
}
