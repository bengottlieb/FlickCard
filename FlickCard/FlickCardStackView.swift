//
//  FlickCard.StackView.swift
//  Cards
//
//  Created by Ben Gottlieb on 9/22/18.
//  Copyright © 2018 Ben Gottlieb. All rights reserved.
//

import UIKit

public protocol FlickCardStackViewDelegate: class {
	func willRemove(card: FlickCard, to: CGPoint?, viaFlick: Bool)
	func didRemove(card: FlickCard, to: CGPoint?, viaFlick: Bool)
	func willRemoveLastCard()
	func didRemoveLastCard()
}

open class FlickCardStackView: UIView {
	public enum Arrangment { case single, tight, loose, scattered, tiered(offset: CGFloat, alphaStep: CGFloat) }
	public enum State { case idle, addingCards, draggingTopCard, animatingTopCardOut, animatingTopCardIn }
	
	public var maxDragRotation: CGFloat = 0.2
	public var maxDragScale: CGFloat = 1.05
	public var dragAcceleration: CGFloat = 1.25
	public var returnFlickedCardsToBackOfStack = false
	public var arrangement: Arrangment = .tiered(offset: -20, alphaStep: 0.05) { didSet { self.updateUI() }}
	public var numberOfVisibleCards = 5 { didSet { self.updateUI() }}
	public private(set) var cards: [FlickCard] = []
	open var cardSize: CGSize { return CGSize(width: self.bounds.size.width - (self.cardSizeInset.left + self.cardSizeInset.right), height: self.bounds.size.height - (self.cardSizeInset.top + self.cardSizeInset.bottom)) }
	public weak var delegate: FlickCardStackViewDelegate?
	open var defaultCardCenter: CGPoint { return CGPoint(x: self.bounds.midX, y: self.bounds.midY) }
	open var state: State = .idle
	var cardSizeInset = UIEdgeInsets.zero
	
	var draggingView: UIView!
	var dragStartPoint = CGPoint.zero
	
	var visible: [FlickCard] { return Array(self.cards[0..<(min(self.cards.count, self.numberOfVisibleCards))]) }
	
	var cardViews: [FlickCardView] = []
	var panGestureRecognizer: UIPanGestureRecognizer!
	var cardsNeedLayout = false
	var firstCardIsInteracting: Bool { return self.state == .draggingTopCard }
	weak var animatingCardView: UIView?
	weak var lastFrontCard: FlickCard?
	var topCard: FlickCard? { return self.cards.first }
	
	func load(cards: [FlickCard], animated: Bool = false) {
		if animated {
			for card in cards {
				self.add(card: card, toTop: false, animated: true, from: nil, duration: 0.2) { }
			}
		} else {
			self.cards += cards
			self.updateUI()
		}
	}
	
	
	func updateUI() {
		let visible = self.visible
		
		for view in self.cardViews {
			if view.card == nil || !visible.contains(view.card) {
				view.removeFromSuperview()
				if let index = self.cardViews.index(of: view) { self.cardViews.remove(at: index) }
			}
		}
		
		self.cardViews = self.visible.map { card in
			if let view = self.view(for: card ) { return view }
			let cardView = card.buildCardView(ofSize: self.cardSize)
			self.addSubview(cardView)
			return cardView
		}
		
		self.gesturesEnabled = self.cards.count > 0
		for i in 0..<self.visible.count {
			guard let view = self.view(for: self.cards[i]) else { continue }
			
			if i == 0 {
				self.bringSubviewToFront(view)
			} else {
				view.removeFromSuperview()
				self.insertSubview(view, belowSubview: self.cardViews[i - 1])
			}
		}

		self.cardsNeedLayout = true
		self.setNeedsLayout()
		
		let frontCard = self.cardViews.first?.card
		if !self.firstCardIsInteracting {
			if frontCard != self.lastFrontCard {
				self.lastFrontCard?.didResignFrontCard(in: self, animated: true)
				frontCard?.willBecomeFrontCard(in: self, animated: true)
				self.lastFrontCard = frontCard
			}
		}
	}
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		if self.cardsNeedLayout {
			let center = self.defaultCardCenter
			let firstIndex = self.firstCardIsInteracting ? 1 : 0
			
			if firstIndex < self.cardViews.count {
				for i in firstIndex..<self.cardViews.count {
					let card = self.cardViews[i].card!
					if self.cardViews[i] == self.animatingCardView { continue }
					self.cardViews[i].transform = self.calculateTransform(for: card, at: i - firstIndex)
					self.cardViews[i].alpha = self.calculateAlpha(for: card, at: i - firstIndex)
					self.cardViews[i].center = center
				}
			}
			
			if let animating = self.animatingCardView {
				self.bringSubviewToFront(animating)
			}
			self.cardsNeedLayout = false
		}
	}
	
	var gesturesEnabled: Bool = false {
		didSet {
			self.isUserInteractionEnabled = self.gesturesEnabled
			if self.gesturesEnabled {
				if self.panGestureRecognizer != nil { return }
				
				self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned))
				self.addGestureRecognizer(self.panGestureRecognizer!)
			} else {
				if let pan = self.panGestureRecognizer { self.removeGestureRecognizer(pan) }
				self.panGestureRecognizer = nil
			}
		}
	}
	
	func startDragging(card: FlickCard) {
		self.state = .draggingTopCard
		self.updateUI()
		UIView.animate(withDuration: 0.1) {
			self.layoutIfNeeded()
		}
	}
	
	func addReturnedCard(_ card: FlickCard) {
		self.cards.append(card)
		self.updateUI()
	}
	
	func finishDragging(card: FlickCard, to: CGPoint?, removed: Bool) {
		if removed {
			self.willRemove(card: card, to: to, viaFlick: true)
			self.remove(card: card)
		}
		self.state = .idle
		DispatchQueue.main.async { self.updateUI() }
	}
	
	var pendingCards: [PendingCard] = []
	
	struct PendingCard {
		let card: FlickCard
		let animated: Bool
		let toTop: Bool
		let source: CGPoint?
		let duration: TimeInterval
		let completion: (() -> Void)?
	}
	
	func add(card: FlickCard, toTop: Bool = false, animated: Bool = false, from source: CGPoint? = nil, duration: TimeInterval = 0.2, completion: (() -> Void)?) {
		if self.cards.contains(card) { return }
		
		
		self.pendingCards.append(PendingCard(card: card, animated: animated, toTop: toTop, source: source, duration: duration, completion: completion))
		self.handlePendingCards()
	}
	
	func handlePendingCards() {
		guard self.state == .idle, let first = self.pendingCards.first else { return }
		self.pendingCards.removeFirst()
		
		var newCards = self.cards
		if first.toTop { newCards.insert(first.card, at: 0) } else { newCards.append(first.card) }
		if first.animated {
			let cardView = first.card.buildCardView(ofSize: self.cardSize)
			cardView.center = first.source ?? CGPoint(x: self.bounds.width / 2, y: -self.bounds.height)
			if first.toTop { self.addSubview(cardView) } else { self.insertSubview(cardView, at: 0) }
			self.state = .addingCards
			cardView.transformForAnimation(in: self, location: cardView.center)
			UIView.animate(withDuration: first.duration, animations: {
				cardView.center = self.defaultCardCenter
				cardView.percentageLifted = 0
			}) { _ in
				self.state = .idle
				self.cardViews.append(cardView)
				self.cards = newCards
				self.updateUI()
				first.completion?()
				self.handlePendingCards()
			}
		} else {
			self.cards = newCards
			self.updateUI()
			first.completion?()
			DispatchQueue.main.async { self.handlePendingCards() }
		}
	}
	
	func animateCardOut(_ card: FlickCard, to destination: CGPoint?, duration: TimeInterval = 0.2) {
		if let cardView = self.view(for: card) {
			let dest = destination ?? CGPoint(x: self.bounds.width * 1, y: self.bounds.height * -1)
			
			self.willRemove(card: card, to: destination, viaFlick: false)
			self.animatingCardView = cardView
			self.remove(card: card)
			self.state = .animatingTopCardOut
			self.updateUI()
			UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseIn], animations: {
					cardView.transform = CGAffineTransform(translationX: 10, y: 30)
			}) { _ in
					UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [.curveEaseIn], animations: {
					self.layoutIfNeeded()
					cardView.center = dest
					cardView.transformForAnimation(in: self, location: dest)
				}) { _ in
					self.state = .idle
					cardView.removeFromSuperview()
					self.updateUI()
					self.didRemove(card: card, to: destination, viaFlick: false)
				}
			}
		}
	}
	
	func remove(card: FlickCard) {
		if let index = self.cards.index(of: card) { self.cards.remove(at: index) }
		if let cardView = self.view(for: card) {
			if let index = self.cardViews.index(of: cardView) { self.cardViews.remove(at: index) }
		}
	}
	
	func willRemove(card: FlickCard, to: CGPoint?, viaFlick: Bool) {
		self.delegate?.willRemove(card: card, to: to, viaFlick: viaFlick)
		if self.cards.count == 1 {
			self.delegate?.willRemoveLastCard()
		}
	}
	
	func didRemove(card: FlickCard, to: CGPoint?, viaFlick: Bool) {
		self.delegate?.didRemove(card: card, to: to, viaFlick: viaFlick)
		if self.cards.count == 0 {
			self.delegate?.didRemoveLastCard()
		}
	}
	
	func view(for card: FlickCard) -> FlickCardView? {
		for view in self.cardViews { if view.card == card { return view }}
		return nil
	}
	
	func calculateAlpha(for card: FlickCard, at position: Int) -> CGFloat {
		switch self.arrangement {
		case .tiered(_, let alphaStep):
			return 1.0 - CGFloat(position) * alphaStep
			
		default:
			return 1
		}
	}
	
	func calculateTransform(for card: FlickCard, at position: Int) -> CGAffineTransform {
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

		case .tiered(let offset, _):
			let factor = 1.0 - CGFloat(position) * 0.05
			let scale = CGAffineTransform(scaleX: factor, y: factor)
			let translate = CGAffineTransform(translationX: 0, y: -1 * CGFloat(position) * offset / factor)
			return translate.concatenating(scale)
		}
		
	}
}
