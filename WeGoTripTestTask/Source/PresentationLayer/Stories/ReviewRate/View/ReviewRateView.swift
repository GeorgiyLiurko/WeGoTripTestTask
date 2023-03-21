import UIKit
import PinLayout
import RxSwift
import RxCocoa

final class ReviewRateView: BaseReviewView {
	
	// MARK: - Properties Properties
	
	private let disposeBag = DisposeBag()
	
	private let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.showsVerticalScrollIndicator = false
		scrollView.backgroundColor = .clear
		return scrollView
	}()
	
	private(set) var profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.text = R.string.localizable.reviewRateTitle()
		label.numberOfLines = 0
		label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
		label.textColor = .black
		return label
	}()
	
	private(set) var overallRate: RateSliderView = RateSliderView()
	private(set) var guideRate: RateSliderView = RateSliderView()
	private(set) var informationRate: RateSliderView = RateSliderView()
	private(set) var navigationRate: RateSliderView = RateSliderView()
	
	private(set) var nextButton: BaseButton = {
		let button = BaseButton()
		button.setTitle(R.string.localizable.next(), for: .normal)
		return button
	}()
	
	private(set) var declineButton: UIButton = {
		let button = UIButton()
		button.setTitle(R.string.localizable.declineAnswer(), for: .normal)
		button.setTitleColor(.systemGray, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
		return button
	}()
	
	// MARK: - Lifecycle
	
	override init(
		settings: BaseReviewView.ReviewSettings,
		frame: CGRect = .zero
	) {
		super.init(settings: settings, frame: frame)
		configureUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		configureLayout()
	}
}

// MARK: - BaseView

extension ReviewRateView: BaseView {
	
	func configureUI() {
		addSubviewToContainer(scrollView)

		scrollView.addSubview(profileImageView)
		scrollView.addSubview(titleLabel)

		scrollView.addSubview(overallRate)
		overallRate.prepare(title: R.string.localizable.overallRateTitle())
		
		scrollView.addSubview(guideRate)
		guideRate.prepare(title: R.string.localizable.guideRateTitle())
		
		scrollView.addSubview(informationRate)
		informationRate.prepare(title: R.string.localizable.informationRateTitle())
		
		scrollView.addSubview(navigationRate)
		navigationRate.prepare(title: R.string.localizable.navigationRateTitle())
		
		addSubviewToContainer(nextButton)
		addSubviewToContainer(declineButton)
	}
	
	func configureLayout() {
		declineButton.pin
			.bottom(safeAreaInsets.bottom + 16)
			.left(safeAreaInsets.left + 16)
			.right(safeAreaInsets.right + 16)
			.height(35)
		
		nextButton.pin
			.bottom(to: declineButton.edge.top).marginBottom(16)
			.right(safeAreaInsets.right + 16)
			.left(safeAreaInsets.left + 16)
			.sizeToFit(.width)
				
		scrollView.pin
			.top()
			.right()
			.left()
			.bottom(to: nextButton.edge.top).marginTop(16)
		
		profileImageView.pin
			.top(16)
			.left(16)
			.size(100)
		
		titleLabel.pin
			.top(to: profileImageView.edge.bottom).marginTop(16)
			.left(safeAreaInsets.left + 16)
			.right(safeAreaInsets.right + 16)
			.sizeToFit(.width)
		
		overallRate.pin
			.top(to: titleLabel.edge.bottom).marginTop(32)
			.left(safeAreaInsets.left + 16)
			.right(safeAreaInsets.right + 16)
			.sizeToFit(.width)
		
		guideRate.pin
			.top(to: overallRate.edge.bottom).marginTop(16)
			.left(safeAreaInsets.left + 16)
			.right(safeAreaInsets.right + 16)
			.sizeToFit(.width)
		
		informationRate.pin
			.top(to: guideRate.edge.bottom).marginTop(16)
			.left(safeAreaInsets.left + 16)
			.right(safeAreaInsets.right + 16)
			.sizeToFit(.width)
		
		navigationRate.pin
			.top(to: informationRate.edge.bottom).marginTop(16)
			.left(safeAreaInsets.left + 16)
			.right(safeAreaInsets.right + 16)
			.sizeToFit(.width)
		
		scrollView.contentSize = CGSize(
			width: frame.width,
			height: navigationRate.frame.maxY
		)
	}
}
