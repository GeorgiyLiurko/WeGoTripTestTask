import Foundation

extension BaseReviewView {
	
	struct ReviewSettings {
		
		// MARK: - Nested
		
		enum Constants {
			static let maxBackgroundAlpha: CGFloat = 0.8
		}
		
		enum OpenState {
			case opened
			case closed
		}
		
		// MARK: - Properties
		
		var maxBackgroundAlpha: CGFloat = Constants.maxBackgroundAlpha
		var minBackgroundAlpha: CGFloat = 0.2
		var closeOffsetDevider: CGFloat =  1.5
		var animationDuration: Double = 0.3
		var topSpacing: CGFloat = 100
		var openState: OpenState
	}
}

