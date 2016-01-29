//
//  CTView.swift
//  ZZCoreTextDemo
//
//  Created by duzhe on 16/1/29.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class CTView: UIView {

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // 1
        let context = UIGraphicsGetCurrentContext()
        
        // 2
        CGContextSetTextMatrix(context, CGAffineTransformIdentity)
        CGContextTranslateCTM(context, 0, self.bounds.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        
        // 3
        let path = CGPathCreateMutable()
        
        let path1 = UIBezierPath(roundedRect: self.bounds, cornerRadius:self.bounds.size.width/2)
        
        CGPathAddRect(path, nil, self.bounds)
        
        // 4
        let attrString = "Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!"
        
        let mutableAttrStr = NSMutableAttributedString(string: attrString)
        mutableAttrStr.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(20),
            NSForegroundColorAttributeName:UIColor.redColor() ], range: NSMakeRange(0, 20))
        mutableAttrStr.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(13),NSUnderlineStyleAttributeName: 1 ], range: NSMakeRange(20,18))
        let framesetter = CTFramesetterCreateWithAttributedString(mutableAttrStr)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, mutableAttrStr.length), path1.CGPath, nil)
        
        // 5
        CTFrameDraw(frame,context!)
    }
    
}
