//
//  ReviewCommentViewModel.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import Foundation
import RxSwift
import ReactorKit

final class ReviewCommentViewModel: Reactor {
	
	// MARK: - Properties
	
	var initialState: State
	
	// MARK: - Private Properties
	
	private let coordinator: ReviewCommentCoordinator
	private let disposeBag = DisposeBag()
	
	// MARK: - Reactor
	
	enum Action {
		case close
	}
	
	enum Mutation {
		case setClosed(Bool)
	}
	
	struct State {
		var didClose = false
	}
	
	// MARK: - Lifecycle
	
	init(coordinator: ReviewCommentCoordinator) {
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
		}
	}
}

// MARK: - Private Methods

private extension ReviewCommentViewModel {
	
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
