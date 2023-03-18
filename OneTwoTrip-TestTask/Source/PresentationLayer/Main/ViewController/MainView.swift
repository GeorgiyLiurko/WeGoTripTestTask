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
	
	private let reviewButton: UIButton = {
		let button = UIButton()
		button.setTitle(
			R.string.localizable.writeReview(),
			for: .normal
		)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .systemBlue
		return button
	}()
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		reviewButton.layer.cornerRadius = 12
		
		reviewButton.pin
			.vCenter()
			.hCenter()
			.width(40%)
			.height(50)
	}
	
	// MARK: - Private Methods
	
	private func setupView() {
		backgroundColor = .white
		addSubview(reviewButton)
	}
}