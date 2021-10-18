//
//  Extensions.swift
//  Extensions
//
//  Created by Archit Patel on 2021-10-13.
//

import Foundation
import UIKit

extension UIImage {
    
    var isPortrait : Bool {
        return size.height > size.width
    }
    
    var isLandscape : Bool {
        return size.width > size.height
    }
    
    var breadth : CGFloat {
        return min(size.width, size.height)
    }
    
    var breadthSize : CGSize {
        return CGSize(width: breadth, height: breadth)
    }
    
    var breadthRect: CGRect {
        return CGRect(origin: .zero, size: breadthSize)
    }
    
    var circleMasked : UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait ? floor((size.height - size.width) / 2) : 0 ), size: breadthSize)) else  {
            return nil
        }
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension Date {
    
    func longDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyy"
        return dateFormatter.string(from: self)
    }
    
    func stringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMyyymmss"
        return dateFormatter.string(from: self)
    }
    
    func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}



