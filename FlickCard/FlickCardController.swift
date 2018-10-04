//
//  FlickCardController.swift
//  FlickCard
//
//  Created by Ben Gottlieb on 10/1/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

open class FlickCardController: UIViewController {
	public typealias ID = String
	
	open var id: ID!

	public var listViewHeight: CGFloat? { return nil }

	var containerController: FlickCardContainerViewController?
	var originalFrame: CGRect?
	var zoomContainer: UIView!
	var isZoomedToFullScreen: Bool { return self.originalFrame != nil }
	var animationController: Presenter!
		
	public func returnToParentView(duration: TimeInterval = 0, concurrentAnimations: (() -> Void)? = nil) {
		guard let parent = (self.parent as? FlickCardContainerViewController), let targetView = parent.targetView(for: self), let finalFrame = self.originalFrame else { return }

		self.willMove(toParent: parent)
		
		UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.layoutSubviews], animations: {
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
				self.zoomContainer.frame = finalFrame
				concurrentAnimations?()
				parent.applyCardStyling(to: self.view)
				self.view.setNeedsLayout()
			})
		}) { _ in
			parent.restore(self, in: targetView)
			self.originalFrame = nil
			self.zoomContainer.removeFromSuperview()
		}
	}

	public func makeFullScreen(in controller: UIViewController, duration: TimeInterval = 0, concurrentAnimations: (() -> Void)? = nil) {
		self.containerController?.state = .zoomingCard
		self.originalFrame = self.view.superview?.convert(self.view.bounds, from: self.view)
		let startingFrame = self.view.convert(self.view.bounds, to: controller.view)
		self.willMove(toParent: controller)
		
		self.originalFrame = startingFrame
		self.zoomContainer = UIView(frame: startingFrame)
		self.view.superview?.addSubview(self.zoomContainer)
		self.zoomContainer.addSubview(self.view)
		controller.view.addSubview(self.zoomContainer)
		controller.addChild(self)
		
		self.view.frame = self.zoomContainer.bounds
		self.view.leadingAnchor.constraint(equalTo: self.zoomContainer.leadingAnchor).isActive = true
		self.view.trailingAnchor.constraint(equalTo: self.zoomContainer.trailingAnchor).isActive = true
		self.view.topAnchor.constraint(equalTo: self.zoomContainer.topAnchor).isActive = true
		self.view.bottomAnchor.constraint(equalTo: self.zoomContainer.bottomAnchor).isActive = true

		UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.layoutSubviews], animations: {
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: {
				self.zoomContainer.transform = CGAffineTransform(translationX: 0, y: 20).scaledBy(x: 0.95, y: 0.95)
			})
			UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.9, animations: {
//				self.view.heightConstraint.constant = controller.view.bounds.height
//				self.view.widthConstraint.constant = controller.view.bounds.width

				self.zoomContainer.transform = .identity
				self.zoomContainer.frame = controller.view.bounds
				self.view.layer.cornerRadius = 0
				concurrentAnimations?()
			})
		}) { _ in
			self.zoomContainer.frame = controller.view.bounds
			self.didMove(toParent: controller)
			self.containerController?.state = .idle
		}
	}
}
