//
//  BaseReviewView+Nested.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 19.03.2023.
//

import Foundation

extension BaseReviewView {
	
	struct ReviewSettings {
		
		// MARK: - Nested
		
		enum OpenState {
			case opened
			case closed
		}
		
		// MARK: - Properties
		
		var maxBackgroundAlpha: CGFloat = 0.8
		var minBackgroundAlpha: CGFloat = 0.2
		var closeOffsetDevider: CGFloat =  1.5
		var animationDuration: Double = 0.3
		var topSpacing: CGFloat = 100
		var openState: OpenState
	}
}

