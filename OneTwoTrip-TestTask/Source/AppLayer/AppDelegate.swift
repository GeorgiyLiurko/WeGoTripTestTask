//
//  AppDelegate.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	// MARK: - Properties
	
	var window: UIWindow?
	
	// MARK: - Private Properties
	
	private let disposeBag = DisposeBag()
	
	// MARK: - Public Methods
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		let window = UIWindow(frame: UIScreen.main.bounds)
		self.window = window
		
		AppCoordinator(window: window)
			.start()
			.subscribe()
			.disposed(by: disposeBag)
		
		return true
	}
}
