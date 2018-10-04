//
//  FlickCardViewController+Container.swift
//  Bee
//
//  Created by Ben Gottlieb on 9/25/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit

extension FlickCardController {
	func prepareToPresent() {
		self.transitioningDelegate = self
	}
	
	func willBecomeFrontCard(in parent: FlickCardPileViewController, animated: Bool) {
		let controller = self
		
		controller.willMove(toParent: parent)
		controller.viewWillAppear(animated)
		parent.addChild(controller)
		controller.didMove(toParent: parent)
		controller.viewDidAppear(animated)
	}

	func didResignFrontCard(in pileView: FlickCardPileViewController, animated: Bool) {
		let controller = self

		controller.willMove(toParent: nil)
		controller.viewWillDisappear(animated)
		controller.removeFromParent()
		controller.didMove(toParent: nil)
		controller.viewDidDisappear(animated)
	}
}

extension FlickCardController: UIViewControllerTransitioningDelegate {
	public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		
		if self.animationController == nil { self.animationController = Presenter(forDismissing: false) }
		
		self.animationController.dismissing = false
		return self.animationController
	}
	
	public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		if self.animationController == nil { self.animationController = Presenter(forDismissing: false) }

		self.animationController.dismissing = true
		return self.animationController
	}
	
	class Presenter: NSObject, UIViewControllerAnimatedTransitioning {
		func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
			return 0.2
		}
		
		var zoomContainer: UIView!
		
		var dismissing = false
		init(forDismissing: Bool) {
			super.init()
			self.dismissing = forDismissing
		}
		
		func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
			let containerView = transitionContext.containerView
			let duration = self.transitionDuration(using: transitionContext)

			if self.dismissing {
				guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
				var destination = toVC
				if let nav = toVC as? UINavigationController { destination = nav.viewControllers.first! }
				guard let parent = destination as? FlickCardContainerViewController, let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? FlickCardController, let zoomContainer = self.zoomContainer else {
						return
				}				
				
				guard let targetView = parent.targetView(for: fromVC) else { return }
				
				containerView.insertSubview(toVC.view, at: 0)
				let finalFrame = targetView.convert(targetView.bounds, to: containerView)
				
				UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.layoutSubviews], animations: {
					UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
						zoomContainer.frame = finalFrame
						parent.applyCardStyling(to: fromVC.view)
					})
				}) { _ in
					transitionContext.completeTransition(true)
					parent.restore(fromVC, in: targetView)
				}
			} else {
				guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? FlickCardController else {
						return
				}
				
				let frame = toVC.view.convert(toVC.view.bounds, to: containerView)
				self.zoomContainer = UIView(frame: frame)
				
				toVC.view.frame = self.zoomContainer.bounds
				self.zoomContainer.addSubview(toVC.view)

				containerView.addSubview(self.zoomContainer)
				self.zoomContainer.leadingAnchor.constraint(equalTo: toVC.view.leadingAnchor).isActive = true
				self.zoomContainer.trailingAnchor.constraint(equalTo: toVC.view.trailingAnchor).isActive = true
				self.zoomContainer.topAnchor.constraint(equalTo: toVC.view.topAnchor).isActive = true
				self.zoomContainer.bottomAnchor.constraint(equalTo: toVC.view.bottomAnchor).isActive = true
				
				
				UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.layoutSubviews], animations: {
					UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
						self.zoomContainer.frame = containerView.bounds
					})
				}) { _ in
					transitionContext.completeTransition(true)
				}
				
//				UIView.animate(withDuration: duration * 10, animations: {
//					toVC.view.frame = containerView.bounds
//					toVC.view.setNeedsLayout()
//				}) { _ in
//					transitionContext.completeTransition(true)
//				}
			}
		}
	}
	
}

