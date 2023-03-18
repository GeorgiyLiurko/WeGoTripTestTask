//
//  MainCoordinator.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import ReactiveCoordinator
import RxSwift
import Swinject

final class MainCoordinator: ReactiveCoordinator<Void> {
	
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
		assembler.apply(assembly: MainAssembly(coordinator: self))
		guard let controller = getViewController() else {
			return .empty()
		}
		navigationController.pushViewController(
			controller,
			animated: false
		)
		return .just(())
	}
	
	// MARK: - Private Methods
	
	private func getViewController() -> UIViewController? {
		assembler.apply(assembly: MainAssembly(coordinator: self))
		return assembler.resolver.resolve(MainViewController.self)
	}
}
