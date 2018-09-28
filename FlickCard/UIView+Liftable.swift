//
//  UIView+Liftable.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

protocol LiftableView { }

extension UIView: LiftableView {
	static var maximumLiftedShadowWidth: CGFloat = 5
	static var minimumLiftedShadowWidth: CGFloat = 1

	public var percentageLifted: CGFloat {
		set {
			let radius = UIView.minimumLiftedShadowWidth + (UIView.maximumLiftedShadowWidth - UIView.minimumLiftedShadowWidth) * newValue
			self.layer.shadowColor = UIColor.black.cgColor
			self.layer.shadowOpacity = Float(min(1.0, self.percentageLifted + 0.2))
			self.layer.shadowRadius = radius
			self.layer.shadowOffset = CGSize(width: radius, height: radius)
		}
		
		get {
			return min(1, (self.layer.shadowRadius - UIView.minimumLiftedShadowWidth) / (UIView.maximumLiftedShadowWidth - UIView.minimumLiftedShadowWidth))
		}
	}
}
