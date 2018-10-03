//
//  FlickCardListView.swift
//  FlickCard
//
//  Created by Ben Gottlieb on 10/2/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

public protocol FlickCardListViewDelegate: class {
	
}

open class FlickCardListViewController: FlickCardParentViewController {
	@IBOutlet public var tableView: UITableView!
	open weak var flickCardDelegate: FlickCardListViewDelegate?
	open var cardInset = UIEdgeInsets.zero
	open var cards: [FlickCardViewController] = []
	
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
	
	open func load(cards: [FlickCardViewController]) {
		self.cards = cards
		self.tableView.reloadData()
	}

	func cell(for card: FlickCardViewController) -> FlickCardListTableViewCell? {
		for cell in self.tableView.visibleCells as? [FlickCardListTableViewCell] ?? [] {
			if cell.card == card { return cell }
		}
		return nil
	}
	
	override public func targetView(for card: FlickCardViewController) -> UIView? { return self.cell(for: card)?.contentView }
	
	override public func restore(_ controller: FlickCardViewController, in targetView: UIView) {
		if let cell = self.cell(for: controller) {
			cell.updateUI()
		}
		self.state = .idle
	}

}


extension FlickCardListViewController: UITableViewDataSource {
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
	
	func indexPath(for card: FlickCardViewController) -> IndexPath? {
		if let index = self.cards.index(of: card) {
			return IndexPath(row: index, section: 0)
		}
		return nil
	}
	
}

extension FlickCardListViewController: UITableViewDelegate {
}
