//
//  FlipCard.View.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

open class FlipCardView: UIView {
	public weak var card: FlipCard!
	
	var stackView: FlipCardStackView? { return self.superview as? FlipCardStackView }
	var panGestureRecognizer: UIPanGestureRecognizer?
	var dragStart = CGPoint.zero

	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.didInit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.didInit()
	}
	
	func didInit() {
		self.layer.cornerRadius = 10
		self.layer.borderColor = UIColor.black.cgColor
		self.layer.borderWidth = 1
		
		self.percentageLifted = 0.0
	}

	var gesturesEnabled: Bool = false {
		didSet {
			self.isUserInteractionEnabled = self.gesturesEnabled
			if self.gesturesEnabled {
				if self.panGestureRecognizer != nil { return }
				
				self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned))
				self.addGestureRecognizer(self.panGestureRecognizer!)
			} else {
				if let pan = self.panGestureRecognizer { self.removeGestureRecognizer(pan) }
				self.panGestureRecognizer = nil
			}
		}
	}
	
	func transformForAnimation(in parent: FlipCardStackView, location pt: CGPoint) {
		let angle = pt.x > parent.bounds.midX ? parent.maxDragRotation : -parent.maxDragRotation
		self.transform = CGAffineTransform(rotationAngle: angle)
		self.percentageLifted = 1.0
	}
	
	@objc func panned(recog: UIPanGestureRecognizer) {
		guard let parent = self.stackView else { return }
		switch recog.state {
		case .began:
			self.dragStart = self.center
			parent.startDragging(card: self.card)

		case .changed:
			let liftDistance: CGFloat = 20
			let delta = recog.translation(in: parent)
			let dragDistance = delta.magnitudeFromOrigin
			let maxDragScaleBoost = parent.maxDragScale - 1.0
			self.percentageLifted = (dragDistance / liftDistance)
			
			
			let centerOnScreen = parent.convert(self.center, to: nil)
			var rotation = min(abs(delta.x / (parent.bounds.width * 1.5)), parent.maxDragRotation)
			var scaleBoost = min(1, ((delta.magnitudeFromOrigin * 5) / centerOnScreen.magnitudeFromOrigin)) * maxDragScaleBoost
			
			if delta.x < 0 { rotation *= -1 }
			if delta.y > 0 { scaleBoost = 0 }
			self.center = CGPoint(x: self.dragStart.x + delta.x * parent.dragAcceleration, y: self.dragStart.y + delta.y * parent.dragAcceleration)
			self.transform = CGAffineTransform(rotationAngle: rotation).scaledBy(x: scaleBoost + 1, y: scaleBoost + 1)

		case .ended: self.finishFlick(with: recog)
			
		default: break
		}
	}
	
	func finishFlick(with recog: UIPanGestureRecognizer) {
		guard let parent = self.stackView, let card = self.card else { return }
		if recog.isMovingOffscreen {
			let maxDuration: CGFloat = 0.5
			let current = self.center
			let velocity = recog.velocity(in: parent)
			let speed = velocity.magnitudeFromOrigin
			let distance = sqrt(parent.bounds.width * parent.bounds.width + parent.bounds.height * parent.bounds.height)
			var duration = distance/speed
			var destination = CGPoint(x: current.x + velocity.x * duration, y: current.y + velocity.y * duration)
			
			if duration > maxDuration {
				let factor = maxDuration / duration
				destination = CGPoint(x: current.x + velocity.x * duration * factor, y: current.y + velocity.y * duration * factor)
				duration = maxDuration
			}
			
			parent.finishDragging(card: self.card, removed: true)
			parent.animatingCardView = self
			UIView.animate(withDuration: TimeInterval(duration), animations: {
				self.center = destination
			}) { _ in
				parent.animatingCardView = nil
				if parent.returnFlickedCardsToBackOfStack {
					self.alpha = 0.5
					UIView.animate(withDuration: 0.2, animations: {
						parent.sendSubviewToBack(self)
						self.center = self.dragStart
						self.transform = .identity
						self.percentageLifted = 0
					}, completion: { _ in
						self.removeFromSuperview()
						self.alpha = 1.0
						parent.addReturnedCard(self.card)
					})
				} else {
					self.removeFromSuperview()
					parent.didRemove(card: card, to: destination, viaFlick: true)
				}
			}
		} else {
			UIView.animate(withDuration: 0.1, animations: {
				self.center = self.dragStart
				self.transform = .identity
				self.percentageLifted = 0
			}) { _ in
				parent.finishDragging(card: self.card, removed: false)
			}
		}
	}
}

extension CGPoint {
	var magnitudeFromOrigin: CGFloat {
		return sqrt(self.x * self.x + self.y * self.y)
	}
}

extension UIPanGestureRecognizer {
	var isMovingOffscreen: Bool {
		guard let view = self.view else { return true }
		let velocity = self.velocity(in: self.view)
		let delta = self.translation(in: self.view)
		
		
		if velocity == .zero || delta.magnitudeFromOrigin < (view.bounds.width + view.bounds.height) / 6 { return false }

		return ((velocity.x >= 0) == (delta.x >= 0)) && ((velocity.y >= 0) == (delta.y >= 0))
	}
}
