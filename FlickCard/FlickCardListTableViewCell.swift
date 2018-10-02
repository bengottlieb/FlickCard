//
//  FlickCardListTableViewCell.swift
//  FlickCard
//
//  Created by Ben Gottlieb on 10/2/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

class FlickCardListTableViewCell: UITableViewCell {
	static let identifier = "FlickCardListTableViewCell"
	var card: FlickCard? { didSet { if self.card != oldValue { self.updateUI() }}}
	var cardView: FlickCardView?
	var heightConstraint: NSLayoutConstraint!

	func updateUI() {
		self.cardView?.removeFromSuperview()
		if self.heightConstraint == nil {
			self.heightConstraint = self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 320)
			self.heightConstraint.isActive = true
		}
		
		guard let card = self.card else { return }
		
		self.cardView = card.viewController.cardView
		self.contentView.addSubview(self.cardView!)
		self.cardView!.translatesAutoresizingMaskIntoConstraints = false
		self.cardView!.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0).isActive = true
		self.cardView!.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0).isActive = true
		self.cardView!.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
		self.cardView!.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
		
		
	}
}
