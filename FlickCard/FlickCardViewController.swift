//
//  FlickCardViewController.swift
//  FlickCard
//
//  Created by Ben Gottlieb on 10/1/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

open class FlickCardViewController: UIViewController {
	public var cardView: FlickCardView { return self.view as! FlickCardView }
	var originalFrame: CGRect?
	var isZoomedToFullScreen: Bool { return self.originalFrame != nil }
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		self.cardView.cardController = self
	}
	
	public func returnToStackview(in controller: UIViewController, duration: TimeInterval = 0, concurrentAnimations: (() -> Void)? = nil) {
		guard let stackView = self.cardView.stackView, let finalFrame = self.originalFrame else { return }

		self.willMove(toParent: controller)
		
		DispatchQueue.main.async {
			UIView.animate(withDuration: duration, animations: {
				self.view.frame = stackView.convert(finalFrame, to: self.view.superview)
				concurrentAnimations?()
				self.view.layer.cornerRadius = FlickCardView.cornerRadius
				self.view.layoutIfNeeded()
			}) { _ in
				controller.addChild(self)
				stackView.addSubview(self.view)
				self.view.frame = finalFrame
				self.didMove(toParent: controller)
				self.cardView.stackView?.state = .idle
				self.originalFrame = nil
			}
		}
	}

	public func makeFullScreen(in controller: UIViewController, duration: TimeInterval = 0, concurrentAnimations: (() -> Void)? = nil) {
		self.cardView.stackView?.state = .zoomingCard
		self.originalFrame = self.view.frame
		let startingFrame = self.view.convert(self.view.bounds, to: controller.view)
		self.willMove(toParent: controller)
		controller.view.addSubview(self.view)
		controller.addChild(self)
		self.view.frame = startingFrame
		
		DispatchQueue.main.async {
			UIView.animate(withDuration: duration, animations: {
				self.view.frame = controller.view.bounds// finalFrame
				self.view.layer.cornerRadius = 0
				concurrentAnimations?()
				self.view.layoutIfNeeded()
			}) { _ in
				self.view.frame = controller.view.bounds
				controller.view.addSubview(self.view)
				self.didMove(toParent: controller)
				self.cardView.stackView?.state = .idle
			}
		}
	}
}
