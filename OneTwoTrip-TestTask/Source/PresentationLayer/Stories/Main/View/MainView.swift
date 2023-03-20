//
//  MainView.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import UIKit
import PinLayout

final class MainView: UIView {
	
	// MARK: - Private Properties
	
	private(set) var reviewButton: BaseButton = {
		let button = BaseButton()
		button.setTitle(
			R.string.localizable.writeReview(),
			for: .normal
		)
		return button
	}()
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		configureLayout()
	}
}

// MARK: - BaseView

extension MainView: BaseView {
	
	func configureUI() {
		backgroundColor = .white
		addSubview(reviewButton)
	}
	
	func configureLayout() {
		reviewButton.pin
			.vCenter()
			.left(16)
			.right(16)
			.sizeToFit(.width)
	}
}
