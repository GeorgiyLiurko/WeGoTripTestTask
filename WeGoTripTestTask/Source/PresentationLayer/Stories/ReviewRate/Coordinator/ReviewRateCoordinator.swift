import ReactiveCoordinator
import RxSwift
import Swinject

final class ReviewRateCoordinator: ReactiveCoordinator<Void> {
	
	// MARK: - Private Properties
	
	private weak var navigationController: UINavigationController?
	private let assembler: Assembler
	private let reviewDataSource: ReviewDataSource
	
	// MARK: - Properties
	
	var close = PublishSubject<Void>()
	var openReviewComment = PublishSubject<ReviewDataSource>()
	
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
		guard let navController = self.navigationController,
					let controller = getReviewRateViewController() else {
			return .empty()
		}
		controller.modalPresentationStyle = .overCurrentContext
		navigationController?.topViewController?.present(
			controller,
			animated: false
		)
	
		return Observable.merge(
			close.do(onNext: { [controller] in
				controller.dismiss(animated: false)
			}),
			openReviewComment.asObservable()
				.flatMap({ [weak self, controller] value -> Observable<Void> in
					guard let self = self else { return .empty() }
					controller.dismiss(animated: false)
					return self.coordinate(
						to: self.getReviewCommentCoordinator(
							reviewDataSource: value,
							navController: navController
						)
					)
				})
		)
	}
}

// MARK: - Private Methods

private extension ReviewRateCoordinator {
	
	func getReviewCommentCoordinator(
		reviewDataSource: ReviewDataSource,
		navController: UINavigationController
	) -> ReviewCommentCoordinator {
		return ReviewCommentCoordinator(
			navigationController: navController,
			assembler: self.assembler,
			reviewDataSource: reviewDataSource
		)
	}
	
	func getReviewRateViewController() -> UIViewController? {
		assembler.apply(
			assembly: ReviewRateAssembly(
				coordinator: self,
				reviewDataSource: reviewDataSource
			)
		)
		return assembler.resolver.resolve(ReviewRateViewController.self)
	}
}
