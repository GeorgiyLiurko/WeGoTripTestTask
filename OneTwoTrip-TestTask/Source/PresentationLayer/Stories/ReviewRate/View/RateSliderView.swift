//
//  RateSliderView.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import UIKit
import PinLayout

final class RateSliderView: UIView {
	
	// MARK: - Properties
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .body)
		return label
	}()
	
	private let emojiLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = UIFont.preferredFont(forTextStyle: .body)
		return label
	}()
	
	private let rateSlider: UISlider = {
		let slider = UISlider()
		slider.isContinuous = false
		slider.minimumValue = 0
		slider.maximumValue = 4
		return slider
	}()
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func sizeThatFits(_ size: CGSize) -> CGSize {
		return CGSize(width: size.width, height: rateSlider.frame.maxY)
	}
	
	// MARK: - Public Methods
	
	func prepare(title: String) {
		titleLabel.text = title
		layoutSubviews()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		configureLayout()
	}
}

// MARK: - RateSliderView

extension RateSliderView: BaseView {
	
	func configureUI() {
		addSubview(titleLabel)
		addSubview(emojiLabel)
		addSubview(rateSlider)
	}
	
	func configureLayout() {
		emojiLabel.pin
			.right()
			.top()
			.size(20)
		
		titleLabel.pin
			.left()
			.top()
			.right(to: emojiLabel.edge.left).marginLeft(8)
			.sizeToFit(.width)
		
		rateSlider.pin
			.left()
			.right()
			.bottom()
			.height(30)
			.top(to: titleLabel.edge.bottom).marginTop(8)
	}
}
