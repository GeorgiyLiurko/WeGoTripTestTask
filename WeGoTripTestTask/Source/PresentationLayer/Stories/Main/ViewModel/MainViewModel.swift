import Foundation
import ReactorKit
import RxSwift
import RxCocoa

final class MainViewModel: Reactor {
	
	// MARK: - Nested
	
	enum Action {
		case writeReview
		case load
	}
	
	enum Mutation {
		case writeReview(Bool)
		case setProfileAvatarUrl(URL)
		case setProfileAvarUrlLoaded(Bool)
		case setReviewDataSource(ReviewDataSource)
		case setIsLoading(Bool)
	}
	
	struct State {
		var showReview = false
		var profileAvarUrlLoaded = false
		var profileAvatarUrl: URL?
		var reviewDataSource: ReviewDataSource?
		var isLoading = false
	}
	
	// MARK: - Properties
	
	var initialState: State

	// MARK: - Private Properties
	
	private let coordinator: MainCoordinator
	private let profileImageService: IProfileImageService
	private let disposeBag = DisposeBag()
	
	// MARK: - Lifecycle
	
	init(coordinator: MainCoordinator, profileImageService: IProfileImageService) {
		self.coordinator = coordinator
		self.profileImageService = profileImageService
		self.initialState = State()
		self.setupCoordinatorBindings()
	}
	
	// MARK: - Reactor
	
	func reduce(state: State, mutation: Mutation) -> State {
		var state = state
		switch mutation {
		case .setIsLoading(let isLoading):
			state.isLoading = isLoading
		case .setReviewDataSource(let dataSource):
			state.reviewDataSource = dataSource
		case .setProfileAvarUrlLoaded(let loaded):
			state.profileAvarUrlLoaded = loaded
		case .setProfileAvatarUrl(let url):
			state.profileAvatarUrl = url
		case .writeReview(let showReview):
			state.showReview = showReview
		}
		return state
	}
	
	func mutate(action: Action) -> Observable<Mutation> {
		switch action {
		case .load:
			return .concat(
				.just(.setIsLoading(true)),
				profileImageService.getAvatar()
					.flatMap { urlString -> Observable<Mutation> in
						guard let url = URL(string: urlString) else {
							return .concat(
								.just(.setProfileAvarUrlLoaded(true)),
								.just(.setIsLoading(false))
							)
						}
						return .concat(
							.just(.setProfileAvatarUrl(url)),
							.just(.setProfileAvarUrlLoaded(true)),
							.just(.setIsLoading(false))
						)
					}
			)
		case .writeReview:
			return state.map({ ($0.profileAvarUrlLoaded, $0.profileAvatarUrl) })
				.observe(on: MainScheduler.asyncInstance)
				.filter({ $0.0 })
				.take(1)
				.flatMap { (_, url) -> Observable<Mutation> in
					let emptyModel = ReviewModel(
						reviewRate: ReviewRateModel(),
						reviewComment: ReviewCommentModel()
					)
					let reviewDataSource = ReviewDataSource(
						avatarUrl: url,
						model: emptyModel
					)
					return .concat(
						.just(.setReviewDataSource(reviewDataSource)),
						.just(.writeReview(true)),
						.just(.writeReview(false))
					)
				}
		}
	}
}

// MARK: - Private Methods

private extension MainViewModel {
	
	func setupCoordinatorBindings() {
		state
			.map({ ($0.showReview, $0.reviewDataSource) })
			.filter({ $0.0 })
			.compactMap({ $0.1 })
			.bind(to: coordinator.showReview)
			.disposed(by: disposeBag)
	}
}
