//
//  FlickCardViewController.swift
//  FlickCard
//
//  Created by Ben Gottlieb on 10/1/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

open class FlickCardViewController: UIViewController {
	public typealias ID = String
	
	open var id: ID!

	public var cardView: FlickCardView { return self.view as! FlickCardView }
	public var listViewHeight: CGFloat? { return nil }

	var originalFrame: CGRect?
	var isZoomedToFullScreen: Bool { return self.originalFrame != nil }
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		self.cardView.cardController = self
	}
	
	public func returnToParentView(duration: TimeInterval = 0, concurrentAnimations: (() -> Void)? = nil) {
		guard let parent = (self.parent as? FlickCardParentViewController), let targetView = parent.targetView(for: self), let finalFrame = self.originalFrame else { return }

		self.willMove(toParent: parent)
		self.view.heightConstraint.constant = finalFrame.height
		self.view.widthConstraint.constant = finalFrame.width

		UIView.animate(withDuration: duration, animations: {
			self.view.frame = targetView.convert(finalFrame, to: self.view.superview)
			concurrentAnimations?()
			parent.applyCardStyling(to: self.cardView)
			self.view.layoutIfNeeded()
		}) { _ in
			parent.restore(self, in: targetView)
			self.originalFrame = nil
		}
	}

	public func makeFullScreen(in controller: UIViewController, duration: TimeInterval = 0, concurrentAnimations: (() -> Void)? = nil) {
		self.cardView.cardParentController?.state = .zoomingCard
		self.originalFrame = self.view.frame
		let startingFrame = self.view.convert(self.view.bounds, to: controller.view)
		self.willMove(toParent: controller)
		controller.view.addSubview(self.view)
		controller.addChild(self)
		self.view.frame = startingFrame
		
		UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.layoutSubviews], animations: {
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: {
				self.view.transform = CGAffineTransform(translationX: 0, y: 20).scaledBy(x: 0.95, y: 0.95)
			})
			UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.9, animations: {
				self.view.heightConstraint.constant = controller.view.bounds.height
				self.view.widthConstraint.constant = controller.view.bounds.width

				self.view.transform = .identity
				self.view.frame = controller.view.bounds
				self.view.layer.cornerRadius = 0
				concurrentAnimations?()
			})
		}) { _ in
			self.view.frame = controller.view.bounds
			controller.view.addSubview(self.view)
			self.didMove(toParent: controller)
			self.cardView.cardParentController?.state = .idle
		}
	}
}
