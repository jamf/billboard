//
//  UIColor.swift
//  Billboard
//
//  Created by Connor Temple on 7/10/18.
//  Copyright 2018 Jamf.
//  MIT license can be found in the LICENSE file of this repository.
//
// Extend UIColor with convenience functions for using hex color strings.
// Modified from: https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
// Supports regular 6 digit hex strings and 8 digits for the alpha component

import UIKit

extension UIColor {
	public convenience init?(hexString: String) {
		let r, g, b, a: CGFloat
		
		if hexString.hasPrefix("#") {
			let start = hexString.index(hexString.startIndex, offsetBy: 1)
			let hexColor = hexString.substring(from: start)
			
			if hexColor.characters.count == 8 {
				let scanner = Scanner(string: hexColor)
				var hexNumber: UInt64 = 0
				
				if scanner.scanHexInt64(&hexNumber) {
					r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
					g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
					b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
					a = CGFloat(hexNumber & 0x000000ff) / 255
					
					self.init(red: r, green: g, blue: b, alpha: a)
					return
				}
			} else if hexColor.characters.count == 6 {
				let scanner = Scanner(string: hexColor)
				var hexNumber: UInt64 = 0
				
				if scanner.scanHexInt64(&hexNumber) {
					r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
					g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
					b = CGFloat(hexNumber & 0x0000ff) / 255
					
					self.init(red: r, green: g, blue: b, alpha: 1)
					return
				}
			}
		}
		
		return nil
	}
}
