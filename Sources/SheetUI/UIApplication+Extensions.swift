//
//  File.swift
//  
//
//  Created by Taylor Guidon on 1/17/22.
//

import UIKit

extension UIApplication {

    /// Returns the root `UIViewController` for the given activation states.
    /// - Parameter activationStates: The `states` to check for the given connected scene
    /// - Returns: A root `UIViewController` if found
    func getRootViewController(
        activationStates: [UIScene.ActivationState] = [.foregroundActive, .foregroundInactive]
    ) -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { scene in
            return activationStates.contains(scene.activationState)
        }) as? UIWindowScene else {
            return nil
        }
        
        guard let keyWindow = windowScene.windows.first(where: { window in
            return window.isKeyWindow
        }) else {
            return nil
        }
        
        return keyWindow.rootViewController
    }
    
    /// Returns the view controller to present content on. If a root controller exists, we first check
    /// for a presenting view controller. If not found, the root view controller will be used. If a
    /// presenting view controller is found and it is being dismissed, we will fall back to the
    /// If the VC is being dismissed, it
    var presentingViewController: UIViewController? {
        guard let rootViewController = self.getRootViewController() else {
            return nil
        }

        var presentingViewController = rootViewController.presentedViewController ?? rootViewController
        if rootViewController.presentedViewController?.isBeingDismissed == true {
            presentingViewController = rootViewController
        }

        return presentingViewController
    }
}
