import Foundation
import Swinject

struct ReviewRateAssembly: Assembly {
	
	// MARK: - Private Properties
	
	private let coordinator: ReviewRateCoordinator
	private let reviewDataSource: ReviewDataSource
	
	// MARK: - Lifecycle
	
	init(coordinator: ReviewRateCoordinator, reviewDataSource: ReviewDataSource) {
		self.coordinator = coordinator
		self.reviewDataSource = reviewDataSource
	}
	
	// MARK: - Public Methods
	
	func assemble(container: Container) {
		container.register(ReviewRateViewModel.self) { resolver in
			return ReviewRateViewModel(
				coordinator: self.coordinator,
				reviewDataSource: self.reviewDataSource,
				reviewService: resolver.forceResolve(IReviewService.self)
			)
		}
		
		container.register(ReviewRateViewController.self) { resolver in
			let controller = ReviewRateViewController()
			controller.reactor = resolver.resolve(ReviewRateViewModel.self)
			return controller
		}
	}
}
