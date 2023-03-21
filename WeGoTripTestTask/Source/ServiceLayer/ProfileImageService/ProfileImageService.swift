import Foundation
import Moya
import RxSwift

struct ProfileImageService: IProfileImageService {
	
	// MARK: - Private Properties
	
	private let provider: MoyaProvider<ImageTarget>
	private let decoder: JSONDecoder
	
	// MARK: - Lifecycle
	
	init(provider: MoyaProvider<ImageTarget>, decoder: JSONDecoder) {
		self.provider = provider
		self.decoder = decoder
	}
	
	// MARK: - Public Methods
	
	func getAvatar() -> Observable<String> {
		provider.rx.request(.getProfileImage)
			.asObservable()
			.map(ProfileImageModel.self, using: decoder)
			.map({ $0.data.author.avatar })
	}
}
