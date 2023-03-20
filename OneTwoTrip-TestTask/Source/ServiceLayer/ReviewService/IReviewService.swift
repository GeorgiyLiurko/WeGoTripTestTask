//
//  IReviewService.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 19.03.2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol IReviewService {
	func sendReviewRate(reviewRate: ReviewRateModel) -> Observable<Void>
	func sendReviewComment(reviewComment: ReviewCommentModel) -> Observable<Void>
}
