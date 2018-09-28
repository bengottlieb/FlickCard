//
//  FlickCardStackView+Gestures.swift
//  FlickCard
//
//  Created by Ben Gottlieb on 9/27/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import Foundation
import UIKit

extension FlickCardStackView {
	@objc func panned(recog: UIPanGestureRecognizer) {
		let parent = self
		guard let cardView = self.cardViews.first else { return }
		
		switch recog.state {
		case .began:
			let window = self.window
			if let root = window?.rootViewController?.view {
				let frame = root.convert(cardView.bounds, from: self)
				cardView.removeFromSuperview()
				root.addSubview(cardView)
				cardView.frame = frame
			}
			cardView.dragStart = cardView.center
			parent.startDragging(card: cardView.card)
			
		case .changed:
			let liftDistance: CGFloat = 20
			let delta = recog.translation(in: parent)
			let dragDistance = delta.magnitudeFromOrigin
			let maxDragScaleBoost = parent.maxDragScale - 1.0
			cardView.percentageLifted = (dragDistance / liftDistance)
			
			
			let centerOnScreen = parent.convert(cardView.center, to: nil)
			var rotation = min(abs(delta.x / (parent.bounds.width * 1.5)), parent.maxDragRotation)
			var scaleBoost = min(1, ((delta.magnitudeFromOrigin * 5) / centerOnScreen.magnitudeFromOrigin)) * maxDragScaleBoost
			
			if delta.x < 0 { rotation *= -1 }
			if delta.y > 0 { scaleBoost = 0 }
			cardView.center = CGPoint(x: cardView.dragStart.x + delta.x * parent.dragAcceleration, y: cardView.dragStart.y + delta.y * parent.dragAcceleration)
			cardView.transform = CGAffineTransform(rotationAngle: rotation).scaledBy(x: scaleBoost + 1, y: scaleBoost + 1)
			
		case .ended: self.finishFlick(with: recog)
			
		default: break
		}
	}
	
	func finishFlick(with recog: UIPanGestureRecognizer) {
		let parent = self
		guard let cardView = self.cardViews.first, let card = cardView.card else { return }
		if recog.isMovingOffscreen {
			let maxDuration: CGFloat = 0.5
			let current = self.center
			let velocity = recog.velocity(in: parent)
			let speed = velocity.magnitudeFromOrigin * 0.5
			let distance = sqrt(pow(cardView.bounds.width, 2) + pow(parent.bounds.height, 2)) * 2.5
			var duration = distance/speed
			var destination = CGPoint(x: current.x + velocity.x * duration, y: current.y + velocity.y * duration)
			
			if duration > maxDuration && duration < maxDuration {
				let factor = maxDuration / duration
				destination = CGPoint(x: current.x + velocity.x * duration * factor, y: current.y + velocity.y * duration * factor)
				duration = maxDuration
			}
			
			parent.finishDragging(card: cardView.card, removed: true)
			parent.animatingCardView = cardView
			UIView.animate(withDuration: TimeInterval(duration), delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseOut], animations: {
				cardView.center = destination
			}) { _ in
				parent.animatingCardView = nil
				if parent.returnFlickedCardsToBackOfStack {
					cardView.alpha = 0.5
					UIView.animate(withDuration: 0.2, animations: {
						parent.sendSubviewToBack(cardView)
						cardView.center = cardView.dragStart
						cardView.transform = .identity
						cardView.percentageLifted = 0
					}, completion: { _ in
						cardView.removeFromSuperview()
						cardView.alpha = 1.0
						parent.addReturnedCard(cardView.card)
					})
				} else {
					DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
						cardView.removeFromSuperview()
						parent.didRemove(card: card, to: destination, viaFlick: true)
					}
				}
			}
		} else {
			let distance = cardView.dragStart.distance(to: cardView.center)
			let time = distance / recog.velocity(in: self).distance(to: .zero)
			UIView.animate(withDuration: TimeInterval(time), animations: {
				cardView.center = cardView.dragStart
				cardView.transform = .identity
				cardView.percentageLifted = 0
			}) { _ in
				if cardView.superview != self {
					self.addSubview(cardView)
				}
				parent.finishDragging(card: cardView.card, removed: false)
			}
		}
	}

}

