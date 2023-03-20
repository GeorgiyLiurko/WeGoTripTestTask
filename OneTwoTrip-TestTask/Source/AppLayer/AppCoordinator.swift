//
//  AppCoordinator.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import ReactiveCoordinator
import RxSwift
import Swinject

final class AppCoordinator: ReactiveCoordinator<Void> {
	
	// MARK: - Private Properties
	
	private let assembler: Assembler = Assembler()
	private let window: UIWindow
	
	// MARK: - Lifecycle
	
	init(window: UIWindow) {
		self.window = window
	}
	
	// MARK: - Public Methods
	
	override func start() -> Observable<Void> {
		let navigationController = UINavigationController()
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
		registerServices()
		let mainCoordinator = MainCoordinator(
			navigationController: navigationController,
			assembler: assembler
		)
		return mainCoordinator.start()
	}
}

// MARK: - Private Methods

private extension AppCoordinator {
	
	func registerServices() {
		self.assembler.apply(assembly: ServiceAssembly())
	}
}
