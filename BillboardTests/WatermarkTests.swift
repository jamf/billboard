//
//  WatermarkTests.swift
//  Billboard
//
//  Created by Connor Temple on 6/12/17.
//  Copyright © 2017 Jamf. All rights reserved.
//

import XCTest
@testable import Billboard

class WatermarkTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testCreateInavlidWatermark() {
		XCTAssertNil(Watermark.Location(rawValue: "test"))
	}
	
	func testCreateValidWatermark() {
		XCTAssertNotNil(Watermark.Location(rawValue: "bottom_left"))
	}
	
}
