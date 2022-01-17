//
//  SheetPresentationController.swift
//  
//
//  Created by Taylor Guidon on 1/17/22.
//

import UIKit

class SheetPresentationController: UIPresentationController {
    
    private let cornerRadius: CGFloat = 20
    private let presentationTransform = CGAffineTransform(scaleX: 0.95, y: 0.95)
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        self.containerView?.backgroundColor = .clear
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        self.presentingViewController.view.clipsToBounds = true
        
        guard let coordinator = presentingViewController.transitionCoordinator else {
            return
        }

        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)

            strongSelf.presentingViewController.view.transform = strongSelf.presentationTransform
            strongSelf.presentingViewController.view.layer.cornerRadius = strongSelf.cornerRadius
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        guard let coordinator = presentingViewController.transitionCoordinator else {
            return
        }

        coordinator.animate { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.containerView?.backgroundColor = .clear

            strongSelf.presentingViewController.view.transform = .identity
            strongSelf.presentingViewController.view.layer.cornerRadius = .zero
        } completion: { [weak self] _ in
            self?.presentingViewController.view.clipsToBounds = true
        }
    }
}

