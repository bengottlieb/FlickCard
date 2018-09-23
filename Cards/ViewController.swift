//
//  ViewController.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet var cardStackView: FlipCardStackView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.reload()
		
	}

	@IBAction func reload() {
		let imageNames = ["ironman.png", "spider-man.png", "antman.png", "ironman.png", "spider-man.png", "antman.png"]
		var count = 0
		
		for name in imageNames {
			let image = UIImage(named: name)!
			let card = FlipCard(id: name + "-\(count)", cardViewController: SampleCardViewController(image: image))
			self.cardStackView.add(card: card)
			count += 1
		}
	}
	

}

