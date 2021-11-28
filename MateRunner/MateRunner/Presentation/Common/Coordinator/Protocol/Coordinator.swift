//
//  Coordinator.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/09.
//

import UIKit

protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var type: CoordinatorType { get }
    func start()
    func finish()
    func findCoordinator(type: CoordinatorType) -> Coordinator?
    
    init(_ navigationController: UINavigationController)
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    func findCoordinator(type: CoordinatorType) -> Coordinator? {
        var stack: [Coordinator] = [self]
        
        while !stack.isEmpty {
            let currentCoordinator = stack.removeLast()
            if currentCoordinator.type == type {
                return currentCoordinator
            }
            currentCoordinator.childCoordinators.forEach({ child in
                stack.append(child)
            })   
        }
        return nil
    }
}
