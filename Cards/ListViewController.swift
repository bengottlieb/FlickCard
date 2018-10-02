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
		self.cardSizeInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		self.flickCardDelegate = self
		self.view.backgroundColor = .lightGray
		self.reloadCards(animated: false)
	}
	
	var count = 0
	@IBAction func reload() { self.reloadCards(animated: true) }
	
	func reloadCards(animated: Bool) {
		let imageNames = ["ironman.png", "spider-man.png", "antman.png", "ironman.png", "spider-man.png", "antman.png"]
		
		let cards: [FlickCard] = imageNames.map { name in
			let image = UIImage(named: name)!
			let card = FlickCard(id: name + "-\(self.count)", controller: SampleCardViewController(image: image, parent: self))
			self.count += 1
			return card
		}
		self.load(cards: cards)
	}
	
}

extension ListViewController: FlickCardListViewDelegate {
	
}
