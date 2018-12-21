//
//  WatermarkLocation.swift
//  Billboard
//
//  Created by Connor Temple on 6/7/17.
//  Copyright 2018 Jamf.
//  MIT license can be found in the LICENSE file of this repository.
//

import Foundation
import UIKit
import Kingfisher

class Watermark {
	
	// valid watermark locations
	enum Location: String {
		case TOP_LEFT = "top_left"
		case TOP_RIGHT = "top_right"
		case BOTTOM_LEFT = "bottom_left"
		case BOTTOM_RIGHT = "bottom_right"
		case HIDDEN = "hidden"
	}
	
	// watermark image states
	enum State {
		case DEFAULT // using default watermark
		case CUSTOM // custom watermark loaded
		case NONE // custom watermark failed to load
	}
	
	var watermarkImage: Image?
	var watermarkContainer: UIImageView
	var defaultWatermarkLocation: Location
	
	// margin around watermark image container
	var margin_x: CGFloat
	var margin_y: CGFloat
	var alpha: CGFloat
	
	// watermark manager class only allows valid watermark locations
	init(watermarkContainer: UIImageView, watermarkImage: Image?, defaultLocation: Location, margin_x: CGFloat, margin_y: CGFloat, alpha: CGFloat) {
		self.watermarkContainer = watermarkContainer
		self.watermarkImage = watermarkImage
		self.defaultWatermarkLocation = defaultLocation
		self.margin_x = margin_x
		self.margin_y = margin_y
		self.alpha = alpha
	}
	
	// check if watermark location in app config is valid. if not, use one that is
	func validateWatermarkLocation(location: String) -> Watermark.Location {
		if let watermarkLocation = Watermark.Location(rawValue: location) {
			return watermarkLocation
		} else {
			NSLog("%@", "Invalid watermark location: \(location) (using default instead)")
			return defaultWatermarkLocation
		}
	}
	
	// change the size of the watermark image container to fit the image
	private func updateWatermarkSize() {
		switch getWatermarkState() {
		case Watermark.State.CUSTOM, Watermark.State.DEFAULT:
			if let image: UIImage = watermarkContainer.image {
				watermarkContainer.frame.size = image.size
			}
		default: break
		}
	}
	
	// get the state of the watermark image (TODO: i think this check could be better)
	public func getWatermarkState() -> State {
		// use default watermark if custom isn't set or blank if custom couldn't be loaded
		if watermarkImage != nil && watermarkImage!.isCached() {
			return State.CUSTOM
			
		} else if watermarkImage != nil && !watermarkImage!.isCached() {
			return State.NONE
			
		} else {
			return State.DEFAULT
		}
	}
	
	// make sure correct watermark is displayed
	private func configureWatermarkImage() {
		// use default watermark if custom isn't set or blank if custom couldn't be loaded
		switch getWatermarkState() {
		case Watermark.State.CUSTOM:
			watermarkContainer.kf.setImage(with: watermarkImage!.image)
		case Watermark.State.DEFAULT:
			watermarkContainer.image = UIImage(named: BillboardConstants.DefaultWatermarkResource)
		case Watermark.State.NONE:
			watermarkContainer.image = UIImage(named: "")
		}
		updateWatermarkSize()
	}
	
	// move watermark to a specified corner of the screen
	func moveWatermark(location: Watermark.Location) {
		configureWatermarkImage()
		
		// default show watermark unless specified hidden
		watermarkContainer.isHidden = false
		watermarkContainer.alpha = alpha
		
		// get screen size and watermark size for calculations
		let screenSize = UIScreen.main.bounds
		let watermarkSize = watermarkContainer.frame.size
		
		// figure out where to put the watermark
		switch location {
		case .TOP_RIGHT:
			watermarkContainer.frame.origin.x = screenSize.width - watermarkSize.width - margin_x
			watermarkContainer.frame.origin.y = margin_y
		case .TOP_LEFT:
			watermarkContainer.frame.origin.x = margin_x
			watermarkContainer.frame.origin.y = margin_y
		case .BOTTOM_RIGHT:
			watermarkContainer.frame.origin.x = screenSize.width - watermarkSize.width - margin_x
			watermarkContainer.frame.origin.y = screenSize.height - watermarkSize.height - margin_y
		case .BOTTOM_LEFT:
			watermarkContainer.frame.origin.x = margin_x
			watermarkContainer.frame.origin.y = screenSize.height - watermarkSize.height - margin_y
		case .HIDDEN:
			watermarkContainer.isHidden = true
		}
	}

	
}
