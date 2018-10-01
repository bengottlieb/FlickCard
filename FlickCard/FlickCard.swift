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
	public var viewController: FlickCardViewController
	
	public init(id: ID, controller: FlickCardViewController) {
		self.id = id
		self.viewController = controller
	}
	
	func buildCardView(ofSize size: CGSize) -> FlickCardView {
		let newFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		
		let view = self.viewController.cardView
		view.bounds = newFrame
		view.card = self
		return view
	}
}

extension FlickCard {
	public var description: String { return "[\(self.id)]" }
	public static func ==(lhs: FlickCard, rhs: FlickCard) -> Bool {
		return lhs.id == rhs.id
	}
}
