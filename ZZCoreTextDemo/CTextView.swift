//
//  CTextView.swift
//  ZZCoreTextDemo
//
//  Created by duzhe on 16/1/31.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class CTextView: UIView {
    
    let SCREEN_WIDTH:CGFloat = UIScreen.mainScreen().bounds.size.width  //屏幕宽度
    let SCREEN_HEIGHT:CGFloat = UIScreen.mainScreen().bounds.size.height    //屏幕高度
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // 1 获取上下文
        let context = UIGraphicsGetCurrentContext()
        
        // 2 转换坐标
        CGContextSetTextMatrix(context, CGAffineTransformIdentity)
        CGContextTranslateCTM(context, 0, self.bounds.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        
        // 3 绘制区域
        let path = UIBezierPath(rect: rect)
        
        // 4 创建需要绘制的文字
        let attrString = "来一段数字,文本emoji的哈哈哈29993002-309-sdflslsfl是电话费卡刷卡来这来一段数字,文本emoji的哈哈哈29993002-309-sdflslsfl是电话费卡刷卡来这来一段数字,文本emoji的哈哈哈29993002-309-sdflslsfl是电话费卡刷卡来这来一段数字,文本emoji的哈哈哈29993002-309-兰emoji👿😊😊😊😊😊😊😊😊😊😊水电费洛杉矶大立科技😊😊😊😊😊😊😊索拉卡叫我😊😊😊😊😊sljwolw19287812来一段数字,文本emoji的哈哈哈29993002-309-sdflslsfl是电话费卡刷卡来这来一段数字,文本emoji的哈哈哈29993002-309-sdflslsfl是电话费卡刷卡来这来一段数字,文本emoji的哈哈哈29993002-309-sdflslsfl是电话费卡刷卡来这来一段数字,文本emoji的哈哈哈29993002-309-sdflslsfl是电话费卡刷卡来这"
        
        // 5 设置frame
        let mutableAttrStr = NSMutableAttributedString(string: attrString)
        let framesetter = CTFramesetterCreateWithAttributedString(mutableAttrStr)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, mutableAttrStr.length), path.CGPath, nil)
        
        // 6 取出CTLine 准备一行一行绘制
        let lines = CTFrameGetLines(frame)
        let lineCount = CFArrayGetCount(lines)
        
       
        var lineOrigins:[CGPoint] = Array(count:lineCount,repeatedValue:CGPointZero)
        
        //把frame里每一行的初始坐标写到数组里，注意CoreText的坐标是左下角为原点
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0),&lineOrigins)
        //获取属性字所占的size
        let size = sizeForText(mutableAttrStr)
        let height = size.height
        
        let font = UIFont.systemFontOfSize(14)
        var frameY:CGFloat = 0
        // 计算每行的高度 (总高度除以行数)
        let lineHeight = height/CGFloat(lineCount)
        for i in 0..<lineCount{
            
            let lineRef = unsafeBitCast(CFArrayGetValueAtIndex(lines,i), CTLineRef.self)
            
            var lineAscent:CGFloat = 0
            var lineDescent:CGFloat = 0
            var leading:CGFloat = 0
            //该函数除了会设置好ascent,descent,leading之外，还会返回这行的宽度
            CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &leading)
            
            var lineOrigin = lineOrigins[i]
            
            //计算y值(注意左下角是原点)
            frameY = height - CGFloat(i + 1)*lineHeight - font.descender
            //设置Y值
            lineOrigin.y = frameY
            
            //绘制
            CGContextSetTextPosition(context,lineOrigin.x, lineOrigin.y)
            CTLineDraw(lineRef, context!)
            
            //调整坐标
            frameY = frameY - lineDescent
        }
        //
//        CTFrameDraw(frame,context!)
    }
    
    /**
     计算Size
     
     - parameter txt: 文本
     
     - returns: size
     */
    func sizeForText(mutableAttrStr:NSMutableAttributedString)->CGSize{
        //创建CTFramesetterRef实例
        let frameSetter = CTFramesetterCreateWithAttributedString(mutableAttrStr)
        
        // 获得要绘制区域的高度
        let restrictSize = CGSizeMake(SCREEN_WIDTH-20, CGFloat.max)
        let coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0) , nil, restrictSize, nil)
        return coreTextSize
    }

}
