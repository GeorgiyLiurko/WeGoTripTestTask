//
//  ImageTarget.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 19.03.2023.
//

import Foundation
import Moya

enum ImageTarget: TargetType {
	
	// MARK: - Cases
	
	case getProfileImage
	
	// MARK: - Properties
	
	var path: String {
		switch self {
		case .getProfileImage:
			return "api/v2/products/3728/"
		}
	}
	
	var method: Moya.Method {
		return .get
	}
	
	var task: Moya.Task {
		switch self {
		case .getProfileImage:
			return .requestPlain
		}
	}
	
	var headers: [String : String]? {
		return nil
	}
	
	var baseURL: URL {
		return URL(string: "https://app.wegotrip.com/")!
	}
}
