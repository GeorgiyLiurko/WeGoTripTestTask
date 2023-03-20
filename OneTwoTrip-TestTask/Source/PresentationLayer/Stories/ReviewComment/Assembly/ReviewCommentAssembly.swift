//
//  ReviewCommentAssembly.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 19.03.2023.
//

import Foundation

import Foundation
import Swinject

struct ReviewCommentAssembly: Assembly {
	
	// MARK: - Private Properties
	
	private let coordinator: ReviewCommentCoordinator
	
	// MARK: - Lifecycle
	
	init(coordinator: ReviewCommentCoordinator) {
		self.coordinator = coordinator
	}
	
	// MARK: - Public Methods
	
	func assemble(container: Container) {
		container.register(ReviewCommentViewModel.self) { _ in
			return ReviewCommentViewModel(coordinator: coordinator)
		}
		container.register(ReviewCommentViewController.self) { resolver in
			let controller = ReviewCommentViewController()
			controller.reactor = resolver.resolve(ReviewCommentViewModel.self)
			return controller
		}
	}
}
