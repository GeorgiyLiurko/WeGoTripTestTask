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
		return .just(())
	}
	
	// MARK: - Private Methods
	
	private func getViewController() -> UIViewController? {
		assembler.apply(assembly: ReviewRateAssembly(coordinator: self))
		return assembler.resolver.resolve(ReviewRateViewController.self)
	}
}
