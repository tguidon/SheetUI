//
//  SheetViewController.swift
//  
//
//  Created by Taylor Guidon on 1/17/22.
//

import Combine
import SwiftUI
import UIKit

class SheetViewController<Content: View>: UIViewController, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - Properties

    @Binding private var isPresented: Bool
    /// The style to apply to the sheet presentation. For best results, use a `backgroundColor` that matches
    /// the given SwiftUI content.
    private let style: SheetViewStyle
    /// The SwiftUI content to render in the presented sheet
    private let content: Content
    /// The `UIHostingController` responsible for rendering the `content` and managing auto layout
    private let hostingViewController: UIHostingController<Content>
    /// Backing `UIView` intended to cover the safe area on phones with safe areas
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = self.style.backgroundColor
        return view
    }()
    /// The point of origin when the view is first rendered
    private var originPoint: CGPoint?
    /// The velocity threshold at which to determine if the view should be dismissed
    private let targetVelocity: CGFloat = 1000
    private let targetSwipeDistance: CGFloat = 40
    
    init(
        isPresented: Binding<Bool>,
        style: SheetViewStyle,
        content: Content
    ) {
        self._isPresented = isPresented
        self.content = content
        self.hostingViewController = UIHostingController(rootView: content)
        self.hostingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.style = style

        super.init(nibName: nil, bundle: nil)
        
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(containerView)

        self.addChild(hostingViewController)
        self.view.addSubview(hostingViewController.view)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: hostingViewController.view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            hostingViewController.view.topAnchor.constraint(greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40),
            hostingViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            hostingViewController.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.view.addGestureRecognizer(pan)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.isPresented = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.hostingViewController.view.addRoundedTopCorners()
        self.containerView.addRoundedTopCorners()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        self.hostingViewController.view.addRoundedTopCorners()
        self.containerView.addRoundedTopCorners()
        
        if self.originPoint == nil {
            self.originPoint = self.view.frame.origin
        }
    }
    
    // MARK: - Setup Methods
    
    /// On tap of the main view, the content behind the sheet, dismiss the view if `isModalInPresentation` is `false`
    @objc private func tappedView() {
        if self.isModalInPresentation {
            return
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    /// Handle pan gestures on the sheet. The sheet will be dismissed if any of the following are true:
    /// - Gesture velocity is greater than 1000
    /// - Translation
    /// - Parameter gesture: The incoming pan gesture the user is taking
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        
        guard translation.y >= 0 else {
            return
        }
        
        if let y = self.originPoint?.y {
            self.view.frame.origin.y = y + translation.y
        }
        
        switch gesture.state {
        case .ended:
            let velocity = gesture.velocity(in: self.view)
            if velocity.y > self.targetVelocity {
                self.dismiss(animated: true, completion: nil)
            }
            
            if translation.y > self.targetSwipeDistance {
                self.dismiss(animated: true, completion: nil)
            } else if let originPoint = self.originPoint {
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0.0,
                    options: [.allowUserInteraction]
                ) {
                    self.view.frame.origin = originPoint
                }
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return SheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.hostingViewController.view) == true {
            return false
        }
        return true
    }
}

