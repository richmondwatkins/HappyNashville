//
//  UIViewExtension.swift
//  HappyNashville
//
//  Created by Richmond Watkins on 4/4/15.
//  Copyright (c) 2015 Richmond Watkins. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func transformWithCompletion(completed: (result: String) -> Void) {
        let animationDuration = 0.35
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.transform = CGAffineTransformScale(self.transform, 0.001, 0.001)

            }) { (completion) -> Void in
                
//                CGAffineTransformMakeScale(finalScaleX, finalScaleY);
                
                self.transform = CGAffineTransformScale(self.transform, 0.001, 0.001)
                
                completed(result: "complete")
        }
    }
    
    func transformAndAddSubview(viewToShow: UIView) {
        let animationDuration = 0.35
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.transform = CGAffineTransformScale(self.transform, 0.001, 0.001)
            }) { (completion) -> Void in
                
                self.transform = CGAffineTransformScale(self.transform, 0.001, 0.001)
                
                self.addSubview(viewToShow)
                
                UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                    self.transform = CGAffineTransformIdentity
                })
        }
    }
    
    func transformAndRemoveSubview(viewToRemove: UIView, completed: (result: String) -> Void) {
        let animationDuration = 0.35
        
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.transform = CGAffineTransformScale(self.transform, 0.001, 0.001)
            }) { (completion) -> Void in
                
                self.transform = CGAffineTransformScale(self.transform, 0.001, 0.001)
                
                viewToRemove.removeFromSuperview()
            

                UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                    self.transform = CGAffineTransformIdentity
                }, completion: { (completion) -> Void in
                    
                    completed(result: "woo")
                })
        }
    }
    
}
