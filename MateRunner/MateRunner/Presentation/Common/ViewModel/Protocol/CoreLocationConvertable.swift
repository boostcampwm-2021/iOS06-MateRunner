//
//  CoreLocationCalculatable.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/12/03.
//

import CoreLocation
import Foundation

protocol CoreLocationConvertable {
    func pointsToCoordinate2D(from points: [Point]) -> [CLLocationCoordinate2D]
    func calculateRegion(from points: [CLLocationCoordinate2D]) -> Region
}

extension CoreLocationConvertable {
    func pointsToCoordinate2D(from points: [Point]) -> [CLLocationCoordinate2D] {
        return points.map { location in location.convertToCLLocationCoordinate2D() }
    }
    
    func calculateRegion(from points: [CLLocationCoordinate2D]) -> Region {
        guard !points.isEmpty else { return Region() }
        
        let latitudes = points.map { $0.latitude }
        let longitudes = points.map { $0.longitude }
        
        guard let maxLatitude = latitudes.max(),
              let minLatitude = latitudes.min(),
              let maxLongitude = longitudes.max(),
              let minLongitude = longitudes.min() else { return Region() }
        
        let meanLatitude = (maxLatitude + minLatitude) / 2
        let meanLongitude = (maxLongitude + minLongitude) / 2
        let coordinate = CLLocationCoordinate2DMake(meanLatitude, meanLongitude)
        
        let latitudeSpan = (maxLatitude - minLatitude) * 1.5
        let longitudeSpan = (maxLongitude - minLongitude) * 1.5
        let span = (latitudeSpan, longitudeSpan)
        
        return Region(center: coordinate, span: span)
    }
}
