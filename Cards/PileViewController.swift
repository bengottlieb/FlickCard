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
		self.reloadCards(animated: false)
		self.avoidKeyboard = true
		
		let recog = UITapGestureRecognizer(target: self, action: #selector(pileTapped))
		self.pileView.addGestureRecognizer(recog)
	}
	
	@objc func pileTapped() {
		guard let controller = self.topCard?.prepareToPresent(wrappingInNavigationController: true) else { return }
		self.present(controller, animated: true, completion: nil)
	}
	
	@IBAction func flipTopCard() {
		let flipside = SampleCardViewController(image: UIImage(named: "antman.png")!, id: UUID().uuidString)
		
		self.flip(card: self.topCard!, overTo: self.topCard?.flipsideController ?? flipside, duration: 1.0) {
			print("All Done")
		}
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
		let imageNames = ["ironman.png", "spider-man.png", "aquaman.png", "he-man.png", "superman.png"]

		let cards: [FlickCardController] = imageNames.map { name in
			let image = UIImage(named: name)!
			let controller = SampleFixedCardViewController(image: image, id: name + "-\(self.count)")
			
			self.count += 1
			return controller
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
	
	func willRemoveFromPile(card: FlickCardController, to: CGPoint?, viaFlick: Bool) {
		self.pileView.backgroundColor = .red
	}
	
	func didRemoveFromPile(card: FlickCardController, to: CGPoint?, viaFlick: Bool) {
		self.pileView.backgroundColor = .lightGray
	}
	
	func didRemoveLastCardFromPile() {
		self.pileView.backgroundColor = .green
	}
	
	
}
