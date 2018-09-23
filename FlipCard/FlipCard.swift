//
//  FlipCard.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

class FlipCard: CustomStringConvertible, Equatable {
	typealias ID = String
	
	var id: ID
	var cachedView: FlipCardView?
	var cachedViewController: UIViewController?
	
	init(id: ID, cardView: FlipCardView? = nil, cardViewController: UIViewController? = nil) {
		self.id = id
		self.cachedViewController = cardViewController
		self.cachedView = cardView
	}
	
	func buildCardView(ofSize size: CGSize) -> FlipCardView {
		let newFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		
		if let cachedController = self.cachedViewController, let view = cachedController.view as? FlipCardView {
			view.bounds = newFrame
			view.card = self
			return view
		}
		
		if let cached = self.cachedView {
			cached.bounds = newFrame
			cached.card = self
			return cached
		}
		
		let view = FlipCardView(frame: newFrame)
		view.card = self
		self.cachedView = view
		return view
	}
}

extension FlipCard {
	var description: String { return "[\(self.id)]" }
	static func ==(lhs: FlipCard, rhs: FlipCard) -> Bool {
		return lhs.id == rhs.id
	}
}
