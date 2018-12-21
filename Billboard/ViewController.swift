//
//  ViewController.swift
//  Billboard
//
//  Created by James Felton on 5/30/17.
//  Copyright 2018 Jamf.
//  MIT license can be found in the LICENSE file of this repository.
//

import UIKit
import ManagedAppConfigLib

class ViewController: UIViewController {
	
	@IBOutlet weak var imageContainer: UIImageView!
	@IBOutlet weak var watermark: UIImageView!
	@IBOutlet weak var billboardText: UILabel!
	var billboard: Billboard!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		// Disable app idle timer so it always displays
		UIApplication.shared.isIdleTimerDisabled = true
		
		// This is run on the background queue
		DispatchQueue.global(qos: .background).async {
			let config = ManagedAppConfig.shared
			self.billboard = Billboard(config: config, billboard: self.imageContainer, billboardText: self.billboardText, watermark: self.watermark)
			
			// This is run on the main queue, after the previous code in outer block
			DispatchQueue.main.async {
				self.billboard.configure()
				self.billboard.display()
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}

