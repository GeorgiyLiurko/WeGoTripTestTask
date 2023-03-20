//
//  IProfileImageService.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 20.03.2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol IProfileImageService {
	func getAvatar() -> Observable<String>
}
