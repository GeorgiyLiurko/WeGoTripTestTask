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
