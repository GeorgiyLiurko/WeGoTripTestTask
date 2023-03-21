import Foundation

struct ReviewRateModel: Codable {
	enum Constants {
		static let defaultRate = 3
	}
	
	var guideRate: Int = Constants.defaultRate
	var overallRate: Int = Constants.defaultRate
	var informationRate: Int = Constants.defaultRate
	var navigationRate: Int = Constants.defaultRate
}
