//
//  MainViewController.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 18.03.2023.
//

import UIKit
import ReactorKit

final class MainViewController: UIViewController, View {
	
	// MARK: - Properties
	
	var disposeBag = DisposeBag()
	let contentView = MainView()
	
	// MARK: - Public Methods
	
	func bind(reactor: MainViewModel) {}
	
	// MARK: - Lifecycle
	
	override func loadView() {
		view = contentView
	}
}
