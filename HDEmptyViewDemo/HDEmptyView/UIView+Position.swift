//
//  UIView+Position.swift
//  ShanXiMuseum
//
//  Created by liuyi on 2018/2/9.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    
    //frame.origin.x
    public var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    //frame.origin.y
    public var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    //frame.origin.x + frame.size.width
    public var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.origin.x = right - frame.size.width
            self.frame = frame
        }
    }
    
    //frame.origin.y + frame.size.height
    public var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.origin.y = bottom - frame.origin.y
            self.frame = frame
        }
    }
    
    //frame.size.width
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = width
            self.frame = frame
        }
    }
    
    //frame.size.height
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = height
            self.frame = frame
        }
    }
    
    //center.x
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint.init(x: centerX, y: self.center.y)
        }
    }
    
    //center.y
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint.init(x: self.center.x, y: centerY)
        }
    }
    
    //frame.origin
    public var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin = origin
            self.frame = frame
        }
    }
    
    //frame.size
    public var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = size
            self.frame = frame
        }
    }
    
    //maxX
    public var maxX: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    //maxY
    public var maxY: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    
}








