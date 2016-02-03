//
//  ViewController.swift
//  ZZCoreTextDemo
//
//  Created by duzhe on 16/1/28.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        NSAttributedString
//        NSMutableAttributedString
        
//        let str = "这是一段用来测试的字符串 this is a string for test"
//        let dic = [NSFontAttributeName:UIFont.boldSystemFontOfSize(20),
//            NSForegroundColorAttributeName:UIColor.redColor()]
////        let attrStr = NSAttributedString(string: str, attributes: dic)
////        label.attributedText = attrStr
////        label.textColor = UIColor.yellowColor()
//        
//        let mutableAttrStr = NSMutableAttributedString(string: str)
//        mutableAttrStr.addAttributes(dic, range: NSMakeRange(0, 2))
//        mutableAttrStr.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(13),NSUnderlineStyleAttributeName: 1 ], range: NSMakeRange(2,8))
//        label.attributedText = mutableAttrStr
        
        
//        let ctView = CTView()
//        ctView.frame = CGRectMake(10, 150, self.view.bounds.width - 20, 200)
//        ctView.backgroundColor = UIColor.whiteColor()
//        self.view.addSubview(ctView)
       
//        let cptView = CTPicTxtView()
//        cptView.frame = CGRectMake(10, 100, self.view.bounds.width - 20, 600)
//        cptView.backgroundColor = UIColor.whiteColor()
//        self.view.addSubview(cptView)
        
        
//        let font = UIFont.systemFontOfSize(14)
//        print(font.descender)       //-3.376953125
//        print(font.ascender)        //13.330078125
//        print(font.lineHeight)      //16.70703125
//        print(font.capHeight)       //9.8642578125
//        print(font.xHeight)         //7.369140625
//        print(font.leading)         //0.0
        
//        let ctextView = CTextView()
//        ctextView.frame = CGRectMake(10, 100, self.view.bounds.width - 20, 200)
//        ctextView.backgroundColor = UIColor.whiteColor()
//        self.view.addSubview(ctextView)
        
        
        let ctURLView = CTURLView()
        ctURLView.frame = CGRectMake(10, 100, self.view.bounds.width - 20, 300)
        ctURLView.backgroundColor = UIColor.grayColor()
        let mutableAttrStr = NSMutableAttributedString(string: ctURLView.str)
        let size = ctURLView.sizeForText(mutableAttrStr)
        ctURLView.frame.size = size
        self.view.addSubview(ctURLView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

