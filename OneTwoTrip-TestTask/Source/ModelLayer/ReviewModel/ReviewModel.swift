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
	
	init(reviewRate: ReviewRateModel, reviewComment: ReviewCommentModel) {
		self.reviewRate = reviewRate
		self.reviewComment = reviewComment
	}
}
