//
//  Image.swift
//  Billboard
//
//  Created by Connor Temple on 6/13/17.
//  Copyright 2018 Jamf.
//  MIT license can be found in the LICENSE file of this repository.
//

import Foundation
import UIKit
import Kingfisher

// Image class to download and cache image from specified url
class Image {
	
	var url: String
	var image: ImageResource! // cached image referance
	
	init(url: String) {
		self.url = url
		
		// attempt to download image from specified url
		if let downloadURL:URL = URL(string: url) {
			image = ImageResource(downloadURL: downloadURL)
		}
	}
	
	// return the cache state of the image
	public func isCached() -> Bool {
		return ImageCache.default.isCached(forKey: url)
	}
	
}
