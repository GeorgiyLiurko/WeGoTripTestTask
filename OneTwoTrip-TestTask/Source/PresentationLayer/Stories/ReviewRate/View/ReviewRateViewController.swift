//
//  ReviewRateViewController.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import UIKit
import ReactorKit
import RxSwift

final class ReviewRateViewController: UIViewController, View {
	
	// MARK: - Properties
	
	var disposeBag = DisposeBag()
	
	// MARK: - Private Properties
	
	private let contentView = ReviewRateView()
	
	// MARK: - Lifecycle
	
	override func loadView() {
		view = contentView
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		contentView.animateOpening()
	}
	
	// MARK: - Public Methods
	
	func bind(reactor: ReviewRateViewModel) {}
}
