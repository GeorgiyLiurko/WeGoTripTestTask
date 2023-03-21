import Foundation

struct ReviewModel: Codable {
	var reviewRate: ReviewRateModel
	var reviewComment: ReviewCommentModel
	
	init(reviewRate: ReviewRateModel, reviewComment: ReviewCommentModel) {
		self.reviewRate = reviewRate
		self.reviewComment = reviewComment
	}
}
