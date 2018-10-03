//
//  FlickCardContainerViewController.swift
//  FlickCard
//
//  Created by Ben Gottlieb on 10/2/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

open class FlickCardContainerViewController: UIViewController {
	public enum State { case idle, addingCards, draggingTopCard, animatingTopCardOut, animatingTopCardIn, zoomingCard }
	
	public func applyCardStyling(to cardView: UIView?) { }
	open var state: State = .idle
	
	public func targetView(for card: FlickCardController) -> UIView? { return nil }
	public func restore(_ card: FlickCardController, in targetView: UIView) { }

	public var cardCornerRadius: CGFloat = 10
	public var cardBorderWidth: CGFloat = 1
	public var cardBorderColor: UIColor = .black
}


