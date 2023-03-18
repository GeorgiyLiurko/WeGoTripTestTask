//
//  MainViewModel.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

final class MainViewModel: Reactor {
	
	// MARK: - Nested
	
	enum Action {
		case writeReview
	}
	
	enum Mutation {
		case writeReview(Bool)
	}
	
	struct State {
		var showReview = false
	}
	
	// MARK: - Properties
	
	var initialState: State

	// MARK: - Private Properties
	
	private let coordinator: MainCoordinator
	private let disposeBag = DisposeBag()
	
	// MARK: - Lifecycle
	
	init(coordinator: MainCoordinator) {
		self.coordinator = coordinator
		self.initialState = State()
		self.setupCoordinatorBindings()
	}
	
	// MARK: - Reactor
	
	func reduce(state: State, mutation: Mutation) -> State {
		var state = state
		switch mutation {
		case .writeReview(let showReview):
			state.showReview = showReview
		}
		return state
	}
	
	func mutate(action: Action) -> Observable<Mutation> {
		switch action {
		case .writeReview:
			return .concat(
				.just(.writeReview(true)),
				.just(.writeReview(false))
			)
		}
	}
}

// MARK: - Private Methods

private extension MainViewModel {
	
	func setupCoordinatorBindings() {
		state.map({ $0.showReview })
			.filter({ $0 })
			.flatMap({ _ -> Observable<Void> in
				return .just(())
			})
			.bind(to: coordinator.showReview)
			.disposed(by: disposeBag)
	}
}
