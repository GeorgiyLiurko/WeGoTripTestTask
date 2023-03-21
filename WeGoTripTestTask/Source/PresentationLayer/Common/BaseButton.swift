import UIKit
import RxSwift
import RxCocoa

class BaseButton: UIButton {
	
	// MARK: - Constants
	
	enum Constants {
		static let cornerRadius: CGFloat = 12
		static let heights: CGFloat = 55
	}
	
	// MARK: - Public Methods
	
	var isLoading = PublishSubject<Bool>()
	
	// MARK: - Private Properties
	
	fileprivate let disposeBag = DisposeBag()
	
	fileprivate let activityIndicator: UIActivityIndicatorView = {
		let activityIndicatorView = UIActivityIndicatorView()
		activityIndicatorView.style = .white
		return activityIndicatorView
	}()
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureUI()
		setupBindings()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		configureLayout()
	}
	
	override func sizeThatFits(_ size: CGSize) -> CGSize {
		return CGSize(width: size.width, height: Constants.heights)
	}
}

// MARK: - BaseView

extension BaseButton: BaseView {
	
	func configureUI() {
		backgroundColor = .systemBlue
		setTitleColor(.white, for: .normal)
		titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
		
		addSubview(activityIndicator)
	}
	
	func configureLayout() {
		layer.cornerRadius = Constants.cornerRadius
		activityIndicator.pin
			.right(16)
			.vCenter()
			.sizeToFit()
	}
}

// MARK: - Private Methods

private extension BaseButton {
	
	func setupBindings() {
		isLoading.subscribe(onNext: { [weak self] isLoading in
			guard let self = self, self.activityIndicator.isAnimating != isLoading else { return }
			if isLoading {
				self.activityIndicator.startAnimating()
			} else {
				self.activityIndicator.stopAnimating()
			}
		})
		.disposed(by: disposeBag)
	}
}
