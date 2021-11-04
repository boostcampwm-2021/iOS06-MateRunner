//
//  RunningResultDTO.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/04.
//

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift

struct RunningResultDTO: Codable {
    private(set) var mode: RunningMode
    private(set) var targetDistance: Double
    private(set) var mateNickname: String?
    private(set) var dateTime: Date
    private(set) var userElapsedDistance: Double = 0
    private(set) var userElapsedTime: Int = 0
    private(set) var mateElapsedDistance: Double?
    private(set) var mateElapsedTime: Int?
    private(set) var kcal: Double = 0
    private(set) var points: [GeoPoint] = []
    private(set) var emojis: [String: Emoji] = [:]
    private(set) var isCanceled: Bool = false
}

struct UserDTO: Codable {
    var nickname: String
    let records: [RunningResultDTO]
}
