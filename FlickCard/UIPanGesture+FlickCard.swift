//
//  UIPanGesture+FlickCard.swift
//  FlickCard
//
//  Created by Ben Gottlieb on 10/3/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit


extension UIPanGestureRecognizer {
	var isMovingOffscreen: Bool {
		guard let view = self.view else { return true }
		let velocity = self.velocity(in: self.view)
		let delta = self.translation(in: self.view)
		
		
		if velocity == .zero || delta.magnitudeFromOrigin < (view.bounds.width + view.bounds.height) / 10 { return false }
		
		return ((velocity.x >= 0) == (delta.x >= 0)) && ((velocity.y >= 0) == (delta.y >= 0))
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

