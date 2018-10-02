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
	
	public func load(cards: [FlickCard]) {
		
	}
}
