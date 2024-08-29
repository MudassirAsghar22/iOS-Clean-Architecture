//
//  UIView+Extension.swift
//  Sample App
//
//  Created by Mudassir Asghar on 08/05/2024.
//

import UIKit
import SkeletonView

extension UIView {

    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T

    }

    func shadowAndBorderForViewContainer() {
        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.backgroundColor = UIColor.clear

    }

    func shadowAndBorderForClippingView() {
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = true

    }

    func removeShadowAndBorder() {
        self.layer.cornerRadius = 0
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = false

    }

    func setBottomShadowOnly() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

    }

    func shadowAndBorderForBannerClippingView() {
        self.roundCorners(cornerRadius: 10)
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = true

    }



    func startShimmerEffect() {
        let gradientColorOne : CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        let gradientColorTwo : CGColor = UIColor(white: 0.95, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        /* Allocate the frame of the gradient layer as the view's bounds, since the layer will sit on top of the view. */

        gradientLayer.frame = self.bounds
        /* To make the gradient appear moving from left to right, we are providing it the appropriate start and end points.
         Refer to the diagram above to understand why we chose the following points.
         */

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        /* Adding the gradient layer on to the view */

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 0.9
        gradientLayer.add(animation, forKey: animation.keyPath)

        if (self.layer.sublayers?.contains(gradientLayer))! {
            return
        }

        self.layer.addSublayer(gradientLayer)

    }

    func startSkelting() {
        SkeletonAppearance.default.multilineHeight = 20
        SkeletonAppearance.default.multilineSpacing = 5
        SkeletonAppearance.default.multilineCornerRadius = 4
        self.isSkeletonable = true
        self.showAnimatedGradientSkeleton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showAnimatedGradientSkeleton()
        }

    }

    func stopSkelting() {
        self.hideSkeleton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.hideSkeleton()
        }

    }

    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.4
        animation.values = [-8.0, 8.0, -8.0, 8.0, -4.0, 4.0, -2.0, 2.0, 0.0 ]
        layer.add(animation, forKey: "shake")

    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius =  newValue
            layer.masksToBounds = newValue > 0

        }

    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }

    }

    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }

    }

    // MARK: - View Loading Indicator
    static let loadingViewTag = 1938123987
    func showLoading(style: UIActivityIndicatorView.Style = .gray) {
        var loading = viewWithTag(UIImageView.loadingViewTag) as? UIActivityIndicatorView
        if loading == nil {
            loading = UIActivityIndicatorView(style: style)
        }

        loading?.translatesAutoresizingMaskIntoConstraints = false
        loading!.startAnimating()
        loading!.hidesWhenStopped = true
        loading?.tag = UIView.loadingViewTag
        addSubview(loading!)
        loading?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loading?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

    }

    func stopLoading() {
        let loading = viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
        loading?.stopAnimating()
        loading?.removeFromSuperview()

    }

    func setHeight(_ height: CGFloat, animateTime: TimeInterval? = nil) {

        if let cons = self.constraints.first(where: { $0.firstAttribute == .height && $0.relation == .equal }) {
            cons.constant = CGFloat(height)

            if let animateTime = animateTime {
                UIView.animate(withDuration: animateTime, animations: {
                    self.superview?.layoutIfNeeded()
                })
            } else {
                self.superview?.layoutIfNeeded()
            }
        }
    }

    func disableView() {
        self.alpha = 0.5
        self.isUserInteractionEnabled = false

    }

    func enableView() {
        self.alpha = 1.0
        self.isUserInteractionEnabled = true

    }

    func startBlink() {
           UIView.animate(withDuration: 0.8,
                 delay:0.0,
                 options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                 animations: { self.alpha = 0 },
                 completion: nil)
       }

       func stopBlink() {
           layer.removeAllAnimations()
           alpha = 1
       }

//    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//            let mask = CAShapeLayer()
//            mask.path = path.cgPath
//            layer.mask = mask
//        }

    func roundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }

    func roundCorners(cornerRadius: Double, corners: CACornerMask) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [corners]
    }

    func removeExistingBanner() {
        guard let window = appDelegate?.window else { return }
        let banners = window.subviews.filter { NSStringFromClass($0.classForCoder).contains("NotificationBannerSwift") }
        for value in banners {
            value.removeFromSuperview()
        }

    }

}

