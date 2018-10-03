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
		controller.card = self
	}
	
	func buildCardViewController(ofSize size: CGSize) -> FlickCardViewController {
		let newFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		
		let view = self.viewController.cardView
		self.viewController.card = self
		view.bounds = newFrame
		return self.viewController
	}
}

extension FlickCard {
	public var description: String { return "[\(self.id)]" }
	public static func ==(lhs: FlickCard, rhs: FlickCard) -> Bool {
		return lhs.id == rhs.id
	}
}
