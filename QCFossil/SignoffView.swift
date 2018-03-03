//
//  SignoffView.swift
//  QCFossil
//
//  Created by pacmobile on 22/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class SignoffView: UIImageView {

    var mouseSwiped:Bool = false
    var touched:Bool = false
    var lastPoint:CGPoint = CGPointMake(0.0, 0.0)
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0
    var brush:CGFloat = 2.0
    var opacity:CGFloat = 1.0
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func setBrushStyle(red:CGFloat, green:CGFloat, blue:CGFloat, brush:CGFloat=2.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.brush = brush
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        NSLog("Touches Begin")
        
        mouseSwiped = false
        
        let touch = touches.first! as UITouch
        lastPoint = touch.locationInView(self)
        
        for view in self.subviews {
            if view.isKindOfClass(ShapeView) && CGRectContainsPoint(view.frame, lastPoint) {
                return
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        mouseSwiped = true
        let touch =  touches.first! as UITouch
        let currentPoint = touch.locationInView(self)
        
        for view in self.subviews {
            if view.isKindOfClass(ShapeView) && CGRectContainsPoint(view.frame, lastPoint) {
                return
            }
        }
        
        UIGraphicsBeginImageContext(self.frame.size)
        self.image?.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        // self.image?.drawInRect(CGRectMake(0, 0, (self.image?.size.width)!, (self.image?.size.height)!))
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y)
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0)
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), CGBlendMode.Normal)
        
        CGContextStrokePath(UIGraphicsGetCurrentContext())
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        self.alpha = opacity
        UIGraphicsEndImageContext()
        
        lastPoint = currentPoint
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for view in self.subviews {
            if view.isKindOfClass(ShapeView) && CGRectContainsPoint(view.frame, lastPoint) {
                return
            }
        }
        
        if !mouseSwiped {
            UIGraphicsBeginImageContext(self.frame.size)

            //UIGraphicsBeginImageContext((self.image?.size)!)
            self.image?.drawInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
            //self.image?.drawInRect(CGRectMake(0, 0, (self.image?.size.width)!, (self.image?.size.height)!))
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), CGLineCap.Round)
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush)
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity)
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y)
            CGContextStrokePath(UIGraphicsGetCurrentContext())
            CGContextFlush(UIGraphicsGetCurrentContext())
            self.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }else{
            touched = true
        }
    }
}
