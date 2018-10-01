//
//  ViewController.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet var cardStackView: FlickCardStackView!
	@IBOutlet var arrangmentSegments: UISegmentedControl!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.cardStackView.cardSizeInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		self.cardStackView.delegate = self
		self.cardStackView.backgroundColor = .lightGray
		self.reloadCards(animated: false)
	}
	
	@IBAction func segmentsChanged() {
		let arrangments: [FlickCardStackView.Arrangment] = [.single, .tight, .loose, .scattered, .tiered(offset: -20, alphaStep: 0.1)]
		
		self.cardStackView.arrangement = arrangments[self.arrangmentSegments.selectedSegmentIndex]
		UIView.animate(withDuration: 0.4, animations: {
			self.cardStackView.layoutIfNeeded()
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
		self.cardStackView.load(cards: cards, animated: animated)
	}
	
	@IBAction func removeTopCard() {
		if let topCard = self.cardStackView.topCard {
			self.cardStackView.animateCardOut(topCard, to: nil, duration: 1.0)
		}
	}

}

extension ViewController: FlickCardStackViewDelegate {
	func willRemoveLastCard() {
		
	}
	
	func willRemove(card: FlickCard, to: CGPoint?, viaFlick: Bool) {
		self.cardStackView.backgroundColor = .red
		print("Will Remove \(card.id)")
	}
	
	func didRemove(card: FlickCard, to: CGPoint?, viaFlick: Bool) {
		self.cardStackView.backgroundColor = .lightGray
		print("Did Remove \(card.id)")
	}
	
	func didRemoveLastCard() {
		self.cardStackView.backgroundColor = .green
	}
	
	
}
