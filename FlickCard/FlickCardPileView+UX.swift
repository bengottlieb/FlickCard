//
//  FlickCardPileView+Gestures.swift
//  FlickCard
//
//  Created by Ben Gottlieb on 9/27/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import Foundation
import UIKit

extension FlickCardPileViewController {
	@objc func panned(recog: UIPanGestureRecognizer) {
		guard let cardViewController = self.cardViewControllers.first else { return }
		let cardView = cardViewController.cardView
		
		switch recog.state {
		case .began:
			let window = self.view.window
			if let root = window?.rootViewController?.view, let dragged = cardView.snapshotView(afterScreenUpdates: false) {
				let center = root.convert(cardView.center, from: self.pileView)
				cardView.isHidden = true
				root.addSubview(dragged)
				dragged.center = center
				self.draggingView = dragged
				self.dragStartPoint = center
			} else {
				self.draggingView = cardView
				self.dragStartPoint = cardView.center
			}
			self.startDragging(card: cardViewController.card)
			
		case .changed:
			guard let dragging = self.draggingView else { return }
			let liftDistance: CGFloat = 20
			let delta = recog.translation(in: self.pileView)
			let dragDistance = delta.magnitudeFromOrigin
			let maxDragScaleBoost = self.maxDragScale - 1.0
			dragging.percentageLifted = (dragDistance / liftDistance)
			
			
			let centerOnScreen = self.pileView.convert(dragging.center, to: nil)
			var rotation = min(abs(delta.x / (self.pileView.bounds.width * 1.5)), self.maxDragRotation)
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
		guard let cardViewController = self.cardViewControllers.first, let card = cardViewController.card, let dragged = self.draggingView else {
			return
		}
		
		let cardView = cardViewController.cardView
		if recog.isMovingOffscreen {
			let maxDuration: CGFloat = 0.5
			let current = self.pileView.center
			let velocity = recog.velocity(in: self.pileView)
			let speed = velocity.magnitudeFromOrigin * 0.5
			let distance = sqrt(pow(self.pileView.bounds.width, 2) + pow(self.pileView.bounds.height, 2)) * 2.5
			var duration = distance/speed
			var destination = CGPoint(x: current.x + velocity.x * duration, y: current.y + velocity.y * duration)
			
			if duration > maxDuration && duration < maxDuration {
				let factor = maxDuration / duration
				destination = CGPoint(x: current.x + velocity.x * duration * factor, y: current.y + velocity.y * duration * factor)
				duration = maxDuration
			}
			
			self.finishDragging(card: cardViewController.card, to: destination, removed: true)
			self.animatingCardView = cardView
			UIView.animate(withDuration: TimeInterval(duration), delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseOut], animations: {
				dragged.center = destination
			}) { _ in
				self.animatingCardView = nil
				if self.returnFlickedCardsToBackOfPile {
					dragged.alpha = 0.5
					UIView.animate(withDuration: 0.2, animations: {
						self.pileView.sendSubviewToBack(cardView)
						cardView.center = self.dragStartPoint
						cardView.transform = .identity
						cardView.percentageLifted = 0
					}, completion: { _ in
						dragged.removeFromSuperview()
						if dragged === self.draggingView { self.draggingView = nil }
						cardView.removeFromSuperview()
						cardView.alpha = 1.0
						self.addReturnedCard(cardViewController.card)
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
			let time = min(distance / recog.velocity(in: self.pileView).distance(to: .zero), 0.2)
			UIView.animate(withDuration: TimeInterval(time), animations: {
				dragged.center = self.dragStartPoint
				dragged.transform = .identity
				dragged.percentageLifted = 0
			}) { _ in
				if cardView != dragged {
					let center = self.pileView.convert(dragged.center, from: dragged.superview)
					cardView.center = center
					cardView.isHidden = false
					dragged.removeFromSuperview()
					if dragged === self.draggingView { self.draggingView = nil }
				}
				self.finishDragging(card: cardViewController.card, to: nil, removed: false)
			}
		}
	}

	func updateKeyboardNotifications() {
		if self.avoidKeyboard {
			NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		}
	}
	
	@objc func keyboardFrameChanged(note: Notification) {
		guard let keyboardFrame = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
			self.pileView.setNeedsLayout()
			self.keyboardInsets = .zero
			UIView.animate(withDuration: 0.2) {
				self.pileView.layoutIfNeeded()
			}
			return
		}
		let fieldFrame = self.pileView.frame//.insetBy(dx: 0, dy: -10)
		let finalFrame = self.pileView.convert(keyboardFrame, from: UIScreen.main.coordinateSpace)
		let intersection = finalFrame.intersection(fieldFrame)
		let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
		
		self.keyboardInsets.bottom = intersection.height
		self.cardsNeedLayout = true
		UIView.animate(withDuration: duration) {
			self.pileView.layoutIfNeeded()
		}

	}
	
	var firstCardFrame: CGRect {
		let total = UIEdgeInsets(top: self.cardInset.top + self.keyboardInsets.top, left: self.cardInset.left + self.keyboardInsets.left, bottom: self.cardInset.bottom + self.keyboardInsets.bottom, right: self.cardInset.right + self.keyboardInsets.right)
		let size = CGSize(width: self.pileView.bounds.size.width - (total.left + total.right), height: self.pileView.bounds.size.height - (total.top + total.bottom))
		
		return CGRect(x: total.left, y: total.top, width: size.width, height: size.height)
	}
}

