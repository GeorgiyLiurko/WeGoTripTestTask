//
//  ReviewModel.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 19.03.2023.
//

import Foundation

struct ReviewModel: Codable {
	var reviewRate: ReviewRateModel
	var reviewComment: ReviewCommentModel
}
