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
	
	// MARK: - Reactor
	
	enum Action {
		case close
		case sendReview
	}
	
	enum Mutation {
		case setClosed(Bool)
		case sendReview(Bool)
	}
	
	struct State {
		var didClose = false
		var didOpenSendReview = false
	}
	
	// MARK: - Lifecycle
	
	init(coordinator: ReviewRateCoordinator) {
		self.coordinator = coordinator
		self.initialState = State()
		self.setupCoordinatorBindings()
	}
	
	// MARK: - Public Methods
	
	func reduce(state: State, mutation: Mutation) -> State {
		var state = state
		switch mutation {
		case .setClosed(let closed):
			state.didClose = closed
		case .sendReview(let send):
			state.didOpenSendReview.self = send
		}
		return state
	}
	
	func mutate(action: Action) -> Observable<Mutation> {
		switch action {
		case .sendReview:
			return .concat(
				.just(.sendReview(true)),
				.just(.sendReview(false))
			)
		case .close:
			return .concat(
				.just(.setClosed(true)),
				.just(.setClosed(false))
			)
		}
	}
}

// MARK: - Private Methods

private extension ReviewRateViewModel {
	
	func setupCoordinatorBindings() {
		state.map({ $0.didOpenSendReview })
			.filter({ $0 })
			.flatMap({ _ -> Observable<Void> in
				return .just(())
			})
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
