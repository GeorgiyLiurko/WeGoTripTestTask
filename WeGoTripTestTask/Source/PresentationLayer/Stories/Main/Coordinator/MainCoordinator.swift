import ReactiveCoordinator
import RxSwift
import Swinject
import RxCocoa

struct ReviewDataSource {
	var avatarUrl: URL?
	var model: ReviewModel
}

final class MainCoordinator: ReactiveCoordinator<Void> {
	
	// MARK: - Private Properties
	
	private weak var navigationController: UINavigationController?
	private let assembler: Assembler
	
	// MARK: - Properties
	
	var showReview = PublishSubject<ReviewDataSource>()
	
	// MARK: - Lifecycle
	
	init(
		navigationController: UINavigationController,
		assembler: Assembler
	) {
		self.assembler = assembler
		self.navigationController = navigationController
	}
	
	// MARK: - Public Method
	
	override func start() -> Observable<Void> {
		assembler.apply(assembly: MainAssembly(coordinator: self))
		guard let controller = getMainViewController(),
					let navController = self.navigationController else {
			return .empty()
		}
		navigationController?.pushViewController(
			controller,
			animated: false
		)
		
		return showReview
			.flatMap { [weak self, navController] reviewDataSource -> Observable<Void> in
				guard let self = self else { return .empty() }
				let reviewCoordinator = ReviewRateCoordinator(
					navigationController: navController,
					assembler: self.assembler,
					reviewDataSource: reviewDataSource
				)
				return self.coordinate(to: reviewCoordinator)
			}
	}
}

// MARK: - Private Methods

private extension MainCoordinator {
	
	func getMainViewController() -> MainViewController? {
		assembler.apply(assembly: MainAssembly(coordinator: self))
		return assembler.resolver.resolve(MainViewController.self)
	}
}
