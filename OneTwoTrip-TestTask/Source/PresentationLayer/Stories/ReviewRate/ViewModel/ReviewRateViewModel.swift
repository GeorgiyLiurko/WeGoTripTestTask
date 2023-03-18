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
	
	// MARK: - Reactor
	
	enum Action {}
	struct State {}
	enum Mutation {}
	
	func reduce(state: State, mutation: Mutation) -> State {}
	func mutate(action: Action) -> Observable<Mutation> {}
	
	// MARK: - Lifecycle
	
	init(coordinator: ReviewRateCoordinator) {
		self.coordinator = coordinator
		self.initialState = State()
	}
}
