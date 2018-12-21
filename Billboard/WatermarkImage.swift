//
//  WatermarkImage.swift
//  Billboard
//
//  Created by Connor Temple on 6/7/17.
//  Copyright 2018 Jamf.
//  MIT license can be found in the LICENSE file of this repository.
//

import Foundation
import UIKit
import Kingfisher

class WatermarkImage: Image {
	
	// watermark image class to downlaod ahead of time without resizing
	override init(url: String) {
		super.init(url: url)
		
		if image != nil {
			KingfisherManager.shared.retrieveImage(with: image.downloadURL, options: [], progressBlock: { receivedSize, totalSize in
				NSLog("\(receivedSize)/\(totalSize)")
			}) { result in
				switch(result) {
				case .success(let value):
					NSLog("%@, %@, %@", String(describing: value.image), String(describing: value.cacheType), String(describing: value.source.url))
				case .failure(let value):
					NSLog("%@, %@", String(describing: value.errorCode), String(describing: value.errorDescription))
				}
			}
		}
	}
	
}
