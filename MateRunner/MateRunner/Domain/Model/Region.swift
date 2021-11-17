//
//  Region.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/17.
//

import CoreLocation
import Foundation

struct Region {
    private(set) var center: CLLocationCoordinate2D
    private(set) var span: (Double, Double)
    
    init() {
        self.center = CLLocationCoordinate2DMake(0, 0)
        self.span = (0, 0)
    }
    
    init(center: CLLocationCoordinate2D, span: (Double, Double)) {
        self.center = center
        self.span = span
    }
}
