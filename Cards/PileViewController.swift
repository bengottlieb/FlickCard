//
//  ViewController.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

class PileViewController: UIViewController {
	@IBOutlet var cardPileView: FlickCardPileView!
	@IBOutlet var arrangmentSegments: UISegmentedControl!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.cardPileView.cardSizeInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		self.cardPileView.delegate = self
		self.cardPileView.backgroundColor = .lightGray
		self.reloadCards(animated: false)
	}
	
	@IBAction func segmentsChanged() {
		let arrangments: [FlickCardPileView.Arrangment] = [.single, .tight, .loose, .scattered, .tiered(offset: -20, alphaStep: 0.1)]
		
		self.cardPileView.arrangement = arrangments[self.arrangmentSegments.selectedSegmentIndex]
		UIView.animate(withDuration: 0.4, animations: {
			self.cardPileView.layoutIfNeeded()
		})
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
		self.cardPileView.load(cards: cards, animated: animated)
	}
	
	@IBAction func removeTopCard() {
		if let topCard = self.cardPileView.topCard {
			self.cardPileView.animateCardOut(topCard, to: nil, duration: 1.0)
		}
	}

}

extension PileViewController: FlickCardPileViewDelegate {
	func willRemoveLastCard() {
		
	}
	
	func willRemove(card: FlickCard, to: CGPoint?, viaFlick: Bool) {
		self.cardPileView.backgroundColor = .red
		print("Will Remove \(card.id)")
	}
	
	func didRemove(card: FlickCard, to: CGPoint?, viaFlick: Bool) {
		self.cardPileView.backgroundColor = .lightGray
		print("Did Remove \(card.id)")
	}
	
	func didRemoveLastCard() {
		self.cardPileView.backgroundColor = .green
	}
	
	
}
