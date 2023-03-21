import UIKit
import RxSwift
import RxCocoa

final class PlaceholderTextView: UITextView {
	
	// MARK: - Nested
	
	private enum Constants {
		static let descriptionAlpha: CGFloat = 0.7
	}
	
	// MARK: - Private Properties
	
	private let disposeBag = DisposeBag()
	
	private let descriptionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		return label
	}()
	
	private var currentContentHeight: CGFloat = 0
	
	fileprivate var textViewChangeSize = PublishSubject<Void>()
	
	// MARK: - Public Properties
	
	var foregroundColor: UIColor? {
		get {
			return self.textColor
		}
		set {
			self.textColor = newValue
			self.descriptionLabel.textColor = newValue?.withAlphaComponent(
				Constants.descriptionAlpha
			)
		}
	}
	
	var textFont: UIFont? {
		get {
			return self.font
		}
		set {
			self.font = newValue
			self.descriptionLabel.font = newValue
		}
	}
	
	var placeholder: String? {
		get {
			return self.descriptionLabel.text
		}
		set {
			descriptionLabel.text = newValue
			self.currentContentHeight = self.sizeThatFits(self.contentSize).height
			layoutSubviews()
		}
	}
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		setupDelegate()
		setupBindings()
		configureUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func sizeThatFits(_ size: CGSize) -> CGSize {
		let contentHeight = super.sizeThatFits(size)
		let descriptionHeight = self.descriptionLabel.frame.height
		return CGSize(
			width: size.width,
			height: max(descriptionHeight, contentHeight.height)
		)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		configureLayout()
	}
}

// MARK: - BaseView

extension PlaceholderTextView: BaseView {
	
	func configureUI() {
		addSubview(descriptionLabel)
	}
	
	func configureLayout() {
		descriptionLabel.pin
			.left()
			.right()
			.top()
			.sizeToFit(.width)
	}
}

// MARK: - Private Methods

private extension PlaceholderTextView {
	
	func setupDelegate() {
		delegate = self
	}

	func setupBindings() {
		self.rx.text
			.distinctUntilChanged()
			.subscribe(onNext: { [weak self] _ in
				guard let self = self else { return }
				let newSize = self.sizeThatFits(self.contentSize)
				guard newSize.height != self.currentContentHeight else { return }
				self.currentContentHeight = newSize.height
				self.textViewChangeSize.onNext(())
			})
			.disposed(by: disposeBag)
	}
}

// MARK: - UITextViewDelegate

extension PlaceholderTextView: UITextViewDelegate {
	
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		descriptionLabel.isHidden = true
		return true
	}
	
	func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		descriptionLabel.isHidden = !textView.text.isEmpty
		return true
	}
}

extension Reactive where Base: PlaceholderTextView {
	var textViewChangeSize: ControlEvent<Void> {
		return ControlEvent(
			events: base.textViewChangeSize
				.debounce(.milliseconds(100), scheduler: MainScheduler.instance)
				.asObservable()
		)
	}
}
