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
	@IBOutlet var arrangmentSegments: UISegmentedControl!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.reload()
	}
	
	@IBAction func segmentsChanged() {
		let arrangments: [FlipCardStackView.Arrangment] = [.single, .tight, .loose, .scattered, .tiered(15)]
		
		self.cardStackView.arrangement = arrangments[self.arrangmentSegments.selectedSegmentIndex]
		UIView.animate(withDuration: 0.4, animations: {
			self.cardStackView.layoutIfNeeded()
		})
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

