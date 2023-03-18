//
//  ReviewRateAssembly.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import Foundation
import Swinject

struct ReviewRateAssembly: Assembly {
	
	// MARK: - Private Properties
	
	private let coordinator: ReviewRateCoordinator
	
	// MARK: - Lifecycle
	
	init(coordinator: ReviewRateCoordinator) {
		self.coordinator = coordinator
	}
	
	// MARK: - Public Methods
	
	func assemble(container: Container) {
		container.register(ReviewRateViewController.self) { _ in
			return ReviewRateViewController()
		}
		
		container.register(ReviewRateViewModel.self) { _ in
			return ReviewRateViewModel(coordinator: self.coordinator)
		}
	}
}

