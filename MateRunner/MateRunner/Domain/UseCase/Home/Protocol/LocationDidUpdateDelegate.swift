//
//  LocationDidUpdateDelegate.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/15.
//

import CoreLocation
import Foundation

protocol LocationDidUpdateDelegate: AnyObject {
    func locationDidUpdate(_ location: CLLocation)
}
