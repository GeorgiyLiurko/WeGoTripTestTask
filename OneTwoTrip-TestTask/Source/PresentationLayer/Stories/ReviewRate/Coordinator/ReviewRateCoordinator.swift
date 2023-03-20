//
//  ReviewRateCoordinator.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import ReactiveCoordinator
import RxSwift
import Swinject

final class ReviewRateCoordinator: ReactiveCoordinator<Void> {
	
	// MARK: - Private Properties
	
	private let navigationController: UINavigationController
	private let assembler: Assembler
	
	// MARK: - Properties
	
	var close = PublishSubject<Void>()
	var openReviewComment = PublishSubject<Void>()
	
	// MARK: - Lifecycle
	
	init(
		navigationController: UINavigationController,
		assembler: Assembler
	) {
		self.assembler = assembler
		self.navigationController = navigationController
	}
	
	// MARK: - Public Method
	
	override func start() -> Observable<Void> {
		guard let controller = getViewController() else {
			return .empty()
		}
		controller.modalPresentationStyle = .overCurrentContext
		navigationController.topViewController?.present(
			controller,
			animated: false
		)
	
		return Observable.merge(
			close.do(onNext: { [controller] in
				controller.dismiss(animated: false)
			}),
			openReviewComment.asObservable()
				.flatMap({ [weak self, controller] _ -> Observable<Void> in
					guard let self = self else { return .empty() }
					controller.dismiss(animated: false)
					return self.coordinate(to: self.getReviewCommentCoordinator())
				})
		)
	}
	
	// MARK: - Private Methods
	
	private func getReviewCommentCoordinator() -> ReviewCommentCoordinator {
		return ReviewCommentCoordinator(
			navigationController: self.navigationController,
			assembler: self.assembler
		)
	}
	
	private func getViewController() -> UIViewController? {
		assembler.apply(assembly: ReviewRateAssembly(coordinator: self))
		return assembler.resolver.resolve(ReviewRateViewController.self)
	}
}
