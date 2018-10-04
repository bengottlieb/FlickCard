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
		self.setHighlighted(false, animated: false)
		self.cardView = nil
		self.card = nil
	}
	
	var isDrawnDepressed: Bool { return self.isHighlighted || self.isSelected }
	
	open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		let amount: CGFloat = highlighted ? 0.96 : 1.0

		UIView.animate(withDuration: 0.1) {
			self.cardContainer.transform = CGAffineTransform(scaleX: amount, y: amount)
			if let listController = self.listViewController {
				let radius = listController.shadowGlowRadius * (highlighted ? 0.5 : 1.0)
				self.cardContainer.layer.shadowRadius = radius
			}
		}
	}
	
	func updateUI() {
		guard let listController = self.listViewController else { return }
		if self.cardView?.superview == self.cardContainer { self.cardView?.removeFromSuperview() }
		
		self.selectionStyle = .none
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
			self.cardContainer.layer.cornerRadius = listController.cardCornerRadius
		}
		
		self.cardContainer.layer.masksToBounds = false
	//	self.cardContainer.layer.shadowPath = UIBezierPath(rect: self.cardContainer.bounds).cgPath
		self.cardContainer.layer.shadowRadius = listController.shadowGlowRadius
		self.cardContainer.layer.shadowOffset = .zero
		self.cardContainer.layer.shadowColor = UIColor.black.cgColor
		self.cardContainer.layer.shadowOpacity = 0.5

		guard let cardView = card.view else { return }
		self.cardView = cardView
		if let height = self.card?.listViewHeight { self.cardView?.heightConstraint.constant = height }
		self.card?.containerController = self.listViewController

		if let controller = self.listViewController {
			self.backgroundColor = controller.tableView.backgroundColor
			controller.applyCardStyling(to: cardView)
		}
		
		self.cardContainer.addSubview(cardView)
		cardView.translatesAutoresizingMaskIntoConstraints = false
		cardView.leadingAnchor.constraint(equalTo: self.cardContainer.leadingAnchor).isActive = true
		cardView.trailingAnchor.constraint(equalTo: self.cardContainer.trailingAnchor).isActive = true
		cardView.topAnchor.constraint(equalTo: self.cardContainer.topAnchor).isActive = true
		cardView.bottomAnchor.constraint(equalTo: self.cardContainer.bottomAnchor).isActive = true
		
		cardView.setNeedsLayout()
	}
}
