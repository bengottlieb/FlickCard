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
		
		for i in 0..<10 {
			let card = FlipCard(id: "\(i)")
			self.cardStackView.add(card: card)
		}
	}


}

