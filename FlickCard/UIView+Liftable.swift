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
}
