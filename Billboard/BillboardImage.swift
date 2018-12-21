//
//  BillboardImage.swift
//  Billboard
//
//  Created by Connor Temple on 6/7/17.
//  Copyright 2018 Jamf.
//  MIT license can be found in the LICENSE file of this repository.
//

import Foundation
import UIKit
import Kingfisher

class BillboardImage: Image {
	
	var duration: Double
	var watermarkLocation: Watermark.Location
	
	// BillboardImage is a class to use for each image displayed on the billboard
	init(url: String, duration: Double, watermarkLocation: Watermark.Location) {
		self.watermarkLocation = watermarkLocation
		self.duration = duration
		super.init(url: url)
		
		if image != nil {
			// download and resize image to screen resolution for future use
			let screenSize = UIScreen.main.bounds
			let processor = ResizingImageProcessor(referenceSize: CGSize(width: screenSize.width, height: screenSize.height), mode: .aspectFit)
			KingfisherManager.shared.retrieveImage(with: image.downloadURL, options: [.processor(processor)], progressBlock: { receivedSize, totalSize in
				NSLog("\(receivedSize)/\(totalSize)")
			}) { result in
				switch(result){
				case .success(let value):
					NSLog("%@, %@, %@", String(describing: value.image), String(describing: value.cacheType), String(describing: value.source.url))
				case .failure(let value):
					NSLog("%@, %@", String(describing: value.errorCode), String(describing: value.errorDescription))
				}
			}
		}
	}
	
}
