//
//  Swinject+Extension.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 20.03.2023.
//

import Swinject

extension Resolver {
	func forceResolve<Service>(_ serviceType: Service.Type, name: String? = nil) -> Service {
		resolve(serviceType, name: name)! 
	}
}
