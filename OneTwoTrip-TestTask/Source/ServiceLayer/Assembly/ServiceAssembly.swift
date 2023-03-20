//
//  ServiceAssembly.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 20.03.2023.
//

import Swinject
import Moya

struct ServiceAssembly: Assembly {
	
	func assemble(container: Container) {
		container.register(IProfileImageService.self) { _ in
			ProfileImageService(
				provider: MoyaProvider<ImageTarget>(),
				decoder: JSONDecoder()
			)
		}
		container.register(IReviewService.self) { _ in
			ReviewService(provider: MoyaProvider<ReviewTarget>())
		}
	}
}
