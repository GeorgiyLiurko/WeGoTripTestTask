//
//  ReviewRateModel.swift
//  OneTwoTrip-TestTask
//
//  Created by Georg Lyurko on 19.03.2023.
//

import Foundation

struct ReviewRateModel: Codable {
	let reviewRate: Int
	let overallRate: Int
	let informationRate: Int
	let navigationRate: Int
}
