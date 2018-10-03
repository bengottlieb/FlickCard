//
//  ViewController.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

class ListViewController: FlickCardListViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.cardInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		self.flickCardDelegate = self
		self.reloadCards(animated: false)
	}
	
	var count = 0
	@IBAction func reload() { self.reloadCards(animated: true) }
	
	func reloadCards(animated: Bool) {
		let imageNames = ["ironman.png", "spider-man.png", "antman.png", "aquaman.png", "he-man.png", "superman.png"]
		
		var height: CGFloat = 250
		
		let cards: [FlickCardViewController] = imageNames.map { name in
			let image = UIImage(named: name)!
			let controller = SampleFixedCardViewController(image: image, parent: self, id: name + "-\(self.count)")
			controller.listHeight = height
			height += 30
			self.count += 1
			return controller
		}
		self.load(cards: cards)
	}
	
}

extension ListViewController: FlickCardListViewDelegate {
	
}
