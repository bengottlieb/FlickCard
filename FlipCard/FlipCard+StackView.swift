//
//  FlipCard+StackView.swift
//  Bee
//
//  Created by Ben Gottlieb on 9/25/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit

extension FlipCardStackView {
	var parentViewController: UIViewController? {
		var next = self.next
		
		while next != nil {
			if let vc = next as? UIViewController { return vc }
			next = next?.next
		}
		return nil
	}
}

extension FlipCard {
	func willBecomeFrontCard(in stackView: FlipCardStackView, animated: Bool) {
		guard let controller = self.cachedViewController, let parent = stackView.parentViewController else { return }
		
		controller.willMove(toParent: parent)
		controller.viewWillAppear(animated)
		parent.addChild(controller)
		controller.didMove(toParent: parent)
		controller.viewDidAppear(animated)
	}

	func didResignFrontCard(in stackView: FlipCardStackView, animated: Bool) {
		guard let controller = self.cachedViewController else { return }
		
		controller.willMove(toParent: nil)
		controller.viewWillDisappear(animated)
		controller.removeFromParent()
		controller.didMove(toParent: nil)
		controller.viewDidDisappear(animated)
	}
}
