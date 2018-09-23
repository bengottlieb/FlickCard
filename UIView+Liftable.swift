//
//  UIView+Liftable.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

protocol LiftableView {
	var maxShadowWidth: CGFloat { get }
	var minShadowWidth: CGFloat { get }
}

extension UIView: LiftableView {
	var maxShadowWidth: CGFloat { return 5}
	var minShadowWidth: CGFloat { return 1}

	public var percentageLifted: CGFloat {
		set {
			let radius = self.minShadowWidth + (self.maxShadowWidth - self.minShadowWidth) * newValue
			self.layer.shadowRadius = radius
			self.layer.shadowOffset = CGSize(width: radius, height: radius)
		}
		
		get {
			return min(1, (self.layer.shadowRadius - self.minShadowWidth) / (self.maxShadowWidth - self.minShadowWidth))
		}
	}
}
