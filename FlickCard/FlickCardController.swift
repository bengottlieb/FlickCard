//
//  FlickCardController.swift
//  FlickCard
//
//  Created by Ben Gottlieb on 10/1/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

open class FlickCardController: UIViewController {
	public enum FlickDirection { case left, right }
	public typealias ID = String
	
	open var id: ID!

	open var flipsideController: FlickCardController?
	public var listViewHeight: CGFloat? { return nil }

	var containerController: FlickCardContainerViewController?
	var originalFrame: CGRect?
	var zoomContainer: UIView!
	var isZoomedToFullScreen: Bool { return self.view.bounds == self.parent?.view.bounds }
	var animationController: Presenter!
	var isInsideContainer: Bool { return self.parent == self.containerController }
	
	open func resetAfterDragging() { }
	open func shouldUpdateFlickedImageAfterDragging(percentage: CGFloat, direction: FlickDirection) -> Bool { return false }
}
