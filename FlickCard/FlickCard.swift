//
//  FlickCard.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

open class FlickCard: CustomStringConvertible, Equatable {
	public typealias ID = String
	
	open var id: ID
	public var cachedView: FlickCardView?
	public var cachedViewController: UIViewController?
	
	public init(id: ID, cardView: FlickCardView? = nil, cardViewController: UIViewController? = nil) {
		self.id = id
		self.cachedViewController = cardViewController
		self.cachedView = cardView
	}
	
	func buildCardView(ofSize size: CGSize) -> FlickCardView {
		let newFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		
		if let cachedController = self.cachedViewController, let view = cachedController.view as? FlickCardView {
			view.bounds = newFrame
			view.card = self
			return view
		}
		
		if let cached = self.cachedView {
			cached.bounds = newFrame
			cached.card = self
			return cached
		}
		
		let view = FlickCardView(frame: newFrame)
		view.card = self
		self.cachedView = view
		return view
	}
}

extension FlickCard {
	open var description: String { return "[\(self.id)]" }
	public static func ==(lhs: FlickCard, rhs: FlickCard) -> Bool {
		return lhs.id == rhs.id
	}
}
