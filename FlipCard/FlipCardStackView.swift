//
//  FlipCard.StackView.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

open class FlipCardStackView: UIView {
	public enum Arrangment { case single, tight, loose, scattered, tiered(CGFloat) }
	
	public var maxDragRotation: CGFloat = 0.2
	public var maxDragScale: CGFloat = 1.05
	public var dragAcceleration: CGFloat = 1.25
	public var returnFlickedCardsToBackOfStack = true
	public var arrangement: Arrangment = .tiered(15) { didSet { self.updateUI() }}
	public var numberOfVisibleCards = 5 { didSet { self.updateUI() }}
	public var cards: [FlipCard] = []
	open var cardSize: CGSize { return CGSize(width: self.bounds.size.width * 0.8, height: self.bounds.size.height * 0.8) }
	
	var visible: [FlipCard] { return Array(self.cards[0..<(min(self.cards.count, self.numberOfVisibleCards))]) }
	
	var cardViews: [FlipCardView] = []
	var isDragging = false
	var cardsNeedLayout = false
	
	func updateUI() {
		let visible = self.visible
		
		for view in self.cardViews {
			if view.card == nil || !visible.contains(view.card) {
				view.removeFromSuperview()
				if let index = self.cardViews.index(of: view) { self.cardViews.remove(at: index) }
			}
		}
		
		for card in self.visible {
			if self.view(for: card) == nil {
				let cardView = card.buildCardView(ofSize: self.cardSize)
				cardView.transform = self.calculateTransform(for: card, at: self.cardViews.count)
				cardView.alpha = self.calculateAlpha(for: card, at: self.cardViews.count)
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
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		if self.cardsNeedLayout {
			let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
			let firstIndex = self.isDragging ? 1 : 0
			
			if firstIndex < self.cardViews.count {
				for i in firstIndex..<self.cardViews.count {
					let card = self.cardViews[i].card!
					self.cardViews[i].transform = self.calculateTransform(for: card, at: i - firstIndex)
					self.cardViews[i].alpha = self.calculateAlpha(for: card, at: i - firstIndex)
					self.cardViews[i].center = center
				}
			}
			self.cardsNeedLayout = false
		}
	}
	
	func startDragging(card: FlipCard) {
		self.isDragging = true
		self.updateUI()
		UIView.animate(withDuration: 0.1) {
			self.layoutIfNeeded()
		}
	}
	
	func finishDragging(card: FlipCard, removed: Bool) {
		if removed {
			if self.returnFlickedCardsToBackOfStack {
				if let index = self.cards.index(of: card) { self.cards.remove(at: index) }
				self.cards.append(card)
			} else {
				self.remove(card: card)
			}
		}
		self.isDragging = false
		DispatchQueue.main.async { self.updateUI() }
	}
	
	func add(card: FlipCard) {
		if self.cards.contains(card) { return }
		self.cards.append(card)
		self.updateUI()
	}
	
	func remove(card: FlipCard) {
		if let index = self.cards.index(of: card) { self.cards.remove(at: index) }
		if let cardView = self.view(for: card) {
			cardView.removeFromSuperview()
		}
	}
	
	func view(for card: FlipCard) -> FlipCardView? {
		for view in self.cardViews { if view.card == card { return view }}
		return nil
	}
	
	func calculateAlpha(for card: FlipCard, at position: Int) -> CGFloat {
		switch self.arrangement {
		case .tiered(_):
			return 1.0 - CGFloat(position) * 0.2
			
		default:
			return 1
		}
	}
	
	func calculateTransform(for card: FlipCard, at position: Int) -> CGAffineTransform {
		if position == 0 { return .identity }
		
		let seed = card.id.hashValue % 10
		
		switch self.arrangement {
		case .single: return .identity
		case .tight:
			return CGAffineTransform(translationX: 0, y: (5 * CGFloat(position)))

		case .loose:
			return CGAffineTransform(rotationAngle: CGFloat(seed) * 0.015 * (seed % 2 == 0 ? -1 : 1))

		case .scattered:
			return CGAffineTransform(rotationAngle: CGFloat(seed) * 0.05 * (seed % 2 == 0 ? -1 : 1))

		case .tiered(let offset):
			let factor = 1.0 - CGFloat(position) * 0.05
			let scale = CGAffineTransform(scaleX: factor, y: factor)
			let translate = CGAffineTransform(translationX: 0, y: CGFloat(position) * offset / factor)
			return translate.concatenating(scale)
		}
		
	}
}
