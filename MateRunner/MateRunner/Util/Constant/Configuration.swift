//
//  Configuration.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/21.
//

import Foundation

enum Configuration {
    static let fcmServerKey: String = Bundle.main.infoDictionary?["FCM_SERVER_KEY"] as? String ?? ""
}
