//
//  BaseReviewView.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import PinLayout
import UIKit

class BaseReviewView: UIView {
	
	// MARK: - Private Properties
	
	private let containerView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		return view
	}()
	
	private let backgrounView: UIView = {
		let view = UIView()
		view.backgroundColor = .black.withAlphaComponent(0.7)
		return view
	}()
	
	private let settings: ReviewSettings
	
	// MARK: - Lifecycle
	
	init(settings: ReviewSettings, frame: CGRect) {
		self.settings = settings
		super.init(frame: frame)
		configureUI()
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
		containerView.pin
			.left()
			.right()
			.height(frame.height - settings.topSpacing)
			.bottom(-frame.height - settings.topSpacing)
		
		UIView.animate(withDuration: settings.animationDuration) {
			self.containerView.pin
				.left()
				.right()
				.height(self.frame.height - self.settings.topSpacing)
				.bottom()
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
		containerView.pin
			.left()
			.right()
			.height(frame.height - settings.topSpacing)
			.bottom(-frame.height - settings.topSpacing)
	}
}

// MARK: - Nested

extension BaseReviewView {
	
	struct ReviewSettings {
		private enum Constants {
			static let defaultDuration: Double = 0.3
			static let topSpacing: CGFloat = 100
		}
		
		let animationDuration: Double
		let topSpacing: CGFloat
		
		init(
			animationDuration: Double = Constants.defaultDuration,
			topSpacing: CGFloat = Constants.topSpacing
		) {
			self.animationDuration = animationDuration
			self.topSpacing = topSpacing
		}
	}
}
