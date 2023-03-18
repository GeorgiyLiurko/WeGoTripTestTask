//
//  MainCoordinator.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import ReactiveCoordinator
import RxSwift
import Swinject
import RxCocoa

final class MainCoordinator: ReactiveCoordinator<Void> {
	
	// MARK: - Private Properties
	
	private let navigationController: UINavigationController
	private let assembler: Assembler
	
	// MARK: - Properties
	
	var showReview = PublishSubject<Void>()
	
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
		assembler.apply(assembly: MainAssembly(coordinator: self))
		guard let controller = getViewController() else {
			return .empty()
		}
		navigationController.pushViewController(
			controller,
			animated: false
		)
		return showReview.flatMap { [weak self] _ -> Observable<Void> in
			guard let self = self else { return .empty() }
			let reviewCoordinator = ReviewRateCoordinator(
				navigationController: self.navigationController,
				assembler: self.assembler
			)
			return self.coordinate(to: reviewCoordinator)
		}
	}
}

// MARK: - Private Methods

private extension MainCoordinator {
	
	func getViewController() -> MainViewController? {
		assembler.apply(assembly: MainAssembly(coordinator: self))
		return assembler.resolver.resolve(MainViewController.self)
	}
}
