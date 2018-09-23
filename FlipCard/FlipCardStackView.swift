//
//  FlipCard.StackView.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

class FlipCardStackView: UIView {
	enum Style { case single, tight, loose, scattered }
	
	let maxDragRotation: CGFloat = 0.2
	let maxDragScale: CGFloat = 1.05
	let dragAcceleration: CGFloat = 1.25
	

	var style: Style = .loose
	var cards: [FlipCard] = [] { didSet { self.updateUI() }}
	var visible: [FlipCard] { return Array(self.cards[0..<(min(self.cards.count, self.numberOfVisibleCards))]) }
	let numberOfVisibleCards = 5
	var cardSize: CGSize { return CGSize(width: self.bounds.size.width * 0.8, height: self.bounds.size.height * 0.8) }
	
	var animator: UIDynamicAnimator!
	var cardViews: [FlipCard.CardView] = []
	var isDragging = false
	var cardsNeedLayout = false
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.postInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.postInit()
	}

	func postInit() {
		self.animator = UIDynamicAnimator(referenceView: self)
	}
	
	func updateUI() {
		let visible = self.visible
		
		for view in self.cardViews {
			if !visible.contains(view.card) { view.removeFromSuperview() }
		}
		
		for card in self.visible {
			if self.view(for: card) == nil {
				let cardView = card.buildCardView(ofSize: self.cardSize)
				self.addSubview(cardView)
				self.cardViews.append(cardView)
			}
		}
		
		for i in 0..<self.cardViews.count {
			let view = self.cardViews[i]
			
			view.gesturesEnabled = i == 0
			if i == 0 {
				self.bringSubviewToFront(view)
			} else {
				self.insertSubview(view, belowSubview: self.cardViews[i - 1])
			}
		}

		self.cardsNeedLayout = true
		self.setNeedsLayout()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		if self.cardsNeedLayout {
			let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
			
			for i in 0..<self.cardViews.count {
				let card = self.cardViews[i].card!
				self.cardViews[i].transform = self.calculateTransform(for: card, at: i)
				self.cardViews[i].center = center
			}
			self.cardsNeedLayout = false
		}
	}
	
	func add(card: FlipCard) {
		self.cards.append(card)
		self.updateUI()
	}
	
	func view(for card: FlipCard) -> FlipCard.CardView? {
		for view in self.cardViews { if view.card == card { return view }}
		return nil
	}
	
	func calculateTransform(for card: FlipCard, at position: Int) -> CGAffineTransform {
		if position == 0 { return .identity }
		
		switch self.style {
		case .single: return .identity
		case .tight:
			return CGAffineTransform(translationX: 0, y: (5 * CGFloat(position)))

		case .loose:
			return CGAffineTransform(rotationAngle: CGFloat(position) * 0.03 * (position % 2 == 0 ? -1 : 1))

		case .scattered:
			return CGAffineTransform(rotationAngle: CGFloat(position) * 0.1 * (position % 2 == 0 ? -1 : 1))

		}
		
	}
}
