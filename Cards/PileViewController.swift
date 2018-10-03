//
//  ViewController.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

class PileViewController: FlickCardPileViewController {
	@IBOutlet var arrangmentSegments: UISegmentedControl!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.cardInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		self.flickCardPileViewDelegate = self
		self.pileView.backgroundColor = .lightGray
		self.reloadCards(animated: false)
	}
	
	@IBAction func segmentsChanged() {
		let arrangments: [FlickCardPileViewController.Arrangment] = [.single, .tight, .loose, .scattered, .tiered(offset: -20, alphaStep: 0.1)]
		
		self.arrangement = arrangments[self.arrangmentSegments.selectedSegmentIndex]
		UIView.animate(withDuration: 0.4, animations: {
			self.pileView.layoutIfNeeded()
		})
	}

	var count = 0
	@IBAction func reload() { self.reloadCards(animated: true) }
	
	func reloadCards(animated: Bool) {
		let imageNames = ["ironman.png", "spider-man.png", "antman.png", "aquaman.png", "he-man.png", "superman.png"]

		let cards: [FlickCard] = imageNames.map { name in
			let image = UIImage(named: name)!
			let card = FlickCard(id: name + "-\(self.count)", controller: SampleCardViewController(image: image, parent: self))
			self.count += 1
			return card
		}
		self.load(cards: cards, animated: animated)
	}
	
	@IBAction func removeTopCard() {
		if let topCard = self.topCard {
			self.animateCardOut(topCard, to: nil, duration: 1.0)
		}
	}

}

extension PileViewController: FlickCardPileViewDelegate {
	func willRemoveLastCardFromPile() {
		
	}
	
	func willRemoveFromPile(card: FlickCard, to: CGPoint?, viaFlick: Bool) {
		self.pileView.backgroundColor = .red
		print("Will Remove \(card.id)")
	}
	
	func didRemoveFromPile(card: FlickCard, to: CGPoint?, viaFlick: Bool) {
		self.pileView.backgroundColor = .lightGray
		print("Did Remove \(card.id)")
	}
	
	func didRemoveLastCardFromPile() {
		self.pileView.backgroundColor = .green
	}
	
	
}
