//
//  Point+CLLocation2D.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/17.
//

import CoreLocation
import Foundation

extension Point {
    func convertToCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: self.latitude,
            longitude: self.longitude
        )
    }
}
