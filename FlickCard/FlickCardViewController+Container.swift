//
//  FlickCardViewController+Container.swift
//  Bee
//
//  Created by Ben Gottlieb on 9/25/18.
//  Copyright © 2018 Stand Alone, Inc. All rights reserved.
//

import UIKit

extension FlickCardController {
	func willBecomeFrontCard(in parent: FlickCardPileViewController, animated: Bool) {
		let controller = self
		
		controller.willMove(toParent: parent)
		controller.viewWillAppear(animated)
		parent.addChild(controller)
		controller.didMove(toParent: parent)
		controller.viewDidAppear(animated)
	}

	func didResignFrontCard(in pileView: FlickCardPileViewController, animated: Bool) {
		let controller = self

		controller.willMove(toParent: nil)
		controller.viewWillDisappear(animated)
		controller.removeFromParent()
		controller.didMove(toParent: nil)
		controller.viewDidDisappear(animated)
	}
}
