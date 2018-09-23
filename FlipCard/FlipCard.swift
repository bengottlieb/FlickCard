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
	var cachedCard: CardView?
	
	init(id: ID) {
		self.id = id
	}
	
	func buildCardView(ofSize size: CGSize) -> CardView {
		if let cached = self.cachedCard, cached.bounds.size == size { return cached }
		
		let view = CardView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
		view.card = self
		return view
	}
}

extension FlipCard {
	var description: String { return "[\(self.id)]" }
	static func ==(lhs: FlipCard, rhs: FlipCard) -> Bool {
		return lhs.id == rhs.id
	}
}
