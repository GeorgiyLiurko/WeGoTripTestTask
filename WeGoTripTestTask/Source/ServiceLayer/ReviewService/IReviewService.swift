import Foundation
import RxSwift
import RxCocoa

protocol IReviewService {
	func sendReviewRate(reviewRate: ReviewRateModel) -> Observable<Void>
	func sendReviewComment(reviewComment: ReviewCommentModel) -> Observable<Void>
}
