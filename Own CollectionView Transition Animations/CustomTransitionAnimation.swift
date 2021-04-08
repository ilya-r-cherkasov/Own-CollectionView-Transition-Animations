//
//  SecondCustomTransition.swift
//  Search Bar and Custom Transition
//
//  Created by Ilya Cherkasov on 07.04.2021.
//

import UIKit

class CustomTransitionAnimation: NSObject {
    
    var executeWhileAnimationTo: (() -> ())?
    var executeWhileAnimationFrom: (() -> ())?
    var bufferImageView = UIImageView()
    var image: Image?
    var startingPoint = CGPoint.zero
    var imageStartingPoint = CGPoint.zero
    var duration = 0.2
    enum CustomTransitionMode: Int {
        case pop, dismiss, present
    }
    var customTransitionMode: CustomTransitionMode = .present
}

extension CustomTransitionAnimation: UIViewControllerAnimatedTransitioning {
    
    func trackViewAnimation(animate: @escaping () -> (), completion: @escaping (Bool) -> (), execute: @escaping () -> ()) {
        var flag = true
        UIView.animate(withDuration: duration) {
            animate()
        } completion: { (success) in
            completion(success)
            flag = false
        }
        DispatchQueue.global(qos: .userInteractive).async {
            while flag {
                DispatchQueue.main.sync {
                    execute()
                }
            }
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        if customTransitionMode == .present {
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                let viewCenter = presentedView.center
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 180, height: 180))
                containerView.addSubview(presentedView)
                containerView.addSubview(imageView)
                presentedView.center = startingPoint
                imageView.center = imageStartingPoint
                imageView.image = image!.cropImage()
                executeWhileAnimationTo?()
                trackViewAnimation() { [unowned self] in
                    presentedView.transform = CGAffineTransform.identity
                    presentedView.center = viewCenter
                    imageView.center = viewCenter
                    let width = image!.image.size.width
                    let height = image!.image.size.height
                    let k = height / width
                    let scaleX =  (UIScreen.main.bounds.width - 40) / imageView.frame.size.width
                    let scaleY =  (UIScreen.main.bounds.height - 40) / imageView.frame.size.height
                    let scale = min(scaleX, scaleY)
                    imageView.transform = CGAffineTransform.init(scaleX: scale, y: scale * k)
                } completion: { [unowned self] (success) in
                    transitionContext.completeTransition(success)
                    bufferImageView = imageView
                } execute: { [unowned self] in
                    image!.containerSize = imageView.layer.presentation()!.frame.size
                    imageView.image = image!.cropImage()
                }
            }
        }
        if customTransitionMode == .dismiss {
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
                let viewCenter = presentedView.center
                let imageView = bufferImageView
                containerView.addSubview(presentedView)
                containerView.addSubview(imageView)
                presentedView.center = viewCenter
                imageView.center = viewCenter
                imageView.image = image!.cropImage()
                trackViewAnimation { [unowned self] in
                    presentedView.center = startingPoint
                    imageView.center = imageStartingPoint
                    imageView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                } completion: { [unowned self] (success) in
                    transitionContext.completeTransition(success)
                    executeWhileAnimationFrom?()
                    imageView.removeFromSuperview()
                    presentedView.removeFromSuperview()
                } execute: { [unowned self] in
                    image!.containerSize = imageView.layer.presentation()!.frame.size
                    imageView.image = image!.cropImage()
                }
            }
        }
    }
}

