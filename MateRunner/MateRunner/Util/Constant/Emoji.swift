//
//  Emoji.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/03.
//

import Foundation

enum Emoji: String, Codable {
	case tear = "🥲"
	case running = "🏃‍♀️"
	case ribbonHeart = "💝"
	case clap = "👏"
	case fire = "🔥"
	case burningHeart = "❤️‍🔥"
	case thumbsUp = "👍"
	case strong = "💪"
	case lovely = "🥰"
	case okay = "🙆‍♂️"
	case twoHandsUp = "🙌"
	case flower = "🌷"
    
    func icon() -> String {
        return self.rawValue
    }
}
