//
//  CONTAINER.swift
//  BusanEduBook
//
//  Created by i-Mac on 2020/08/19.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit

class SLIDE_IN_TRANSITION: NSObject, UIViewControllerAnimatedTransitioning {
    
    var IS_PRESENTING = false
    let DIMMING_VIEW = UIButton()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let TO_VC = transitionContext.viewController(forKey: .to),
            let FROM_VC = transitionContext.viewController(forKey: .from) else { return }
        
        let CONTAINER_VIEW = transitionContext.containerView
        
        let FINAL_WIDTH = TO_VC.view.bounds.width
        let FINAL_HEIGHT = TO_VC.view.bounds.height
        
        if IS_PRESENTING {
            
            DIMMING_VIEW.backgroundColor = .black
            DIMMING_VIEW.alpha = 0.0
            DIMMING_VIEW.frame = CONTAINER_VIEW.bounds
            CONTAINER_VIEW.addSubview(DIMMING_VIEW)
            
            CONTAINER_VIEW.addSubview(TO_VC.view)
            TO_VC.view.frame = CGRect(x: -FINAL_WIDTH, y: 0.0, width: FINAL_WIDTH, height: FINAL_HEIGHT)
        }
        
        let TRANSFORM = { self.DIMMING_VIEW.alpha = 0.3; TO_VC.view.transform = CGAffineTransform(translationX: FINAL_WIDTH, y: 0.0) }
        let IDENTITY = { self.DIMMING_VIEW.alpha = 0.0; FROM_VC.view.transform = .identity }
        
        let DURATION = transitionDuration(using: transitionContext)
        let IS_CANCELLED = transitionContext.transitionWasCancelled
        
        UIView.animate(withDuration: DURATION, animations: {
            self.IS_PRESENTING ? TRANSFORM() : IDENTITY()
        }) { (_) in
            transitionContext.completeTransition(!IS_CANCELLED)
        }
    }
}

extension CONTACT: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = true
        return TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = false
        return TRANSITION
    }
}

extension SCHOOL_INFO: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = true
        return TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = false
        return TRANSITION
    }
}

extension HOME: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = true
        return TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = false
        return TRANSITION
    }
}

extension INDIVIDUAL_CONTACT: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = true
        return TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = false
        return TRANSITION
    }
}

extension SOSIK_N: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = true
        return TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = false
        return TRANSITION
    }
}

extension LOGIN: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = true
        return TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = false
        return TRANSITION
    }
}
