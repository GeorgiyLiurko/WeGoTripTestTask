import Foundation
import RxSwift
import RxCocoa

protocol IProfileImageService {
	func getAvatar() -> Observable<String>
}
