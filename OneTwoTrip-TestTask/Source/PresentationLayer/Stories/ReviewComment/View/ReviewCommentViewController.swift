//
//  ReviewCommentViewController.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 19.03.2023.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import Kingfisher

final class ReviewCommentViewController: UIViewController, View {
	
	// MARK: - Properties
	
	var disposeBag = DisposeBag()
	
	// MARK: - Private Properties
	
	private let contentView = ReviewCommentView(
		settings: BaseReviewView.ReviewSettings(openState: .opened)
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
	
	func bind(reactor: ReviewCommentViewModel) {
		Observable.merge(
			contentView.rx.skip.map({ _ in () }),
			reactor.state.map({ $0.reviewSent })
				.distinctUntilChanged()
				.filter({ $0 }).map({ _ in () })
		)
		.subscribe(onNext: { [weak self] _ in
			self?.contentView.animateClosing()
		})
		.disposed(by: disposeBag)
		
		reactor.state.map({ $0.isLoading })
			.bind(to: contentView.saveReviewButton.isLoading)
			.disposed(by: disposeBag)
		
		contentView.rx.saveReview
			.map({ Reactor.Action.sendReview })
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		contentView.rx.didClose.map({ Reactor.Action.close })
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		reactor.state.compactMap({ $0.reviewDataSource.avatarUrl })
			.subscribe { [weak self] url in
				guard let self = self else { return }
				self.contentView.profileImageView.kf.setImage(with: url)
			}
			.disposed(by: disposeBag)
	}
}

