//
//  ViewController.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

class ListViewController: FlickCardTableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.cardInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
		self.flickCardDelegate = self
		self.reloadCards(animated: false)
	}
	
	var count = 0
	@IBAction func reload() { self.reloadCards(animated: true) }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let card = self.cards[indexPath.row]
		
		let controller = card.prepareToPresent(wrappingInNavigationController: true)
//		self.navigationController?.pushViewController(card, animated: true)
		self.present(controller, animated: true, completion: nil)
	}
	
	func reloadCards(animated: Bool) {
		let imageNames = ["ironman.png", "spider-man.png", "antman.png", "aquaman.png", "he-man.png", "superman.png"]
		
		var height: CGFloat = 250
		
		let cards: [FlickCardController] = imageNames.map { name in
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

extension ListViewController: FlickCardTableViewControllerDelegate {
	
}
