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
	open var cardSizeInset = UIEdgeInsets.zero
	open var cards: [FlickCard] = []
	
	open override func viewDidLoad() {
		if self.tableView == nil {
			self.tableView = UITableView(frame: self.view.bounds)
			self.view.addSubview(self.tableView)
			self.tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		}
		
		if self.tableView.delegate !== self {
			self.tableView.dataSource = self
			self.tableView.delegate = self
			self.tableView.rowHeight = UITableView.automaticDimension
			self.tableView.register(FlickCardListTableViewCell.self, forCellReuseIdentifier: FlickCardListTableViewCell.identifier)
		}
	}
	
	open func load(cards: [FlickCard]) {
		self.cards = cards
		self.tableView.reloadData()
	}
}


extension FlickCardListViewController: UITableViewDataSource {
	open func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.cards.count
	}
	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FlickCardListTableViewCell.identifier, for: indexPath) as! FlickCardListTableViewCell
		
		cell.card = self.cards[indexPath.row]
		return cell
	}
	
	open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 300
	}
}

extension FlickCardListViewController: UITableViewDelegate {
	
}
