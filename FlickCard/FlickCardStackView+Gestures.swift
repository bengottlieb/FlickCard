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
		guard let cardView = self.cardViews.first else { return }
		
		switch recog.state {
		case .began:
			let window = self.window
			if let root = window?.rootViewController?.view, let dragged = cardView.snapshotView(afterScreenUpdates: false) {
				let center = root.convert(cardView.center, from: self)
				cardView.isHidden = true
				root.addSubview(dragged)
				dragged.center = center
				self.draggingView = dragged
				self.dragStartPoint = center
			} else {
				self.draggingView = cardView
				self.dragStartPoint = cardView.center
			}
			self.startDragging(card: cardView.card)
			
		case .changed:
			guard let dragging = self.draggingView else { return }
			let liftDistance: CGFloat = 20
			let delta = recog.translation(in: self)
			let dragDistance = delta.magnitudeFromOrigin
			let maxDragScaleBoost = self.maxDragScale - 1.0
			dragging.percentageLifted = (dragDistance / liftDistance)
			
			
			let centerOnScreen = self.convert(dragging.center, to: nil)
			var rotation = min(abs(delta.x / (self.bounds.width * 1.5)), self.maxDragRotation)
			var scaleBoost = min(1, ((delta.magnitudeFromOrigin * 5) / centerOnScreen.magnitudeFromOrigin)) * maxDragScaleBoost
			
			if delta.x < 0 { rotation *= -1 }
			if delta.y > 0 { scaleBoost = 0 }
			dragging.center = CGPoint(x: self.dragStartPoint.x + delta.x * self.dragAcceleration, y: self.dragStartPoint.y + delta.y * self.dragAcceleration)
			dragging.transform = CGAffineTransform(rotationAngle: rotation).scaledBy(x: scaleBoost + 1, y: scaleBoost + 1)
			
		case .ended, .cancelled, .failed:
			self.finishFlick(with: recog)
			
		default: break
		}
	}
	
	func finishFlick(with recog: UIPanGestureRecognizer) {
		guard let cardView = self.cardViews.first, let card = cardView.card, let dragged = self.draggingView else {
			return
		}
		if recog.isMovingOffscreen {
			let maxDuration: CGFloat = 0.5
			let current = self.center
			let velocity = recog.velocity(in: self)
			let speed = velocity.magnitudeFromOrigin * 0.5
			let distance = sqrt(pow(self.bounds.width, 2) + pow(self.bounds.height, 2)) * 2.5
			var duration = distance/speed
			var destination = CGPoint(x: current.x + velocity.x * duration, y: current.y + velocity.y * duration)
			
			if duration > maxDuration && duration < maxDuration {
				let factor = maxDuration / duration
				destination = CGPoint(x: current.x + velocity.x * duration * factor, y: current.y + velocity.y * duration * factor)
				duration = maxDuration
			}
			
			self.finishDragging(card: cardView.card, to: destination, removed: true)
			self.animatingCardView = cardView
			UIView.animate(withDuration: TimeInterval(duration), delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseOut], animations: {
				dragged.center = destination
			}) { _ in
				self.animatingCardView = nil
				if self.returnFlickedCardsToBackOfStack {
					dragged.alpha = 0.5
					UIView.animate(withDuration: 0.2, animations: {
						self.sendSubviewToBack(cardView)
						cardView.center = self.dragStartPoint
						cardView.transform = .identity
						cardView.percentageLifted = 0
					}, completion: { _ in
						dragged.removeFromSuperview()
						if dragged === self.draggingView { self.draggingView = nil }
						cardView.removeFromSuperview()
						cardView.alpha = 1.0
						self.addReturnedCard(cardView.card)
					})
				} else {
					cardView.removeFromSuperview()
					self.didRemove(card: card, to: destination, viaFlick: true)
					dragged.removeFromSuperview()
					if dragged === self.draggingView { self.draggingView = nil }
				}
			}
		} else {
			let distance = self.dragStartPoint.distance(to: cardView.center)
			let time = min(distance / recog.velocity(in: self).distance(to: .zero), 0.2)
			UIView.animate(withDuration: TimeInterval(time), animations: {
				dragged.center = self.dragStartPoint
				dragged.transform = .identity
				dragged.percentageLifted = 0
			}) { _ in
				if cardView != dragged {
					let center = self.convert(dragged.center, from: dragged.superview)
					cardView.center = center
					cardView.isHidden = false
					dragged.removeFromSuperview()
					if dragged === self.draggingView { self.draggingView = nil }
				}
				self.finishDragging(card: cardView.card, to: nil, removed: false)
			}
		}
	}

}

