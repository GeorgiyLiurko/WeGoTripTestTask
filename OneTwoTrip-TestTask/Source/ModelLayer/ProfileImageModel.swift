//
//  ProfileImageModel.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 20.03.2023.
//

import Foundation

// MARK: - ProfileImageModel

struct ProfileImageModel: Codable {
		let data: ProfileImageData
}

// MARK: - ProfileImageData

struct ProfileImageData: Codable {
		let author: ProfileImageAvatar
}

// MARK: - ProfileImageAvatar

struct ProfileImageAvatar: Codable {
		let avatar: String
}
