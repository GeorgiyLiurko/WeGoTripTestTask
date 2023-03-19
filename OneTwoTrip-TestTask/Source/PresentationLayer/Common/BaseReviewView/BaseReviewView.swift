//
//  BaseReviewView.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import PinLayout
import UIKit
import RxSwift
import RxCocoa

class BaseReviewView: UIView {
	
	// MARK: - Public Properties
	
	let didClose = PublishSubject<Void>()
	
	// MARK: - Private Properties
	
	private let containerView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.isUserInteractionEnabled = true
		return view
	}()
	
	private let backgrounView: UIView = {
		let view = UIView()
		return view
	}()
	
	private let settings: ReviewSettings
	
	// MARK: - Lifecycle
	
	init(settings: ReviewSettings, frame: CGRect) {
		self.settings = settings
		super.init(frame: frame)
		configureUI()
		configureContainerGesture()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		configureLayout()
	}
	
	// MARK: - Public Methods
	
	func animateOpening() {
		guard settings.openState == .closed else { return }
		
		backgrounView.backgroundColor = .clear
		setClosedContainerViewLayout()
		
		UIView.animate(withDuration: settings.animationDuration) {
			self.backgrounView.backgroundColor = .black.withAlphaComponent(
				self.settings.maxBackgroundAlpha
			)
			
			self.setOpenedContainerViewLayout()
		}
	}
	
	func addSubviewToContainer(_ view: UIView) {
		self.containerView.addSubview(view)
	}
}

// MARK: - Private Methods

private extension BaseReviewView {
	
	func configureUI() {
		addSubview(backgrounView)
		backgrounView.addSubview(containerView)
	}
	
	func configureLayout() {
		backgrounView.pin.all()
		containerView.layer.cornerRadius = 16
		
		if settings.openState == .closed {
			setClosedContainerViewLayout()
		} else {
			setOpenedContainerViewLayout()
		}
	}
	
	func setClosedContainerViewLayout() {
		containerView.pin
			.left()
			.right()
			.height(frame.height - settings.topSpacing)
			.bottom(-frame.height - settings.topSpacing)
	}
	
	func setOpenedContainerViewLayout() {
		containerView.pin
			.left()
			.right()
			.height(frame.height - settings.topSpacing)
			.bottom()
	}
	
	@objc private func handleCardSwipe(
		_ gesture: UIPanGestureRecognizer
	) {
		guard let containerView = gesture.view else { return }
		let point = gesture.translation(in: self)
		
		var offset = containerView.frame.minY + point.y
			
		guard gesture.state != .ended else {
			handleGestureEnd(offset: offset)
			return
		}
		
		if settings.topSpacing >= offset {
			offset = settings.topSpacing
		}
				
		containerView.frame = CGRect(
			x: containerView.frame.minX,
			y: offset,
			width: containerView.frame.width,
			height: containerView.frame.height
		)
		gesture.setTranslation(CGPoint.zero, in: self)
		updateBackgroundAlpha(with: offset)
	}
	
	func updateBackgroundAlpha(with offset: CGFloat) {
		let maxOffset = containerView.frame.height
		let minOffset = settings.topSpacing
		var percent = (1 - ((offset - minOffset) / (maxOffset))) - 0.2
		if percent < settings.minBackgroundAlpha {
			percent = settings.minBackgroundAlpha
		}
		self.backgrounView.backgroundColor = UIColor.black.withAlphaComponent(
			percent
		)
	}
	
	func handleGestureEnd(offset: CGFloat) {
		let maxOffset = containerView.frame.height
		let closePoint = maxOffset / settings.closeOffsetDevider
		
		UIView.animate(withDuration: settings.animationDuration) {
			if offset > closePoint {
				self.setClosedContainerViewLayout()
			} else {
				self.setOpenedContainerViewLayout()
				self.didClose.onNext(())
			}
			self.updateBackgroundAlpha(with: offset)
		}
	}
	
	func configureContainerGesture() {
		let panGestureRecognizer = UIPanGestureRecognizer(
			target: self,
			 action: #selector(handleCardSwipe)
		 )
		containerView.addGestureRecognizer(panGestureRecognizer)
	}
}
