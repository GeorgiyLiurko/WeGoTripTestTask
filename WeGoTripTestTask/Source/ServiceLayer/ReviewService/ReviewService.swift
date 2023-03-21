import Foundation
import Moya
import RxSwift

struct ReviewService: IReviewService {
	
	// MARK: - Private Properties
	
	private let provider: MoyaProvider<ReviewTarget>
	
	// MARK: - Lifecycle
	
	init(provider: MoyaProvider<ReviewTarget>) {
		self.provider = provider
	}
	
	// MARK: - Public Methods
	
	func sendReviewRate(reviewRate: ReviewRateModel) -> Observable<Void> {
		provider.rx.request(.setReviewRate(reviewRate))
			.asObservable()
			.flatMap { response -> Observable<Void> in
				// Don't handle Error because of Testing Task
				return .just(())
			}
	}
	
	func sendReviewComment(reviewComment: ReviewCommentModel) -> Observable<Void> {
		provider.rx.request(.setReviewComment(reviewComment))
			.asObservable()
			.flatMap { response -> Observable<Void> in
				// Don't handle Error because of Testing Task
				return .just(())
			}
	}
}
