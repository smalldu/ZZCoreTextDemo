//
//  CTURLView.swift
//  ZZCoreTextDemo
//
//  Created by duzhe on 16/1/31.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class CTURLView: UIView {
    
    let SCREEN_WIDTH:CGFloat = UIScreen.mainScreen().bounds.size.width  //屏幕宽度
    let SCREEN_HEIGHT:CGFloat = UIScreen.mainScreen().bounds.size.height    //屏幕高度
  
    
    var lineHeight:CGFloat = 0
    var ctFrame:CTFrameRef?
    
    var spcialRanges = [NSRange]()
    
    //url的正则
    let regex_url = "(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&:/~\\+#]*[\\w\\-\\@?^=%&/~\\+#])?"
    
    let regex_someone = "@[^\\s@]+?\\s{1}"
    
    let str = "来一段数 @sd圣诞节 字,文本emoji的哈哈哈29993002-309-sdflslsfl是电话费卡刷卡来这来一段数字,文本emoji的哈哈哈29993002-309-sdflslsfl http://www.baidu.com 是电话费卡刷卡来这来一段数字,文本emoji http://www.zuber.im 的哈哈哈29993002-309-sdflslsfl是电话费卡 @kakakkak 刷卡来这来一段数字,文本emoji的哈哈哈29993002-309-兰emoji👿😊😊😊😊😊😊😊😊😊😊水电费洛杉矶大立科技😊😊😊😊😊😊😊索拉卡叫我😊😊😊😊😊sljwolw19287812来一段数字,文本emoji的哈哈哈29993002-309-sdflslsfl是电话费卡刷卡来这来一段数字,文本emoji的哈哈哈29993002-309-sdflslsfl是电话费卡刷卡来这来一段数字,文本emoji的哈哈哈29993002-309-sdflslsfl是电话费卡刷卡来这来一段数字,文本emoji的哈哈哈29993002-309-sdflslsfl是电话费卡刷卡来这"
    var pressRange:NSRange?
    var mutableAttrStr:NSMutableArray!
    var selfHeight:CGFloat = 0
    
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

        
        // 5 设置frame
        let mutableAttrStr = NSMutableAttributedString(string: str)
        self.spcialRanges = recognizeSpecialStringWithAttributed(mutableAttrStr)
        
        let framesetter = CTFramesetterCreateWithAttributedString(mutableAttrStr)
        ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, mutableAttrStr.length), path.CGPath, nil)
        
        // 6 取出CTLine 准备一行一行绘制
        let lines = CTFrameGetLines(ctFrame!)
        let lineCount = CFArrayGetCount(lines)
        
        
        var lineOrigins:[CGPoint] = Array(count:lineCount,repeatedValue:CGPointZero)
        
        //把frame里每一行的初始坐标写到数组里，注意CoreText的坐标是左下角为原点
        CTFrameGetLineOrigins(ctFrame!, CFRangeMake(0, 0),&lineOrigins)
        //获取属性字所占的size
        let size = sizeForText(mutableAttrStr)
        let height = size.height
//        self.frame.size.height = height
        
        let font = UIFont.systemFontOfSize(14)
        var frameY:CGFloat = 0
        // 计算每行的高度 (总高度除以行数)
        lineHeight = height/CGFloat(lineCount)
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

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //添加手势
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension CTURLView:UIGestureRecognizerDelegate{


    func tap(gesture:UITapGestureRecognizer){
    
        if gesture.state == .Ended{
            let nStr = self.str as NSString
            let pressStr = nStr.substringWithRange(self.pressRange!)
            print(pressStr)
        }
    }

    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        //点击处在特定字符串内才进行识别
        var gestureShouldBegin = false
        // 1
        let location = gestureRecognizer.locationInView(self)
        
        // 2
        let lineIndex = Int(location.y/lineHeight)
        
        print("你点击了第\(lineIndex)行")
        
        // 3 把点击的坐标转换为CoreText坐标系下
        let clickPoint = CGPointMake(location.x, lineHeight-location.y)
        
        let lines = CTFrameGetLines(self.ctFrame!);
        let lineCount = CFArrayGetCount(lines)
        if lineIndex < lineCount{
            
            let clickLine =  unsafeBitCast(CFArrayGetValueAtIndex(lines,lineIndex), CTLineRef.self)
            // 4 点击的index
            let startIndex = CTLineGetStringIndexForPosition(clickLine, clickPoint)
            
            print("strIndex = \(startIndex)")
            // 5
            for range in self.spcialRanges{
                
                if startIndex >= range.location && startIndex <= range.location + range.length{
                    
                    gestureShouldBegin = true
                    self.pressRange = range
                    print(range)
                    
                }
                
            }
            
        }
        return gestureShouldBegin
    }
    
    
    
    //识别特定字符串并改其颜色，返回识别到的字符串所在的range
    func recognizeSpecialStringWithAttributed(attrStr:NSMutableAttributedString)->[NSRange]{
        // 1
        var rangeArray = [NSRange]()
        //识别人名字
        // 2
        let atRegular = try? NSRegularExpression(pattern: regex_someone, options: NSRegularExpressionOptions.CaseInsensitive) //不区分大小写的
        // 3
        let atResults = atRegular?.matchesInString(attrStr.string, options: NSMatchingOptions.WithTransparentBounds , range: NSMakeRange(0, attrStr.length))
        // 4
        for checkResult in atResults!{
            attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(checkResult.range.location, checkResult.range.length))
            rangeArray.append(checkResult.range)
        }
        
        
        //识别链接
        let atRegular1 = try? NSRegularExpression(pattern: regex_url, options: NSRegularExpressionOptions.CaseInsensitive) //不区分大小写的
        let atResults1 = atRegular1?.matchesInString(attrStr.string, options: NSMatchingOptions.WithTransparentBounds , range: NSMakeRange(0, attrStr.length))
        
        for checkResult in atResults1!{
            attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: NSMakeRange(checkResult.range.location, checkResult.range.length))
            rangeArray.append(checkResult.range)
        }
        

        return rangeArray
    }
    
}







