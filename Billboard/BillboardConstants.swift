//
//  Constants.swift
//  Billboard
//
//  Created by Connor Temple on 6/7/17.
//  Copyright 2018 Jamf.
//  MIT license can be found in the LICENSE file of this repository.
//

import Foundation

class BillboardConstants {
	// global keys
	static let ImageDictionaryKey        = "com.jamf.config.images"
	static let RotationDurationKey       = "com.jamf.config.image.duration"
	static let BackgroundColorKey        = "com.jamf.config.background.color"
	
	// image keys
	static let ImageURLKey               = "com.jamf.config.image.url"
	
	// watermark keys
	static let WatermarkURLKey           = "com.jamf.config.watermark.url"
	static let WatermarkLocationKey      = "com.jamf.config.watermark.location"
	static let WatermarkMarginKeyX       = "com.jamf.config.watermark.margin.x"
	static let WatermarkMarginKeyY       = "com.jamf.config.watermark.margin.y"
	static let WatermarkAlphaKey         = "com.jamf.config.watermark.alpha"
	
	// other constants
	static let DefaultMargin = 20
	static let DefaultWatermarkResource = "jamf"
}
