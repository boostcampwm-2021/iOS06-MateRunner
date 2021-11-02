//
//  BehaviorRelayProperty.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/01.
//
import Foundation
import RxCocoa
import RxSwift

@propertyWrapper
public struct BehaviorRelayProperty<Value> {
    private var subject: BehaviorRelay<Value>
    public var wrappedValue: Value {
        get { subject.value }
        set { subject.accept(newValue) }
    }
    
    public var projectedValue: BehaviorRelay<Value> {
        return self.subject
    }
    
    public init(wrappedValue: Value) {
        subject = BehaviorRelay(value: wrappedValue)
    }
}
