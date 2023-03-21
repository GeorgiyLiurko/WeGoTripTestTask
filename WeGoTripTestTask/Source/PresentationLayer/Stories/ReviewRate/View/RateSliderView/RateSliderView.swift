import UIKit
import PinLayout
import RxCocoa
import RxSwift

final class RateSliderView: UIView {
	
	private enum Constants {
		static let sliderCircleSize: CGFloat = 8
	}
	
	// MARK: - Properties
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
		return label
	}()
	
	private let emojiLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
		return label
	}()
	
	private(set) var rateSlider: ThinSlider = {
		let slider = ThinSlider()
		slider.minimumValue = 0
		slider.maximumValue = 4
		slider.tintColor = R.color.customGray()
		slider.value = 2
		return slider
	}()
	
	private let sliderBackView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}()
	
	private let feedbackGenerator: UIImpactFeedbackGenerator
	private let disposeBag = DisposeBag()
	private var sliderBackViewCircles: [UIView] = []
	
	// MARK: - Lifecycle
	
	init(feedbackGenerator: UIImpactFeedbackGenerator = .init(style: .light)) {
		self.feedbackGenerator = feedbackGenerator
		super.init(frame: .zero)
		configureUI()
		setupBindings()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func sizeThatFits(_ size: CGSize) -> CGSize {
		return CGSize(width: size.width, height: rateSlider.frame.maxY)
	}
	
	// MARK: - Public Methods
	
	func prepare(title: String) {
		titleLabel.text = title
		layoutSubviews()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		configureLayout()
	}
}

// MARK: - RateSliderView

extension RateSliderView: BaseView {
	
	func configureUI() {
		addSubview(titleLabel)
		addSubview(emojiLabel)
		addSubview(sliderBackView)
		addSubview(rateSlider)
		
		let rateSliderRange = Int(rateSlider.minimumValue)...Int(rateSlider.maximumValue)
		
		for _ in rateSliderRange {
			let view = getCircleView()
			sliderBackViewCircles.append(view)
			sliderBackView.addSubview(view)
		}
	}
	
	func configureLayout() {
		emojiLabel.pin
			.right()
			.top()
			.sizeToFit()
		
		titleLabel.pin
			.left(-8)
			.top()
			.right(to: emojiLabel.edge.left).marginLeft(8)
			.sizeToFit(.width)
		
		sliderBackView.pin
			.left()
			.right()
			.bottom()
			.height(30)
			.top(to: titleLabel.edge.bottom).marginTop(16)
		
		rateSlider.pin
			.left()
			.right()
			.bottom()
			.height(30)
			.top(to: titleLabel.edge.bottom).marginTop(16)
		
		layoutCircles()
	}
}

// MARK: - Private Methods

private extension RateSliderView {
	
	func getCircleView() -> UIView {
		let view = UIView()
		view.backgroundColor = R.color.customGray()
		return view
	}
	
	func layoutCircles() {
		guard let firstView = sliderBackViewCircles.first else { return }
		guard let lastView = sliderBackViewCircles.last else { return }
		
		firstView.pin
			.left(2)
			.vCenter(1)
			.size(Constants.sliderCircleSize)
		
		lastView.pin
			.right(2)
			.vCenter(1)
			.size(Constants.sliderCircleSize)
		
		firstView.layer.cornerRadius = firstView.frame.width / 2
		lastView.layer.cornerRadius = firstView.frame.width / 2
		
		let width = lastView.frame.minX - firstView.frame.maxX
		guard width > 0 else { return }
		
		for (index, circle) in sliderBackViewCircles.enumerated() {
			let lastIndex = sliderBackViewCircles.count - 1
			guard index != 0, index != lastIndex else { continue }
			
			let positionPercent = CGFloat(index) / CGFloat(lastIndex)
			let positionInfelicity = (CGFloat(Constants.sliderCircleSize) / CGFloat(width)) / 2
			let positionOffset = (positionPercent + positionInfelicity) * width
			
			circle.pin
				.left(positionOffset)
				.vCenter(1)
				.size(Constants.sliderCircleSize)
			circle.layer.cornerRadius = firstView.frame.width / 2
		}
	}
	
	func setupBindings() {
		self.rateSlider.rx.value
			.map({ value in value.rounded(.toNearestOrEven) })
			.subscribe(onNext: { [weak self] value in
				self?.rateSlider.value = value
				self?.feedbackGenerator.impactOccurred()
				self?.emojiLabel.text = RateEmoji(value: Int(value)).rawValue
			})
			.disposed(by: disposeBag)
	}
}

extension Reactive where Base: RateSliderView {
	var selectedValue: ControlEvent<Int> {
		return ControlEvent(
			events: base.rateSlider.rx.value
				.map({ Int($0) })
				.asObservable()
		)
	}
}
