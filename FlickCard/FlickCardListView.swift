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

public class FlickCardListView: UITableView {
	public weak var flickCardDelegate: FlickCardListViewDelegate?
	public var cardSizeInset = UIEdgeInsets.zero
	public var cards: [FlickCard] = []
	
	public override func didMoveToSuperview() {
		if self.delegate !== self {
			self.dataSource = self
			self.delegate = self
			self.rowHeight = UITableView.automaticDimension
			self.register(FlickCardListTableViewCell.self, forCellReuseIdentifier: FlickCardListTableViewCell.identifier)
		}
	}
	
	public func load(cards: [FlickCard]) {
		self.cards = cards
		self.reloadData()
	}
}


extension FlickCardListView: UITableViewDataSource {
	public func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.cards.count
	}
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FlickCardListTableViewCell.identifier, for: indexPath) as! FlickCardListTableViewCell
		
		cell.card = self.cards[indexPath.row]
		return cell
	}
	
	public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 300
	}
}

extension FlickCardListView: UITableViewDelegate {
	
}
