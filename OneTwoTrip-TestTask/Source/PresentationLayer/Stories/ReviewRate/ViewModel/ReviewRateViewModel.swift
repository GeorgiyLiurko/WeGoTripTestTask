//
//  ReviewRateViewModel.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import Foundation
import RxSwift
import ReactorKit

final class ReviewRateViewModel: Reactor {
	
	// MARK: - Properties
	
	var initialState: State
	
	// MARK: - Private Properties
	
	private let coordinator: ReviewRateCoordinator
	private let disposeBag = DisposeBag()
	private let reviewService: IReviewService
	
	// MARK: - Reactor
	
	enum Action {
		case close
		case sendReview
		
		case overallRateChanged(Int)
		case guideRateChanged(Int)
		case informationRateChanged(Int)
		case navigationRateChanged(Int)
	}
	
	enum Mutation {
		case setClosed(Bool)
		case sendReview(Bool)
		case setReviewDataSource(ReviewDataSource)
		
		case setOverallRate(Int)
		case setGuideRate(Int)
		case setInformationRate(Int)
		case setNavigationRate(Int)
		case setIsLoading(Bool)
	}
	
	struct State {
		var didClose = false
		var didOpenSendReview = false
		var reviewDataSource: ReviewDataSource
		
		var overallRate: Int = ReviewRateModel.Constants.defaultRate
		var guideRate: Int = ReviewRateModel.Constants.defaultRate
		var informationRate: Int = ReviewRateModel.Constants.defaultRate
		var navigationRate: Int = ReviewRateModel.Constants.defaultRate
		
		var isLoading = false
	}
	
	// MARK: - Lifecycle
	
	init(
		coordinator: ReviewRateCoordinator,
		reviewDataSource: ReviewDataSource,
		reviewService: IReviewService
	) {
		self.coordinator = coordinator
		self.initialState = State(reviewDataSource: reviewDataSource)
		self.reviewService = reviewService
		self.setupCoordinatorBindings()
	}
	
	// MARK: - Public Methods
	
	func reduce(state: State, mutation: Mutation) -> State {
		var state = state
		switch mutation {
		case .setReviewDataSource(let model):
			state.reviewDataSource = model
		case .setClosed(let closed):
			state.didClose = closed
		case .sendReview(let send):
			state.didOpenSendReview.self = send
		case .setOverallRate(let rate):
			state.overallRate = rate
		case .setGuideRate(let rate):
			state.guideRate = rate
		case .setInformationRate(let rate):
			state.informationRate = rate
		case .setNavigationRate(let rate):
			state.navigationRate = rate
		case .setIsLoading(let isLoading):
			state.isLoading = isLoading
		}
		return state
	}
	
	func mutate(action: Action) -> Observable<Mutation> {
		switch action {
		case .sendReview:
			let reviewRateModel = getReviewRateModel(from: currentState)
			return .concat(
				.just(.setIsLoading(true)),
				reviewService.sendReviewRate(
					reviewRate: reviewRateModel
				)
				.compactMap({ [weak self] _ -> ReviewDataSource? in
					guard let self = self else { return nil }
					var newReviewRateModel = self.currentState.reviewDataSource.model
					newReviewRateModel.reviewRate = reviewRateModel
					var newReviewDataSource = self.currentState.reviewDataSource
					newReviewDataSource.model = newReviewRateModel
					return newReviewDataSource
				})
				.flatMap { reviewDataSource -> Observable<Mutation> in
					return .concat(
						.just(.setReviewDataSource(reviewDataSource)),
						.just(.setIsLoading(false)),
						.just(.sendReview(true)),
						.just(.sendReview(false))
					)
				}
			)
		case .close:
			return .concat(
				.just(.setIsLoading(false)),
				.just(.setClosed(true)),
				.just(.setClosed(false))
			)
		case .overallRateChanged(let rate):
			return .just(.setOverallRate(rate))
		case .guideRateChanged(let rate):
			return .just(.setGuideRate(rate))
		case .informationRateChanged(let rate):
			return .just(.setInformationRate(rate))
		case .navigationRateChanged(let rate):
			return .just(.setNavigationRate(rate))
		}
	}
}

// MARK: - Private Methods

private extension ReviewRateViewModel {
	
	func getReviewRateModel(from state: State) -> ReviewRateModel {
		ReviewRateModel(
			guideRate: state.guideRate,
			overallRate: state.overallRate,
			informationRate: state.informationRate,
			navigationRate: state.navigationRate
		)
	}
	
	func setupCoordinatorBindings() {
		state.map({ ($0.didOpenSendReview, $0.reviewDataSource) })
			.filter({ $0.0 })
			.map({ $0.1 })
			.bind(to: coordinator.openReviewComment)
			.disposed(by: disposeBag)
		
		state.map({ $0.didClose })
			.filter({ $0 })
			.flatMap({ _ -> Observable<Void> in
				return .just(())
			})
			.bind(to: coordinator.close)
			.disposed(by: disposeBag)
	}
}
