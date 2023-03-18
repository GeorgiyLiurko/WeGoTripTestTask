//
//  MainViewModel.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import Foundation
import ReactorKit

final class MainViewModel: Reactor {
	
	// MARK: - Properties
	
	var initialState: State

	// MARK: - Private Properties
	
	private let coordinator: MainCoordinator?
	
	// MARK: - Reactor

	enum Action {}
	struct State {}
	enum Mutation {}
	
	func reduce(state: State, mutation: Mutation) -> State {}
	func mutate(action: Action) -> Observable<Mutation> {}
	
	// MARK: - Lifecycle
	
	init(coordinator: MainCoordinator) {
		self.coordinator = coordinator
		self.initialState = State()
	}
}
