//
//  ReviewCommentCoordinator.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 19.03.2023.
//

import Foundation
import RxSwift
import RxCocoa
import Swinject
import ReactiveCoordinator

final class ReviewCommentCoordinator: ReactiveCoordinator<Void> {
	
	// MARK: - Private Properties
	
	private let navigationController: UINavigationController
	private let assembler: Assembler
	
	// MARK: - Properties
	
	var close = PublishSubject<Void>()
	
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
		
		return close.do(onNext: { [controller] in
			controller.dismiss(animated: false)
		})
	}
	
	// MARK: - Private Methods
	
	private func getViewController() -> UIViewController? {
		assembler.apply(assembly: ReviewCommentAssembly(coordinator: self))
		return assembler.resolver.resolve(ReviewCommentViewController.self)
	}
}
