//===-- OpenLocationCodeObjCTests.m - Tests for OpenLocationCode.swift ----===//
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
//  Objective-C tests. Verifies that the library is accessible from ObjC and
//  that the included library samples function correctly.
//
//  Authored by William Denniss.
//
//===----------------------------------------------------------------------===//

#import <XCTest/XCTest.h>
@import OpenLocationCode;

@interface OpenLocationCodeObjCTests : XCTestCase
@end

@implementation OpenLocationCodeObjCTests

/* Tests the Objective-C library README examples.
 */
- (void)testObjCExamples {
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

  XCTAssertNotNil(code);
  XCTAssertNotNil(code10Digit);
  XCTAssertNotNil(coord);
  XCTAssertNotNil(shortCode);
  XCTAssertNotNil(recoveredCode);
}

@end
