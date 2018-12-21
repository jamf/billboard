//
//  Billboard.swift
//  Billboard
//
//  Created by Connor Temple on 6/8/17.
//  Copyright 2018 Jamf.
//  MIT license can be found in the LICENSE file of this repository.
//

import Foundation
import UIKit
import Kingfisher
import ManagedAppConfigLib

class Billboard {
	
	private var running = false
	private var timer: Timer!
	private var config: ManagedAppConfig
	
	private var billboard: UIImageView
	private var billboardText: UILabel

	private var current = 0 // current image being displayed from billboard image array
	private var billboardImages: [BillboardImage] = [] // main billboard image array
	private var defaultRotationDuration: Double = 10 // if rotation duration is not specified, use default of 10 seconds
	private var minimumRotationDuration: Double = 1 // anything under 1 second is way too fast
	private var watermarkManager: Watermark! // class to manage watermark location
	private var watermark: UIImageView // watermark image container
	private var acTimer: Timer! // app config change hook delay timer
	
	// create billboard for an image container using app config
	init(config: ManagedAppConfig, billboard: UIImageView, billboardText: UILabel, watermark: UIImageView) {
		// managed app config
		self.config = config
		
		// initialize reference to ui elements
		self.billboard = billboard
		self.billboardText = billboardText
		self.watermark = watermark
		
		// managed app config hooks to update the billboard when the config is modified
		self.config.addAppConfigChangedHook({ data in // warning: fires 5 times when app config changes
			if self.acTimer != nil && self.acTimer.isValid {
				self.acTimer.invalidate()
				self.acTimer =  nil
			}
			
			// 2 second delay to prevent other methods from being called 5 times in a row
			self.acTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (Timer) in
				self.configure()
				self.display()
			}
		})
	}
	
	public func configure() {
		stopDisplay()
		
		// setup configuration screen (default display nothing while initializing)
		CATransaction.begin()
		self.billboardText.numberOfLines = 1
		self.billboardText.text = "Billboard is loading images"
		self.billboardText.isHidden = false
		self.billboard.image = UIImage(named: "Configure")
		
		// initialize default watermark for configure screen
		var watermark_margin_x: CGFloat = CGFloat(BillboardConstants.DefaultMargin)
		var watermark_margin_y: CGFloat = CGFloat(BillboardConstants.DefaultMargin)
		var alpha: CGFloat = CGFloat(1)
		watermarkManager = Watermark(
			watermarkContainer: watermark,
			watermarkImage: nil,
			defaultLocation: .BOTTOM_LEFT,
			margin_x: watermark_margin_x,
			margin_y: watermark_margin_y,
			alpha: alpha)
		watermarkManager.moveWatermark(location: watermarkManager.defaultWatermarkLocation)
		
		// show configuration screen
		CATransaction.commit()
		
		billboardImages.removeAll()

		if let hexColor = config.getConfigValue(forKey: BillboardConstants.BackgroundColorKey) as? String {
			if let color = UIColor(hexString: hexColor) {
				billboard.backgroundColor = color
			}
		}

		// check if global rotation duration is set in app config (only set global rotation duration if longer than minimum)
		if let rotationDuration = config.getConfigValue(forKey: BillboardConstants.RotationDurationKey) as? Double {
			if rotationDuration >= minimumRotationDuration {
				defaultRotationDuration = rotationDuration
			} else {
				defaultRotationDuration = minimumRotationDuration
			}
		}
		NSLog("Rotation Duration: \(defaultRotationDuration)")
		
		// check if custom watermark margin is set or use default
		if let watermark_margin = config.getConfigValue(forKey: BillboardConstants.WatermarkMarginKeyX) as? Double {
			watermark_margin_x = CGFloat(watermark_margin)
		}
		if let watermark_margin = config.getConfigValue(forKey: BillboardConstants.WatermarkMarginKeyY) as? Double {
			watermark_margin_y = CGFloat(watermark_margin)
		}
		NSLog("Watermark Margins: X:\(watermark_margin_x) Y:\(watermark_margin_y)")
		
		// custom watermark alpha between 0-1
		if let watermark_alpha = config.getConfigValue(forKey: BillboardConstants.WatermarkAlphaKey) as? Double {
			switch watermark_alpha {
			case _ where watermark_alpha < 0:
				alpha = CGFloat(0)
			case _ where watermark_alpha > 1:
				alpha = CGFloat(1)
			default:
				alpha = CGFloat(watermark_alpha)
			}
		}
		NSLog("Watermark Alpha: \(alpha)")
		
		// check if custom watermark logo is defined or use default
		if let watermarkImageURL = config.getConfigValue(forKey: BillboardConstants.WatermarkURLKey) as? String {
			watermarkManager = Watermark(watermarkContainer: watermark,
				watermarkImage: WatermarkImage(url: watermarkImageURL),
				defaultLocation: .BOTTOM_LEFT,
				margin_x: watermark_margin_x,
				margin_y: watermark_margin_y,
				alpha: alpha)
		} else {
			watermarkManager = Watermark(watermarkContainer: watermark,
				watermarkImage: nil,
				defaultLocation: .BOTTOM_LEFT,
				margin_x: watermark_margin_x,
				margin_y: watermark_margin_y,
				alpha: alpha)
		}
		// log status of watermark image
		switch watermarkManager.getWatermarkState() {
		case Watermark.State.CUSTOM:
			NSLog("%@", "Watermark image: \(watermarkManager.watermarkImage!.url)")
		case Watermark.State.DEFAULT:
			NSLog("Using default watermark image")
		case Watermark.State.NONE:
			NSLog("Custom watermark could not be loaded")
		}
		
		// check if global watermark location is set in app config
		if let watermarkLocation = config.getConfigValue(forKey: BillboardConstants.WatermarkLocationKey) as? String {
			watermarkManager.defaultWatermarkLocation = watermarkManager.validateWatermarkLocation(location: watermarkLocation)
		}
		NSLog("Watermark location: \(watermarkManager.defaultWatermarkLocation)")
		
		// get images from dict array
		if let imageDictionary = config.getConfigValue(forKey: BillboardConstants.ImageDictionaryKey) as? [NSDictionary] {
			for image in imageDictionary {
				
				// per image settings
				var duration: Double
				var watermarkLocation: Watermark.Location
				
				// get specific image duration or use global default (only use custom rotation duration if longer than minimum)
				if let imageDuration = image.value(forKey: BillboardConstants.RotationDurationKey) as? Double {
					if imageDuration >= minimumRotationDuration {
						duration = imageDuration
					} else {
						duration = defaultRotationDuration
					}
				} else {
					duration = defaultRotationDuration
				}
				
				// get logo overlay location or use default
				if let imageWatermarkLocation = image.value(forKey: BillboardConstants.WatermarkLocationKey) as? String {
					watermarkLocation = watermarkManager.validateWatermarkLocation(location: imageWatermarkLocation)
				} else {
					watermarkLocation = watermarkManager.defaultWatermarkLocation
				}
				
				// attempt to get image from url or log if failed and skip it
				if let imageURL = image.value(forKey: BillboardConstants.ImageURLKey) as? String {
					let billboardImage = BillboardImage(url: imageURL, duration: duration, watermarkLocation: watermarkLocation)
					billboardImages.append(billboardImage)
				} else {
					NSLog("Image url could not be found")
				}
			}
		}
		
	}
	
	public func isRunning() -> Bool {
		return running
	}
	
	public func stopDisplay() {
		running = false
		if timer != nil && timer.isValid {
			timer.invalidate()
			timer = nil
		}
	}
	
	public func display() {
		running = true
		
		if billboardImages.count > 0 {
			NSLog("Images: \(billboardImages.count)")
			for image in billboardImages {
				NSLog("%@", image.image.downloadURL.absoluteString)
			}
			// Hide text when ready to display images
			CATransaction.begin()
			self.billboardText.isHidden = true
			CATransaction.commit()
			
			// resize processor for making sure images fit the screen
			let screenSize = UIScreen.main.bounds
			let processor = ResizingImageProcessor(referenceSize: CGSize(width: screenSize.width, height: screenSize.height), mode: .aspectFit)
			
			// start displaying images
			self.displayImages(processor: processor)
		} else {
			CATransaction.begin()
			self.billboardText.numberOfLines = 3
			self.billboardText.text =
				"Billboard was unable to find any images in it's app config\n"
				+ "For information on how to configure visit:\n"
				+ "github.com/jamf/billboard"
			self.billboardText.isHidden = false
			self.billboard.backgroundColor = .black
			CATransaction.commit()
		}
	}
	
	private func displayImages(processor: ResizingImageProcessor) {
		if running {
			self.billboard.kf.setImage(with: self.billboardImages[self.current].image, placeholder: UIImage(named: "Configure"), options: [.processor(processor)], completionHandler: { result in
				
				// setup timer to switch to next image after the current one's duration has gone by
				self.timer = Timer.scheduledTimer(withTimeInterval: self.billboardImages[self.current].duration, repeats: false) { (Timer) in
					self.current += 1
					if self.current >= self.billboardImages.count {
						self.current = 0
					}
					
					self.displayImages(processor: processor)
				}
				
				switch result {
				case .success(let value):
					NSLog("%@", String(describing: value.source.url))
					
					// move watermark to specified location
					self.watermarkManager.moveWatermark(location: self.billboardImages[self.current].watermarkLocation)
					
					NSLog("\(self.timer.fireDate)")
				case .failure(let value):
					NSLog("%@, %@", String(describing: value.errorCode), String(describing: value.errorDescription))
					
					// error displaying image, move to next
					self.timer.fire()
				}
			})
		}
	}
}
