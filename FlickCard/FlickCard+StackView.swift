//
//  FlickCard+StackView.swift
//  Bee
//
//  Created by Ben Gottlieb on 9/25/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit

extension FlickCardStackView {
	var parentViewController: UIViewController? {
		var next = self.next
		
		while next != nil {
			if let vc = next as? UIViewController { return vc }
			next = next?.next
		}
		return nil
	}
}

extension FlickCard {
	func willBecomeFrontCard(in stackView: FlickCardStackView, animated: Bool) {
		guard let parent = stackView.parentViewController else { return }
		let controller = self.viewController
		
		controller.willMove(toParent: parent)
		controller.viewWillAppear(animated)
		parent.addChild(controller)
		controller.didMove(toParent: parent)
		controller.viewDidAppear(animated)
	}

	func didResignFrontCard(in stackView: FlickCardStackView, animated: Bool) {
		let controller = self.viewController

		controller.willMove(toParent: nil)
		controller.viewWillDisappear(animated)
		controller.removeFromParent()
		controller.didMove(toParent: nil)
		controller.viewDidDisappear(animated)
	}
}
