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
		self.cardStackView.cardSizeInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		self.cardStackView.delegate = self
		self.cardStackView.backgroundColor = .lightGray
		//self.reload()
	}
	
	@IBAction func segmentsChanged() {
		let arrangments: [FlipCardStackView.Arrangment] = [.single, .tight, .loose, .scattered, .tiered(offset: -20, alphaStep: 0.1)]
		
		self.cardStackView.arrangement = arrangments[self.arrangmentSegments.selectedSegmentIndex]
		UIView.animate(withDuration: 0.4, animations: {
			self.cardStackView.layoutIfNeeded()
		})
	}

	var count = 0
	@IBAction func reload() {
		let imageNames = ["ironman.png", "spider-man.png", "antman.png", "ironman.png", "spider-man.png", "antman.png"]
		
		let cards: [FlipCard] = imageNames.map { name in
			let image = UIImage(named: name)!
			let card = FlipCard(id: name + "-\(self.count)", cardViewController: SampleCardViewController(image: image))
			self.count += 1
			return card
		}
		self.cardStackView.load(cards: cards, animated: true)
	}
	

}

extension ViewController: FlipCardStackViewDelegate {
	func willRemove(card: FlipCard, to: CGPoint?, viaFlick: Bool) {
		self.cardStackView.backgroundColor = .red
		print("Will Remove \(card.id)")
	}
	
	func didRemove(card: FlipCard, to: CGPoint?, viaFlick: Bool) {
		self.cardStackView.backgroundColor = .lightGray
		print("Did Remove \(card.id)")
	}
	
	func didRemoveLastCard() {
		self.cardStackView.backgroundColor = .green
	}
	
	
}
