//
//  ReviewTarget.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 19.03.2023.
//

import Foundation
import Moya

enum ReviewTarget: TargetType {
	
	// MARK: - Cases
	
	case setReviewRate(ReviewRateModel)
	case setReviewComment(ReviewCommentModel)
	
	// MARK: - Properties
	
	var path: String {
		switch self {
		case .setReviewRate:
			return "c8f2041c-c57e-433f-853f-1ef739702903"
		case .setReviewComment:
			return "c8f2041c-c57e-433f-853f-1ef739702903"
		}
	}
	
	var method: Moya.Method {
		return .post
	}
	
	var task: Moya.Task {
		switch self {
		case .setReviewRate(let requestModel):
			return .requestJSONEncodable(requestModel)
		case .setReviewComment(let requestModel):
			return .requestJSONEncodable(requestModel)
		}
	}
	
	var headers: [String : String]? {
		return nil
	}
	
	var baseURL: URL {
		return URL(string: "https://webhook.site/")!
	}
}
