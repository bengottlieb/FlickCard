//
//  FlickCardTableViewController.swift
//  FlickCard
//
//  Created by Ben Gottlieb on 10/2/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

public protocol FlickCardTableViewControllerDelegate: class {
	
}

open class FlickCardTableViewController: FlickCardContainerViewController {
	@IBOutlet public var tableView: UITableView!
	open weak var flickCardDelegate: FlickCardTableViewControllerDelegate?
	open var cardInset = UIEdgeInsets.zero
	public var shadowGlowRadius: CGFloat = 5
	
	open override func viewDidLoad() {
		if self.tableView == nil {
			self.tableView = UITableView(frame: self.view.bounds)
			self.view.addSubview(self.tableView)
			self.tableView.separatorStyle = .none
			self.tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		}
		
		if self.tableView.delegate !== self {
			self.tableView.dataSource = self
			self.tableView.delegate = self
			self.tableView.rowHeight = UITableView.automaticDimension
			self.tableView.register(FlickCardListTableViewCell.self, forCellReuseIdentifier: FlickCardListTableViewCell.identifier)
		}
	}
	
	override open func load(cards: [FlickCardController], animated: Bool = false) {
		super.load(cards: cards, animated: animated)
		self.tableView.reloadData()
	}
	
	override public func applyCardStyling(to view: UIView?) {
		view?.layer.cornerRadius = self.cardCornerRadius
		view?.layer.borderColor = self.cardBorderColor.cgColor
		view?.layer.borderWidth = self.cardBorderWidth
		view?.layer.masksToBounds = true
	}

	func cell(for card: FlickCardController) -> FlickCardListTableViewCell? {
		for cell in self.tableView.visibleCells as? [FlickCardListTableViewCell] ?? [] {
			if cell.card == card { return cell }
		}
		return nil
	}
	
	override public func targetView(for card: FlickCardController) -> UIView? { return self.cell(for: card)?.cardContainer }
	
	override public func restore(_ controller: FlickCardController, in targetView: UIView) {
		if let cell = self.cell(for: controller) {
			cell.updateUI()
		}
		self.state = .idle
	}

}


extension FlickCardTableViewController: UITableViewDataSource {
	open func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.cards.count
	}
	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FlickCardListTableViewCell.identifier, for: indexPath) as! FlickCardListTableViewCell
		
		cell.listViewController = self
		cell.card = self.cards[indexPath.row]
		return cell
	}
	
	open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		if let height = self.cards[indexPath.row].listViewHeight {
			return height + self.cardInset.bottom + self.cardInset.top
		}
		return 200
	}
	
	func indexPath(for card: FlickCardController) -> IndexPath? {
		if let index = self.cards.index(of: card) {
			return IndexPath(row: index, section: 0)
		}
		return nil
	}
	
}

extension FlickCardTableViewController: UITableViewDelegate {
}
