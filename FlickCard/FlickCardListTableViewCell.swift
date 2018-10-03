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
	var card: FlickCardController? { didSet { self.updateUI() }}
	var cardContainer: UIView!
	var cardView: UIView?
	var listViewController: FlickCardTableViewController?
	override var backgroundColor: UIColor? { didSet { self.cardContainer?.backgroundColor = self.backgroundColor }}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		if self.cardView?.superview == self.cardContainer {
			self.cardView?.removeFromSuperview()
		}
		self.cardView = nil
		self.card = nil
	}
	
	func updateUI() {
		guard let listController = self.listViewController else { return }
		if self.cardView?.superview == self.cardContainer { self.cardView?.removeFromSuperview() }
		
		let insets = listController.cardInset
		guard let card = self.card else { return }
		
		if self.cardContainer == nil {
			self.cardContainer = UIView(frame: .zero)
			self.contentView.addSubview(self.cardContainer)
			self.cardContainer.translatesAutoresizingMaskIntoConstraints = false
			self.cardContainer.layer.cornerRadius = listController.cardCornerRadius
			self.cardContainer.backgroundColor = self.backgroundColor
			self.cardContainer.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: insets.left).isActive = true
			self.cardContainer.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -insets.right).isActive = true
			self.cardContainer.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: insets.top).isActive = true
			self.cardContainer.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -insets.bottom).isActive = true
		}
		
		self.cardView = card.view
		if let height = self.card?.listViewHeight { self.cardView?.heightConstraint.constant = height }
		self.card?.containerController = self.listViewController

		if let controller = self.listViewController {
			self.backgroundColor = controller.tableView.backgroundColor
			controller.applyCardStyling(to: self.cardView)
		}
		
		self.cardContainer.addSubview(self.cardView!)
		self.cardView!.translatesAutoresizingMaskIntoConstraints = false
		self.cardView!.leadingAnchor.constraint(equalTo: self.cardContainer.leadingAnchor).isActive = true
		self.cardView!.trailingAnchor.constraint(equalTo: self.cardContainer.trailingAnchor).isActive = true
		self.cardView!.topAnchor.constraint(equalTo: self.cardContainer.topAnchor).isActive = true
		self.cardView!.bottomAnchor.constraint(equalTo: self.cardContainer.bottomAnchor).isActive = true
		
		self.cardView?.setNeedsLayout()
	}
}
