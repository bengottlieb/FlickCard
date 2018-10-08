//
//  FlickCardContainerViewController.swift
//  FlickCard
//
//  Created by Ben Gottlieb on 10/2/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

open class FlickCardContainerViewController: FlickCardController {
	public enum FlipDirection: Int { case fromRight, fromLeft, fromTop, fromBottom
		var animationOptions: UIView.AnimationOptions {
			switch self {
			case .fromRight: return .transitionFlipFromRight
			case .fromLeft: return .transitionFlipFromLeft
			case .fromTop: return .transitionFlipFromTop
			case .fromBottom: return .transitionFlipFromBottom
			}
		}
	}
	public enum State { case idle, addingCards, draggingTopCard, animatingTopCardOut, animatingTopCardIn, zoomingCard }
	public internal(set) var cards: [FlickCardController] = []
	public var avoidKeyboard = false { didSet { if self.avoidKeyboard != oldValue { self.updateKeyboardNotifications() }}}

	public func applyCardStyling(to cardView: UIView?) { }
	open var state: State = .idle
	var cardsNeedLayout = false
	public func flip(card: FlickCardController, overTo flipside: FlickCardController, duration: TimeInterval = 0.2, direction: FlipDirection? = nil, completion: (() -> Void)? = nil) { }
	
	public func targetViewAndFrame(for card: FlickCardController) -> (UIView, CGRect)? { return nil }
	public func restore(_ card: FlickCardController, in targetView: UIView) { }
	open func load(cards: [FlickCardController], animated: Bool = false) {
		for card in cards {
			card.containerController = self
		}
		self.cards = cards
	}

	public var cardCornerRadius: CGFloat = 10
	public var cardBorderWidth: CGFloat = 1
	public var cardBorderColor: UIColor = .black
	
	var contentView: UIView { return self.view }
	var keyboardInsets = UIEdgeInsets.zero

	func updateKeyboardNotifications() {
		if self.avoidKeyboard {
			NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		}
	}
	
	@objc func keyboardFrameChanged(note: Notification) {
		guard self.view.window != nil, let keyboardFrame = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
			self.contentView.setNeedsLayout()
			self.keyboardInsets = .zero
			UIView.animate(withDuration: 0.2) {
				self.contentView.layoutIfNeeded()
			}
			return
		}
		let fieldFrame = self.contentView.bounds//.insetBy(dx: 0, dy: -10)
		let finalFrame = self.contentView.convert(keyboardFrame, from: UIScreen.main.coordinateSpace)
		let intersection = finalFrame.intersection(fieldFrame)
		let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
		
		self.keyboardInsets.bottom = intersection.height
		self.cardsNeedLayout = true
		UIView.animate(withDuration: duration) {
			self.contentView.layoutIfNeeded()
		}
		
	}
	

}


