//
//  RateUISlider.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 19.03.2023.
//

import UIKit
import PinLayout

final class ThinSlider: UISlider {
	
	// MARK: - Nested
	
	private enum Constants {
		static let sliderThinkness: CGFloat = 2
	}
	
	// MARK: - Private Properties
	
	private let baseLayer = CALayer()
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		configureUI()
	}
}

// MARK: - View

extension ThinSlider: BaseView {
	
	func configureUI() {
		tintColor = .clear
		maximumTrackTintColor = .clear
		backgroundColor = .clear
		layer.insertSublayer(baseLayer, at: 0)
		
		baseLayer.masksToBounds = false
		baseLayer.backgroundColor = R.color.customGray()?.cgColor
		baseLayer.pin
			.left(2)
			.width(frame.width - 4)
			.top(frame.height / 2)
			.height(Constants.sliderThinkness)
		baseLayer.cornerRadius = baseLayer.frame.height / 2
	}
}
