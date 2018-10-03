//
//  UIView+Liftable.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

protocol LiftableView { }
public protocol ShadowedLiftableView {
	var maximumLiftedShadowWidth: CGFloat { get }
	var minimumLiftedShadowWidth: CGFloat { get }
}

extension UIView: LiftableView {
	static var maximumLiftedShadowWidth: CGFloat = 5
	static var minimumLiftedShadowWidth: CGFloat = 0

	public var percentageLifted: CGFloat {
		set {
			let maxWidth = (self as? ShadowedLiftableView)?.maximumLiftedShadowWidth ?? UIView.maximumLiftedShadowWidth
			let minWidth = (self as? ShadowedLiftableView)?.minimumLiftedShadowWidth ?? UIView.minimumLiftedShadowWidth
			let radius = UIView.minimumLiftedShadowWidth + (maxWidth - minWidth) * newValue
			self.layer.shadowColor = UIColor.black.cgColor
			self.layer.shadowOpacity = Float(min(1.0, self.percentageLifted + 0.2))
			self.layer.shadowRadius = radius
			self.layer.shadowOffset = CGSize(width: radius, height: radius)
		}
		
		get {
			let minWidth = (self as? ShadowedLiftableView)?.minimumLiftedShadowWidth ?? UIView.minimumLiftedShadowWidth
			let maxWidth = (self as? ShadowedLiftableView)?.maximumLiftedShadowWidth ?? UIView.maximumLiftedShadowWidth
			return min(1, (self.layer.shadowRadius - minWidth) / (maxWidth - UIView.minimumLiftedShadowWidth))
		}
	}
	
	func transformForAnimation(in parent: FlickCardPileViewController, location pt: CGPoint) {
		let angle = pt.x > parent.view.bounds.midX ? parent.maxDragRotation : -parent.maxDragRotation
		self.transform = CGAffineTransform(rotationAngle: angle)
		self.percentageLifted = 1.0
	}
}

extension UIView {
	var heightConstraint: NSLayoutConstraint {
		if let constraint = self.dimensionConstraint(for: .height) { return constraint }
		let constraint = self.heightAnchor.constraint(equalToConstant:  self.bounds.height)
		constraint.isActive = true
		constraint.priority = UILayoutPriority(1000)
		return constraint
	}

	var widthConstraint: NSLayoutConstraint {
		if let constraint = self.dimensionConstraint(for: .width) { return constraint }
		let constraint = self.widthAnchor.constraint(equalToConstant: self.bounds.width)
		constraint.isActive = true
		constraint.priority = UILayoutPriority(1000)
		return constraint
	}
	
	func dimensionConstraint(for attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
		for constraint in self.constraints {
			if constraint.firstAttribute == attribute, constraint.firstItem === self, constraint.secondItem == nil {
				return constraint
			}
		}
		return nil
	}
}

extension CGPoint {
	var magnitudeFromOrigin: CGFloat {
		return sqrt(self.x * self.x + self.y * self.y)
	}
	
	func distance(to other: CGPoint) -> CGFloat {
		return sqrt(pow(other.x - self.x, 2) + pow(other.y - self.y, 2))
	}
}

extension UIPanGestureRecognizer {
	var isMovingOffscreen: Bool {
		guard let view = self.view else { return true }
		let velocity = self.velocity(in: self.view)
		let delta = self.translation(in: self.view)
		
		
		if velocity == .zero || delta.magnitudeFromOrigin < (view.bounds.width + view.bounds.height) / 10 { return false }
		
		return ((velocity.x >= 0) == (delta.x >= 0)) && ((velocity.y >= 0) == (delta.y >= 0))
	}
}
