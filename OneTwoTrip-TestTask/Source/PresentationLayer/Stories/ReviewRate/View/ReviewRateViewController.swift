//
//  ReviewRateViewController.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

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
}
