import UIKit
import ReactorKit

final class MainViewController: UIViewController, View {
	
	// MARK: - Properties
	
	var disposeBag = DisposeBag()
	let contentView = MainView()
	
	// MARK: - Public Methods
	
	func bind(reactor: MainViewModel) {
		reactor.action.onNext(.load)
		
		reactor.state.map({ $0.isLoading })
			.bind(to: contentView.reviewButton.isLoading)
			.disposed(by: disposeBag)
		
		contentView.reviewButton.rx.tap
			.map({ Reactor.Action.writeReview })
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
	}
	
	// MARK: - Lifecycle
	
	override func loadView() {
		view = contentView
	}
}
