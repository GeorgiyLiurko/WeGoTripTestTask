import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import Kingfisher

final class ReviewRateViewController: UIViewController, View {
	
	// MARK: - Properties
	
	var disposeBag = DisposeBag()
	
	// MARK: - Private Properties
	
	private let contentView = ReviewRateView(
		settings: BaseReviewView.ReviewSettings(openState: .closed)
	)
	
	// MARK: - Lifecycle
	
	override func loadView() {
		view = contentView
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		contentView.animateOpening()
	}
	
	// MARK: - Public Methods
	
	func bind(reactor: ReviewRateViewModel) {
		setupNavigationBindings(reactor: reactor)
		setupRateSlidersBinding(reactor: reactor)
		
		reactor.state.compactMap({ $0.reviewDataSource.avatarUrl })
			.subscribe { [weak self] url in
				guard let self = self else { return }
				self.contentView.profileImageView.kf.setImage(with: url)
			}
			.disposed(by: disposeBag)
	}
}

// MARK: - Private Methods

private extension ReviewRateViewController {
	
	func setupNavigationBindings(reactor: ReviewRateViewModel) {
		setupRateSlidersBinding(reactor: reactor)
		
		reactor.state.map({ $0.isLoading })
			.bind(to: contentView.nextButton.isLoading)
			.disposed(by: disposeBag)
		
		contentView.declineButton.rx.tap
			.subscribe(onNext: { [weak self] _ in
				self?.contentView.animateClosing()
			})
			.disposed(by: disposeBag)
		
		contentView.nextButton.rx.tap
			.map({ Reactor.Action.sendReview })
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		contentView.rx.didClose.map({ Reactor.Action.close })
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
	}
	
	func setupRateSlidersBinding(reactor: ReviewRateViewModel) {
		contentView.informationRate.rx.selectedValue
			.map { value in
				return Reactor.Action.informationRateChanged(value)
			}
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		contentView.overallRate.rx.selectedValue
			.map { value in
				return Reactor.Action.overallRateChanged(value)
			}
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		contentView.guideRate.rx.selectedValue
			.map { value in
				return Reactor.Action.guideRateChanged(value)
			}
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		contentView.navigationRate.rx.selectedValue
			.map { value in
				return Reactor.Action.navigationRateChanged(value)
			}
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
	}
}
