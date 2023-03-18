//
//  MainAssembly.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import Foundation
import Swinject

struct MainAssembly: Assembly {
	
	// MARK: - Private Properties
	
	private let coordinator: MainCoordinator
	
	// MARK: - Lifecycle
	
	init(coordinator: MainCoordinator) {
		self.coordinator = coordinator
	}
	
	// MARK: - Public Methods
	
	func assemble(container: Container) {
		container.register(MainViewController.self) { _ in
			return MainViewController()
		}
		
		container.register(MainViewModel.self) { _ in
			return MainViewModel(coordinator: self.coordinator)
		}
	}
}
