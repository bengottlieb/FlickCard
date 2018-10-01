//
//  FlickCardViewController.swift
//  FlickCard
//
//  Created by Ben Gottlieb on 10/1/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

open class FlickCardViewController: UIViewController {
	public var cardView: FlickCardView { return self.view as! FlickCardView }
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		self.cardView.cardController = self
	}

	public func makeFullScreen(in controller: UIViewController, duration: TimeInterval = 0) {
		self.cardView.stackView?.state = .animatingTopCardIn
		let startingFrame = self.view.convert(self.view.bounds, to: controller.view)
	//	let finalFrame = controller.view.convert(controller.view.bounds, to: self.view.superview)
		self.willMove(toParent: controller)
		controller.view.addSubview(self.view)
		controller.addChild(self)
		self.view.frame = startingFrame
		
		DispatchQueue.main.async {
			UIView.animate(withDuration: duration, animations: {
				self.view.frame = controller.view.bounds// finalFrame
			}) { _ in
				self.view.frame = controller.view.bounds
				controller.view.addSubview(self.view)
				self.didMove(toParent: controller)
			}
		}
	}
}
