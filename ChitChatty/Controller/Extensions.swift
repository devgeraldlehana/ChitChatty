//
//  Extensions.swift
//  ChitChatty
//
//  Created by Gerald Lehana on 2018/03/19.
//  Copyright © 2018 Gerald Lehana. All rights reserved.
//

import UIKit

extension UIColor {
    static let chitChattyBlack = UIColor(red: 50.0/255.0, green: 74.0/255.0, blue: 94.0/255.0, alpha: 1.0)
    static let chitChattyBlue = UIColor(red: 68.0/255.0, green: 197.0/255.0, blue: 176.0/255.0, alpha: 1.0)
}

public extension UITableView {
    public func scrollToTop(animated: Bool = true) {
        setContentOffset(CGPoint.zero, animated: animated)
    }
}

public extension UITextField {
    public func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        self.leftView = imageView
        self.leftView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        self.leftViewMode = UITextFieldViewMode.always
    }
    public var isEmpty: Bool {
        return text?.isEmpty == true
    }
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UIViewController {
    class func displaySpinner(onView : UIView, title: String) -> UIView {
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = onView.bounds
        
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.color = UIColor.chitChattyBlack
        ai.center = spinnerView.center
        
        let label = UILabel()
        label.text = title
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = UIColor.chitChattyBlack
        label.center = spinnerView.center
        
        let y = ai.frame.origin.y + ai.frame.height + 5
        label.frame.origin.y = y
        
        DispatchQueue.main.async {
            //UIView.animate(withDuration: 1, animations: {
            spinnerView.addSubview(visualEffectView)
            spinnerView.addSubview(ai)
            spinnerView.addSubview(label)
            onView.addSubview(spinnerView)
            //  })
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    func presentDialog(message: String) {
        let alert = UIAlertController(title: "",
                                      message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertActionStyle.default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
