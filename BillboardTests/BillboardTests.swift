//
//  BillboardTests.swift
//  BillboardTests
//
//  Created by James Felton on 5/30/17.
//  Copyright 2018 Jamf.
//  MIT license can be found in the LICENSE file of this repository.
//

import XCTest
@testable import Billboard
import Kingfisher

class BillboardTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testGetImageFromURL() {
		let url = "https://s-media-cache-ak0.pinimg.com/originals/e1/7c/36/e17c367cd4f8b99aae00a1f82f5e0910.jpg"
		let image = BillboardImage(url: url, duration: 10, watermarkLocation: Watermark.Location.HIDDEN)
		XCTAssertTrue(image.isCached())
	}
	
	func testGetInsecureImageFromURL() {
		let url = "http://s-media-cache-ak0.pinimg.com/originals/e1/7c/36/e17c367cd4f8b99aae00a1f82f5e0910.jpg"
		let image = BillboardImage(url: url, duration: 10, watermarkLocation: Watermark.Location.HIDDEN)
		XCTAssertFalse(image.isCached())
	}
	
	func testGetImageFromInvalidURL() {
		let url = "not a link"
		let image = BillboardImage(url: url, duration: 10, watermarkLocation: Watermark.Location.HIDDEN)
		XCTAssertFalse(image.isCached())
	}
	
	func testHexUIColor() {
		let hex = "#FFFFFF"
		let color = UIColor(hexString: hex)
		NSLog("\(String(describing: color?.cgColor.components!))")
		XCTAssert(color?.cgColor.components![0] == 1 &&
			color?.cgColor.components![1] == 1 &&
			color?.cgColor.components![2] == 1 &&
			color?.cgColor.components![3] == 1)
	}
	
	func testHexUIColorWithAlpha() {
		let hex = "#FFFFFFFF"
		let color = UIColor(hexString: hex)
		NSLog("\(String(describing: color?.cgColor.components!))")
		XCTAssert(color?.cgColor.components![0] == 1 &&
			color?.cgColor.components![1] == 1 &&
			color?.cgColor.components![2] == 1 &&
			color?.cgColor.components![3] == 1)
	}
	
}
