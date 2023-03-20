//
//  ReviewCommentView.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 19.03.2023.
//

import UIKit
import PinLayout
import RxSwift
import RxCocoa

final class ReviewCommentView: BaseReviewView {
	
	// MARK: - Properties Properties
	
	private let disposeBag = DisposeBag()
	
	private let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.showsVerticalScrollIndicator = false
		scrollView.backgroundColor = .clear
		return scrollView
	}()
	
	private let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	private let likeCommentTitleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.text = R.string.localizable.likeInTourTitle()
		label.font = .preferredFont(forTextStyle: .title2)
		return label
	}()
	
	private let likeCommentTextView: PlaceholderTextView = {
		let textView = PlaceholderTextView()
		textView.textFont = .preferredFont(forTextStyle: .title2)
		textView.foregroundColor = .black
		textView.isScrollEnabled = false
		textView.placeholder = R.string.localizable.commentTourPlaceholder()
		return textView
	}()
	
	private let improvementCommentTitleLbale: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.text = R.string.localizable.improveTourTitle()
		label.font = .preferredFont(forTextStyle: .title2)
		return label
	}()
	
	private let improvementCommentTextView: PlaceholderTextView = {
		let textView = PlaceholderTextView()
		textView.placeholder = R.string.localizable.commentTourPlaceholder()
		textView.textFont = .preferredFont(forTextStyle: .title2)
		textView.foregroundColor = .black
		textView.isScrollEnabled = false
		return textView
	}()
	
	private let saveReviewButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = .systemBlue
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
		button.setTitle(R.string.localizable.saveReview(), for: .normal)
		return button
	}()
	
	private(set) var skipButton: UIButton = {
		let button = UIButton()
		button.setTitle(R.string.localizable.skip(), for: .normal)
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
		setupBindings()
	}
}

// MARK: - BaseView

extension ReviewCommentView: BaseView {
	
	func configureUI() {
		addSubviewToContainer(scrollView)
		
		scrollView.addSubview(profileImageView)
		scrollView.addSubview(likeCommentTitleLabel)
		scrollView.addSubview(likeCommentTextView)
		
		scrollView.addSubview(improvementCommentTitleLbale)
		scrollView.addSubview(improvementCommentTextView)
		
		addSubviewToContainer(saveReviewButton)
		addSubviewToContainer(skipButton)
	}
	
	func configureLayout() {
		skipButton.pin
			.bottom(safeAreaInsets.bottom + 16)
			.left(safeAreaInsets.left + 16)
			.right(safeAreaInsets.right + 16)
			.height(35)
		
		saveReviewButton.pin
			.bottom(to: skipButton.edge.top).marginBottom(16)
			.right(safeAreaInsets.right + 16)
			.left(safeAreaInsets.left + 16)
			.height(60)
		
		saveReviewButton.layer.cornerRadius = 12
		
		scrollView.pin
			.top()
			.right()
			.left()
			.bottom(to: saveReviewButton.edge.top).marginTop(16)
		
		profileImageView.pin
			.top(16)
			.left(16)
			.size(100)
		
		likeCommentTitleLabel.pin
			.top(to: profileImageView.edge.bottom).marginTop(16)
			.left(safeAreaInsets.left + 16)
			.right(safeAreaInsets.right + 16)
			.sizeToFit(.width)
		
		likeCommentTextView.pin
			.top(to: likeCommentTitleLabel.edge.bottom).marginTop(8)
			.left(safeAreaInsets.left + 16)
			.right(safeAreaInsets.right + 16)
			.sizeToFit(.width)
		
		improvementCommentTitleLbale.pin
			.top(to: likeCommentTextView.edge.bottom).marginTop(32)
			.left(safeAreaInsets.left + 16)
			.right(safeAreaInsets.right + 16)
			.sizeToFit(.width)
		
		improvementCommentTextView.pin
			.top(to: improvementCommentTitleLbale.edge.bottom).marginTop(8)
			.left(safeAreaInsets.left + 16)
			.right(safeAreaInsets.right + 16)
			.sizeToFit(.width)
		
		scrollView.contentSize = CGSize(
			width: frame.width,
			height: improvementCommentTextView.frame.maxY
		)
	}
}

// MARK: - Private Methods

private extension ReviewCommentView {
	
	func setupBindings() {
		rx.containerViewTapped.subscribe(onNext: { [weak self] _ in
			self?.improvementCommentTextView.resignFirstResponder()
			self?.likeCommentTextView.resignFirstResponder()
		})
		.disposed(by: disposeBag)
		
		Observable.merge(
			likeCommentTextView.rx.textViewChangeSize.map({ () }),
			improvementCommentTextView.rx.textViewChangeSize.map({ () })
		)
		.subscribe(onNext: { [weak self] _ in
			self?.setNeedsLayout()
		})
		.disposed(by: disposeBag)
	}
}
