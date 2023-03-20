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
	private var reviewDataSource: ReviewDataSource
	
	// MARK: - Lifecycle
	
	init(coordinator: ReviewCommentCoordinator, reviewDataSource: ReviewDataSource) {
		self.coordinator = coordinator
		self.reviewDataSource = reviewDataSource
	}
	
	// MARK: - Public Methods
	
	func assemble(container: Container) {
		container.register(ReviewCommentViewModel.self) { resolver in
			return ReviewCommentViewModel(
				coordinator: coordinator,
				reviewDataSource: reviewDataSource,
				reviewService: resolver.forceResolve(IReviewService.self)
			)
		}
		container.register(ReviewCommentViewController.self) { resolver in
			let controller = ReviewCommentViewController()
			controller.reactor = resolver.resolve(ReviewCommentViewModel.self)
			return controller
		}
	}
}
