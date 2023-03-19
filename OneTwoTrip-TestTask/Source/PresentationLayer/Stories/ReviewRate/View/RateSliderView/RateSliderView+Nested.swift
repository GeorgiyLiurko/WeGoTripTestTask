//
//  RateSliderView+Nested.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 19.03.2023.
//


extension RateSliderView {
	
	enum RateEmoji: String {
		case one = "😡"
		case two = "😠"
		case three = "😐"
		case four = "😌"
		case five = "😁"
		
		init(value: Int) {
			switch value {
			case 0: self = .one
			case 1: self = .two
			case 2: self = .three
			case 3: self = .four
			case 4: self = .five
			default: self = .three
			}
		}
	}
}
