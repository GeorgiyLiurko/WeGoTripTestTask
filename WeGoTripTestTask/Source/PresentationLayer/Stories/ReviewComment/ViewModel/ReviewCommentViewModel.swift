import Foundation
import RxSwift
import ReactorKit

final class ReviewCommentViewModel: Reactor {
	
	// MARK: - Properties
	
	var initialState: State
	
	// MARK: - Private Properties
	
	private let coordinator: ReviewCommentCoordinator
	private let disposeBag = DisposeBag()
	private let reviewService: IReviewService
	
	// MARK: - Reactor
	
	enum Action {
		case close
		case sendReview
	}
	
	enum Mutation {
		case setClosed(Bool)
		case setLikeComment(String)
		case setImprovementComment(String)
		case setIsLoading(Bool)
		case setDidSendReview(Bool)
	}
	
	struct State {
		var didClose = false
		var reviewDataSource: ReviewDataSource
		var isLoading = false
		var reviewSent = false
		
		var likeComment: String = ""
		var improvementComment: String = ""
	}
	
	// MARK: - Lifecycle
	
	init(
		coordinator: ReviewCommentCoordinator,
		reviewDataSource: ReviewDataSource,
		reviewService: IReviewService
	) {
		self.coordinator = coordinator
		self.reviewService = reviewService
		self.initialState = State(reviewDataSource: reviewDataSource)
		self.setupCoordinatorBindings()
	}
	
	// MARK: - Public Methods
	
	func reduce(state: State, mutation: Mutation) -> State {
		var state = state
		switch mutation {
		case .setDidSendReview(let didSend):
			state.reviewSent = didSend
		case .setIsLoading(let isLoading):
			state.isLoading = isLoading
		case .setClosed(let closed):
			state.didClose = closed
		case .setLikeComment(let comment):
			state.likeComment = comment
		case .setImprovementComment(let comment):
			state.improvementComment = comment
		}
		return state
	}
	
	func mutate(action: Action) -> Observable<Mutation> {
		switch action {
		case .close:
			return .concat(
				.just(.setClosed(true)),
				.just(.setClosed(false))
			)
		case .sendReview:
			let reviewComment = getReviewCommentModel(state: currentState)
			return .concat(
				.just(.setIsLoading(true)),
				reviewService.sendReviewComment(
					reviewComment: reviewComment
				)
				.flatMap({ _ -> Observable<Mutation> in
					return .concat(
						.just(.setIsLoading(false)),
						.just(.setDidSendReview(true))
					)
				})
			)
		}
	}
}

// MARK: - Private Methods

private extension ReviewCommentViewModel {
	
	func getReviewCommentModel(state: State) -> ReviewCommentModel {
		ReviewCommentModel(
			likeComment: state.likeComment,
			improvementComment: state.improvementComment
		)
	}
	
	func setupCoordinatorBindings() {
		state.map({ $0.didClose })
			.filter({ $0 })
			.flatMap({ _ -> Observable<Void> in
				return .just(())
			})
			.bind(to: coordinator.close)
			.disposed(by: disposeBag)
	}
}
