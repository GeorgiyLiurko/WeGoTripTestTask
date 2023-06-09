import Foundation
import RxSwift
import RxCocoa
import Swinject
import ReactiveCoordinator

final class ReviewCommentCoordinator: ReactiveCoordinator<Void> {
	
	// MARK: - Private Properties
	
	private weak var navigationController: UINavigationController?
	private let assembler: Assembler
	private let reviewDataSource: ReviewDataSource
	
	// MARK: - Properties
	
	var close = PublishSubject<Void>()
	
	// MARK: - Lifecycle
	
	init(
		navigationController: UINavigationController,
		assembler: Assembler,
		reviewDataSource: ReviewDataSource
	) {
		self.assembler = assembler
		self.reviewDataSource = reviewDataSource
		self.navigationController = navigationController
	}
	
	// MARK: - Public Method
	
	override func start() -> Observable<Void> {
		guard let controller = getReviewCommentViewController() else {
			return .empty()
		}
		controller.modalPresentationStyle = .overCurrentContext
		navigationController?.topViewController?.present(
			controller,
			animated: false
		)
		return close.do(onNext: { [controller] in
			controller.dismiss(animated: false)
		})
	}
}

// MARK: - Private Methods

private extension ReviewCommentCoordinator {
	
	func getReviewCommentViewController() -> UIViewController? {
		assembler.apply(
			assembly: ReviewCommentAssembly(
				coordinator: self,
				reviewDataSource: reviewDataSource
			)
		)
		return assembler.resolver.resolve(ReviewCommentViewController.self)
	}
}
