//
//  Coordinator.swift
//  CoordinatorSample
//
//  Created by Zonily Jame Pesquera on 28/02/2018.
//

import UIKit

/*
 Thanks to these links:
 - https://www.iamsim.me/the-coordinator-pattern/
 - https://github.com/wtsnz/Coordinator-Example
 - http://khanlou.com/2015/10/coordinators-redux/
 - https://github.com/AndreyPanov/ApplicationCoordinator
 - https://medium.com/blacklane-engineering/coordinators-essential-tutorial-part-i-376c836e9ba7#.hgv4r6y6p
 */

/// A callback function used by coordinators to signal events.
public typealias CoordinatorCallback = (Coordinator) -> Void

public protocol Coordinator: class {

    var childCoordinators: [Coordinator] { get set }

    /// Tells the coordinator to create its
    /// initial view controller and take over the user flow.
    func start(withCallback completion: CoordinatorCallback?)

    /// Tells the coordinator that it is done and that it should
    /// rewind the view controller state to where it was before `start` was called.
    func stop(withCallback completion: CoordinatorCallback?)

}

public extension Coordinator {
    /// Add a child coordinator to the parent
    public func add(childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }

    /// Remove a child coordinator from the parent
    public func remove(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }

    /// Add a child coordinator to the parent
    /// and then start the flow.
    public func add(childCoordinator: Coordinator, andStart completion: CoordinatorCallback?) {
        self.add(childCoordinator: childCoordinator)
        childCoordinator.start(withCallback: completion)
    }

    /// Remove a child coordinator from the parent
    /// and the end the flow.
    public func remove(childCoordinator: Coordinator, andStop completion: CoordinatorCallback?) {
        self.remove(childCoordinator: childCoordinator)
        childCoordinator.stop(withCallback: completion)
    }
}

extension Coordinator where Self: PresentingControllerProvider & RootViewControllerProvider {
    func start(withCallback completion: CoordinatorCallback?) {
        self.presentingViewController.present(self.rootViewController, animated: true) {
            completion?(self)
        }
    }

    func stop(withCallback completion: CoordinatorCallback?) {
        self.presentingViewController.dismiss(animated: true) {
            completion?(self)
        }
    }
}

extension Coordinator where Self: PresentingControllerProvider & RootViewControllerProvider & NavigationControllerProvider {
    func start(withCallback completion: CoordinatorCallback?) {
        self.presentingViewController.present(self.navigationController, animated: true) {
            completion?(self)
        }
    }

    func stop(withCallback completion: CoordinatorCallback?) {
        self.presentingViewController.dismiss(animated: true) {
            completion?(self)
        }
    }
}
